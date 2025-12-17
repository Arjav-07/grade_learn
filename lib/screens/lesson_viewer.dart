import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_learn/screens/skill_detail_page.dart'; // Ensure this contains your Lesson model
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isFullScreen = false;
  bool _showControls = true;
  Timer? _hideTimer;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (widget.lesson.contentUrl.startsWith('http')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.lesson.contentUrl));
    } else {
      _controller = VideoPlayerController.asset(widget.lesson.contentUrl);
    }

    try {
      await _controller.initialize();
      _controller.addListener(() {
        if (mounted) setState(() {});
      });
      setState(() => _isInitialized = true);
      _controller.play();
      _resetHideTimer();
    } catch (e) {
      debugPrint("Video Error: $e");
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
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
    // Force reset orientation on exit
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    _controller.dispose();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      }
    });
    _resetHideTimer();
  }

  void _skip(int seconds) {
    final newPosition = _controller.value.position + Duration(seconds: seconds);
    _controller.seekTo(newPosition);
    _resetHideTimer();
  }

  void _changeSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) _playbackSpeed = 1.5;
      else if (_playbackSpeed == 1.5) _playbackSpeed = 2.0;
      else _playbackSpeed = 1.0;
      _controller.setPlaybackSpeed(_playbackSpeed);
    });
    _resetHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    // PopScope ensures orientation resets if user uses the back gesture
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      },
      child: Scaffold(
        backgroundColor: _isFullScreen ? Colors.black : Colors.white,
        appBar: _isFullScreen
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 30),
                  onPressed: widget.onClose,
                ),
                title: Text(
                  widget.lesson.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
        body: SingleChildScrollView(
          // Disable scroll during full screen to prevent UI shifting
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
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                            
                            // Animated Controls
                            AnimatedOpacity(
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
                                          IconButton(
                                            icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                                            onPressed: _showControls ? () => _skip(-10) : null,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause_circle_filled
                                                  : Icons.play_circle_fill,
                                              size: 80,
                                              color: const Color(0xFFFDE798),
                                            ),
                                            onPressed: _showControls ? () {
                                              _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                              _resetHideTimer();
                                            } : null,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                                            onPressed: _showControls ? () => _skip(10) : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 15,
                                      right: 15,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                          Row(
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.white24,
                                                  minimumSize: const Size(45, 30),
                                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                ),
                                                onPressed: _showControls ? _changeSpeed : null,
                                                child: Text("${_playbackSpeed}x", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                              ),
                                              const SizedBox(width: 8),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white, size: 28),
                                                onPressed: _showControls ? _toggleFullScreen : null,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0, left: 0, right: 0,
                              child: VideoProgressIndicator(
                                _controller, 
                                allowScrubbing: true, 
                                colors: const VideoProgressColors(
                                  playedColor: Color(0xFFFDE798),
                                  bufferedColor: Colors.white24,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            )
                          ],
                        )
                      : const Center(child: CircularProgressIndicator(color: Color(0xFFFDE798))),
                ),
              ),
              
              // This section scrolls if it's too tall for the screen
              if (!_isFullScreen) Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("LESSON DESCRIPTION", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                      "In this video, we explore ${widget.lesson.title.toLowerCase()}.", 
                      style: const TextStyle(fontSize: 16, height: 1.4)
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB5C0FF),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          side: const BorderSide(color: Colors.black, width: 2.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: widget.onComplete,
                        child: const Text("MARK AS COMPLETED", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 30), // Bottom padding for scroll room
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}