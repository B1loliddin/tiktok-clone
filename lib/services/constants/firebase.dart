import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class CustomFirebase {
  static final firebaseAuth = FirebaseAuth.instance;
  static final firebaseFirestore = FirebaseFirestore.instance;
  static final firebaseStorage = FirebaseStorage.instance;
}
