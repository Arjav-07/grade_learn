import 'package:cloud_firestore/cloud_firestore.dart';

// Service class to handle all interactions with the 'users' collection in Firestore.
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  // --- 1. Function to store the User Profile (Called during registration) ---
  // The Document ID is explicitly set to the Firebase Auth UID for secure lookups.
  Future<void> createUserProfile({
    required String uid,
    required String username,
    required String email,
  }) async {
    final userDocRef = _firestore.collection(_collectionName).doc(uid);

    // Save the required fields to the database.
    await userDocRef.set({
      'username': username,
      'uid': uid,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print('User profile created for $username with UID: $uid');
  }

  // --- 2. Function to fetch user data by username (for cross-user lookup) ---
  // This function demonstrates how another user can search for a profile.
  Future<Map<String, dynamic>?> fetchUserByUsername(String targetUsername) async {
    if (targetUsername.isEmpty) return null;

    try {
      // Query the collection based on the 'username' field.
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('username', isEqualTo: targetUsername)
          .limit(1) // Assuming usernames are unique
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the data map from the found document
        return querySnapshot.docs.first.data();
      } else {
        return null; // Username not found
      }
    } catch (e) {
      print('Error fetching user by username: $e');
      return null;
    }
  }

  // --- 3. Function to fetch current user's profile by UID ---
  // This function retrieves the logged-in user's profile data
  Future<Map<String, dynamic>?> fetchUserByUid(String uid) async {
    if (uid.isEmpty) return null;

    try {
      // Get the document directly using the UID as document ID
      final docSnapshot = await _firestore
          .collection(_collectionName)
          .doc(uid)
          .get();

      if (docSnapshot.exists) {
        // Return the data map from the document
        return docSnapshot.data();
      } else {
        print('No user found with UID: $uid');
        return null;
      }
    } catch (e) {
      print('Error fetching user by UID: $e');
      return null;
    }
  }

  // --- 4. Stream to listen to current user's profile changes in real-time ---
  // This returns a stream that updates whenever the user's profile changes
  Stream<Map<String, dynamic>?> watchUserProfile(String uid) {
    if (uid.isEmpty) {
      return Stream.value(null);
    }

    return _firestore
        .collection(_collectionName)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }
}