import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ListingInput {
  final String title;
  final String? description;
  final String? categoryId;
  final String? locationText;
  final double? pricePerUnit;
  final int quantity;
  final List<dynamic> images; // File (mobile/desktop) or Uint8List (web)
  ListingInput({
    required this.title,
    this.description,
    this.categoryId,
    this.locationText,
    this.pricePerUnit,
    this.quantity = 1,
    this.images = const [],
  });
}

class ListingsService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> createListing(ListingInput data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not logged in');

    final doc = await _db.collection('listings').add({
      'ownerId': uid,
      'categoryId': data.categoryId,
      'title': data.title,
      'description': data.description,
      'locationText': data.locationText,
      'pricePerUnit': data.pricePerUnit,
      'quantity': data.quantity,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (data.images.isNotEmpty) {
      await _uploadImages(uid: uid, listingId: doc.id, images: data.images);
    }
    return doc.id;
  }

  Future<void> _uploadImages({required String uid, required String listingId, required List<dynamic> images}) async {
    int sort = 0;
    for (final img in images) {
      final path = 'listing-images/$uid/$listingId/${DateTime.now().millisecondsSinceEpoch}-$sort.jpg';
      final ref = _storage.ref(path);
      if (kIsWeb) {
        await ref.putData(img as Uint8List);
      } else {
        await ref.putFile(img as File);
      }
      await _db.collection('listings').doc(listingId).collection('media').add({
        'filePath': path,
        'sortIndex': sort++,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchFeed({int limit = 30}) async {
    final snap = await _db.collection('listings')
      .where('status', isEqualTo: 'active')
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .get();

    final items = <Map<String, dynamic>>[];
    for (final d in snap.docs) {
      final mediaSnap = await d.reference.collection('media').orderBy('sortIndex').limit(1).get();
      final first = mediaSnap.docs.isNotEmpty ? mediaSnap.docs.first.data() : null;
      items.add({'id': d.id, ...d.data(), 'media': first == null ? [] : [first]});
    }
    return items;
  }

  Future<String> publicImageUrl(String filePath) async {
    return await _storage.ref(filePath).getDownloadURL();
  }

  // Favorites
  Future<void> toggleFavorite(String listingId, bool toFav) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not logged in');
    final ref = _db.collection('profiles').doc(uid).collection('favorites').doc(listingId);
    if (toFav) {
      await ref.set({'listingId': listingId, 'createdAt': FieldValue.serverTimestamp()});
    } else {
      await ref.delete();
    }
  }

  Stream<List<String>> favoriteIdsStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _db.collection('profiles').doc(uid).collection('favorites').snapshots().map(
      (s) => s.docs.map((d) => d.id).toList(),
    );
  }
}
