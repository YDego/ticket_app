import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = const [
      ['אירועים', Icons.event],
      ['נופשים', Icons.beach_access],
      ['טיסות', Icons.flight],
      ['חו״ל', Icons.public],
      ['כדורגל', Icons.sports_soccer],
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('קטגוריות')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          for (final c in cats)
            Card(
              child: InkWell(
                onTap: () {},
                child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(c[1] as IconData, size: 38),
                  const SizedBox(height: 8),
                  Text(c[0] as String),
                ])),
              ),
            )
        ],
      ),
    );
  }
}
