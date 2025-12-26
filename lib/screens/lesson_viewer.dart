import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_learn/screens/course_detail_page.dart'; 
import 'package:video_player/video_player.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; 
import 'package:share_plus/share_plus.dart'; 

class LessonViewer extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onClose, onComplete;

  const LessonViewer({
    required this.lesson,
    required this.onClose,
    required this.onComplete,
    super.key,
  });

  @override
  State<LessonViewer> createState() => _LessonViewerState();
}

class _LessonViewerState extends State<LessonViewer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isFullScreen = false;
  bool _showControls = true;
  Timer? _hideTimer;
  double _playbackSpeed = 1.0;
  bool _isPdf = false;
  bool _isPdfLoading = true; // Added to prevent freezing

  @override
  void initState() {
    super.initState();
    final String url = widget.lesson.contentUrl.toLowerCase();
    _isPdf = url.contains('.pdf') || url.contains('type=pdf');

    if (!_isPdf) {
      _initPlayer();
    }
  }

  Future<void> _initPlayer() async {
    if (widget.lesson.contentUrl.startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.lesson.contentUrl));
    } else {
      _controller = VideoPlayerController.asset(widget.lesson.contentUrl);
    }

    try {
      await _controller!.initialize();
      _controller!.addListener(() {
        if (mounted) setState(() {});
      });
      setState(() => _isInitialized = true);
      _controller!.play();
      _resetHideTimer();
    } catch (e) {
      debugPrint("Video Error: $e");
    }
  }

  void _shareLesson() {
    Share.share("Check out this lesson on GradeLearn: ${widget.lesson.title}\n${widget.lesson.contentUrl}");
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) _resetHideTimer();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      }
    });
    _resetHideTimer();
  }

  void _skip(int seconds) {
    final newPosition = _controller!.value.position + Duration(seconds: seconds);
    _controller!.seekTo(newPosition);
    _resetHideTimer();
  }

  void _changeSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) _playbackSpeed = 1.5;
      else if (_playbackSpeed == 1.5) _playbackSpeed = 2.0;
      else _playbackSpeed = 1.0;
      _controller!.setPlaybackSpeed(_playbackSpeed);
    });
    _resetHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      },
      child: Scaffold(
        backgroundColor: _isFullScreen ? Colors.black : const Color(0xFFFFFFF9),
        appBar: _isFullScreen ? null : AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 30),
            onPressed: widget.onClose,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.black),
              onPressed: _shareLesson,
            ),
            const SizedBox(width: 10),
          ],
          title: Text(
            widget.lesson.title.toUpperCase(),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
        body: _isPdf ? _buildPdfView() : _buildVideoView(),
      ),
    );
  }

  Widget _buildPdfView() {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, // Critical: Background for PDF container
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
            ),
            child: Stack(
              children: [
                SfPdfViewer.network(
                  widget.lesson.contentUrl,
                  onDocumentLoaded: (details) {
                    setState(() => _isPdfLoading = false);
                  },
                  onDocumentLoadFailed: (details) {
                    setState(() => _isPdfLoading = false);
                  },
                ),
                if (_isPdfLoading)
                  const Center(child: CircularProgressIndicator(color: Colors.black)),
              ],
            ),
          ),
        ),
        _buildDescriptionAndButton(),
      ],
    );
  }

  Widget _buildVideoView() {
    return SingleChildScrollView(
      physics: _isFullScreen ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleControls,
            child: Container(
              margin: _isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(20),
              height: _isFullScreen ? MediaQuery.of(context).size.height : 220,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: _isFullScreen ? BorderRadius.zero : BorderRadius.circular(25),
                border: _isFullScreen ? null : Border.all(color: Colors.black, width: 4),
              ),
              child: _isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                        _buildVideoOverlay(),
                        Positioned(
                          bottom: 0, left: 0, right: 0,
                          child: VideoProgressIndicator(_controller!, allowScrubbing: true, colors: const VideoProgressColors(playedColor: Color(0xFFFDE798))),
                        )
                      ],
                    )
                  : const Center(child: CircularProgressIndicator(color: Color(0xFFFDE798))),
            ),
          ),
          if (!_isFullScreen) _buildDescriptionAndButton(),
        ],
      ),
    );
  }

  Widget _buildVideoOverlay() {
    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.black38,
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: const Icon(Icons.replay_10, color: Colors.white, size: 40), onPressed: _showControls ? () => _skip(-10) : null),
                  IconButton(
                    icon: Icon(_controller!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 80, color: const Color(0xFFFDE798)),
                    onPressed: _showControls ? () {
                      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                      _resetHideTimer();
                    } : null,
                  ),
                  IconButton(icon: const Icon(Icons.forward_10, color: Colors.white, size: 40), onPressed: _showControls ? () => _skip(10) : null),
                ],
              ),
            ),
            Positioned(
              bottom: 12, left: 15, right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Row(
                    children: [
                      TextButton(onPressed: _showControls ? _changeSpeed : null, child: Text("${_playbackSpeed}x", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                      IconButton(icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white, size: 28), onPressed: _showControls ? _toggleFullScreen : null),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionAndButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("LESSON CONTENT", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 10),
          Text("Review the material for ${widget.lesson.title.toLowerCase()}.", style: const TextStyle(fontSize: 16, height: 1.4)),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              widget.onComplete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("PROGRESS SAVED! 🎉", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  backgroundColor: Color(0xFFFDE798),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(20),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFB5C0FF),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
              ),
              child: const Center(
                child: Text("MARK AS COMPLETED", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}