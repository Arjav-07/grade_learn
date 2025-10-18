import 'package:cloud_firestore/cloud_firestore.dart';

// Service class to handle all interactions with the 'users' collection in Firestore.
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  // --- 1. Create User Profile (Called during registration) ---
  Future<void> createUserProfile({
    required String uid,
    required String username,
    required String email,
  }) async {
    final userDocRef = _firestore.collection(_collectionName).doc(uid);
    await userDocRef.set({
      'username': username,
      'uid': uid,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'progress': 0, // Example of adding a default field
    });
    print('User profile created for $username with UID: $uid');
  }

  // --- 2. Fetch User Data by Username ---
  Future<Map<String, dynamic>?> fetchUserByUsername(String targetUsername) async {
    if (targetUsername.isEmpty) return null;
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('username', isEqualTo: targetUsername)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user by username: $e');
      return null;
    }
  }

  // --- 3. Fetch Current User's Profile by UID ---
  Future<Map<String, dynamic>?> fetchUserByUid(String uid) async {
    if (uid.isEmpty) return null;
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(uid).get();
      if (docSnapshot.exists) {
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

  // --- 4. Stream User Profile Changes ---
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

  // --- 5. (NEW) Update User Profile ---
  // This function allows updating one or more fields of a user's profile.
  // The 'data' parameter is a map of fields to update, e.g., {'username': 'newUsername'}
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    if (uid.isEmpty) return;
    try {
      final userDocRef = _firestore.collection(_collectionName).doc(uid);
      await userDocRef.update(data);
      print('User profile for UID: $uid updated successfully.');
    } catch (e) {
      print('Error updating user profile: $e');
      // Optionally re-throw the error to handle it in the UI
      // throw e;
    }
  }

  // --- 6. (NEW) Delete User Profile ---
  // This permanently deletes a user's document from Firestore.
  // Typically called when a user deletes their account.
  Future<void> deleteUserProfile(String uid) async {
    if (uid.isEmpty) return;
    try {
      await _firestore.collection(_collectionName).doc(uid).delete();
      print('User profile for UID: $uid deleted successfully.');
    } catch (e) {
      print('Error deleting user profile: $e');
    }
  }

  // --- 7. (NEW) Check if Username Exists ---
  // A utility function to check for username uniqueness before registration.
  // Returns 'true' if the username is already taken.
  Future<bool> checkIfUsernameExists(String username) async {
    if (username.isEmpty) return false;
    try {
      final result = await _firestore
          .collection(_collectionName)
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username existence: $e');
      return false; // Fails safe, assuming username doesn't exist
    }
  }
}