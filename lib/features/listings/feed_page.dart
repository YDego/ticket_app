import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_app/services/listings_service.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _svc = ListingsService();
  late Future<List<Map<String, dynamic>>> _future;
  @override
  void initState() { super.initState(); _future = _svc.fetchFeed(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('בית / פיד')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) return Center(child: Text('שגיאה: ${s.error}'));
          final items = s.data ?? [];
          if (items.isEmpty) return const Center(child: Text('אין מודעות כרגע'));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final it = items[i];
              final media = (it['media'] as List?) ?? [];
              final path = media.isNotEmpty ? media.first['filePath'] as String : null;
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (path != null)
                      FutureBuilder<String>(
                        future: _svc.publicImageUrl(path),
                        builder: (c, s) {
                          if (!s.hasData) {
                            return const AspectRatio(aspectRatio: 16 / 9,
                              child: Center(child: CircularProgressIndicator()));
                          }
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(imageUrl: s.data!, fit: BoxFit.cover),
                          );
                        },
                      ),
                    ListTile(
                      title: Text(it['title'] ?? ''),
                      subtitle: Text((it['description'] ?? '') as String,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: Text(it['pricePerUnit']?.toString() ?? ''),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: OverflowBar(
                        alignment: MainAxisAlignment.end,
                        spacing: 8,
                        overflowAlignment: OverflowBarAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => context.push('/listing/${it['id']}'),
                            child: const Text('פתח'),
                          ),
                          TextButton(
                            onPressed: () => _svc.toggleFavorite(it['id'], true),
                            child: const Text('אהבתי'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
