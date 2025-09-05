import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _q = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('חיפוש')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _q, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'חפש מודעות...')),
            const SizedBox(height: 12),
            const Expanded(child: Center(child: Text('תוצאות יחזרו כאן (לביצוע בהמשך עם Firestore queries)'))),
          ],
        ),
      ),
    );
  }
}
