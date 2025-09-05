import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ticket_app/services/listings_service.dart';

class ListingDetailsPage extends StatefulWidget {
  final String id;
  const ListingDetailsPage({super.key, required this.id});

  @override
  State<ListingDetailsPage> createState() => _ListingDetailsPageState();
}

class _ListingDetailsPageState extends State<ListingDetailsPage> {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _svc = ListingsService();

  Future<Map<String, dynamic>?> _load() async {
    final doc = await _db.collection('listings').doc(widget.id).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    final mediaSnap = await doc.reference.collection('media').orderBy('sortIndex').get();
    final media = mediaSnap.docs.map((d) => d.data()).toList();

    String? firstUrl;
    if (media.isNotEmpty && media.first['filePath'] != null) {
      firstUrl = await _storage.ref(media.first['filePath'] as String).getDownloadURL();
    }

    return {
      'id': doc.id,
      ...data,
      'media': media,
      'firstUrl': firstUrl,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _load(),
      builder: (c, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!s.hasData || s.data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('המודעה לא נמצאה')),
          );
        }
        final it = s.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(it['title'] ?? 'מודעה'),
            actions: [
              IconButton(
                tooltip: 'שיתוף',
                onPressed: () {
                  final url = Uri.parse('https://example.com/listing/${it['id']}'); // החלף בקישור אמיתי כשיהיה Hosting
                  SharePlus.instance.share(
                    ShareParams(
                      text: 'תראה את המודעה הזו:',
                      uri: url, // ✅ API חדש דורש ShareParams
                    ),
                  );
                },
                icon: const Icon(Icons.ios_share),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (it['firstUrl'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(it['firstUrl'] as String, fit: BoxFit.cover),
                ),
              const SizedBox(height: 12),
              Text(it['title'] ?? '', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              if (it['pricePerUnit'] != null)
                Text('₪${(it['pricePerUnit']).toString()}', style: Theme.of(context).textTheme.titleMedium),
              if ((it['locationText'] ?? '').toString().isNotEmpty)
                Text(it['locationText'], style: Theme.of(context).textTheme.bodyMedium),
              const Divider(height: 24),
              Text((it['description'] ?? '') as String),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _svc.toggleFavorite(it['id'] as String, true),
                icon: const Icon(Icons.favorite_border),
                label: const Text('אהבתי'),
              ),
            ],
          ),
        );
      },
    );
  }
}
