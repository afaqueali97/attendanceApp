import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../utils/common_code.dart';
import 'firebase_storage_service.dart';

class FirestoreService extends GetxService {
  static FirestoreService get instance => Get.find<FirestoreService>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorageService storageService = Get.find<FirebaseStorageService>();

  // Collection reference for users
  CollectionReference get usersCollection => _firestore.collection('users');

  // Add user to Firestore with image in Storage
  Future<void> addUser({required String name, required Uint8List imageBytes,}) async {
    try {
      // Upload image to Firebase Storage
      final String imageUrl = await storageService.uploadImage(imageBytes, name);

      // Save user data to Firestore with the image URL
      await usersCollection.doc(name).set({
        'name': name,
        'imageUrl': imageUrl,
        'registeredAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      CommonCode().showToast(message: 'Failed to sync user to cloud: $e');
      rethrow;
    }
  }

  // Delete user from Firestore and Storage
  Future<void> deleteUser(String name) async {
    try {
      // Delete from Firestore
      await usersCollection.doc(name).delete();

      // Delete image from Storage
      await storageService.deleteImage(name);
    } catch (e) {
      CommonCode().showToast(message: 'Failed to delete user from cloud: $e');
      rethrow;
    }
  }

  // Get all users from Firestore
  Future<Map<String, dynamic>> getUsers() async {
    try {
      final QuerySnapshot snapshot = await usersCollection.get();
      final Map<String, dynamic> users = {};

      for (var doc in snapshot.docs) {
        users[doc.id] = doc.data();
      }

      return users;
    } catch (e) {
      CommonCode().showToast(message: 'Failed to fetch users from cloud: $e');
      rethrow;
    }
  }

  // Check if user exists in Firestore
  Future<bool> userExists(String name) async {
    try {
      final DocumentSnapshot doc = await usersCollection.doc(name).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Update user data in Firestore
  Future<void> updateUser(String name, Uint8List imageBytes) async {
    try {
      // Upload new image to Firebase Storage
      final String imageUrl = await storageService.uploadImage(imageBytes, name);

      // Update user data in Firestore
      await usersCollection.doc(name).update({
        'imageUrl': imageUrl,
        'lastSynced': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      CommonCode().showToast(message: 'Failed to update user: $e');
      rethrow;
    }
  }

  // Save user data to Firestore
  Future<void> saveUserData({
    required String userId,
    required String fullName,
    required String email,
    required String cnic,
    required String mobileNo,
  }) async {
    try {
      await usersCollection.doc(userId).set({
        'userId': userId,
        'fullName': fullName,
        'email': email,
        'cnic': cnic,
        'mobileNo': mobileNo,
        'registeredAt': FieldValue.serverTimestamp(),
        'hasFaceData': false, // Initially no face data
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to save user data: $e');
      rethrow;
    }
  }

// Check if user has face data
  Future<bool> userHasFaceData(String userId) async {
    try {
      final DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        return doc.get('hasFaceData') ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

// Update user face data status
  Future<void> updateUserFaceData(String userId, bool hasFaceData) async {
    try {
      await usersCollection.doc(userId).update({
        'hasFaceData': hasFaceData,
        'faceDataUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update face data status: $e');
      rethrow;
    }
  }

// Download face data to local storage
  Future<void> downloadFaceData(String userId) async {
    try {
      final DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if (doc.exists && doc.get('hasFaceData')) {
        // Get the face data from Storage
        final Uint8List faceData = await storageService.getImage(userId);

        // Save to local Hive database
        final box = Hive.box('face_db');
        await box.put(userId, faceData);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to download face data: $e');
      rethrow;
    }
  }
}