import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> removeData({@required String path}) async { 
    print('deleted path is $path');
    final reference = Firestore.instance.document(path);
    return reference.delete();
  }

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

  Future<void> updateData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.updateData(data);
  }
  
  Stream<List<T>> collectionStream<T> ({
    @required String path,
    @required T builder(Map<String, dynamic> data, String campaignId),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map((snapshot) => builder(snapshot.data, snapshot.documentID)).toList());
  }
}