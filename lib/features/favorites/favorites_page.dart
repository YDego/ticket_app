import 'package:flutter/material.dart';
import 'package:ticket_app/services/listings_service.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = ListingsService();
    return Scaffold(
      appBar: AppBar(title: const Text('אהבתי')),
      body: StreamBuilder<List<String>>(
        stream: svc.favoriteIdsStream(),
        builder: (c, s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final ids = s.data ?? [];
          if (ids.isEmpty) return const Center(child: Text('אין מועדפים עדיין'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, i) => ListTile(
              title: Text('מודעה #${ids[i]}'),
              trailing: TextButton(onPressed: () => svc.toggleFavorite(ids[i], false), child: const Text('הסר')),
            ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: ids.length,
          );
        },
      ),
    );
  }
}
