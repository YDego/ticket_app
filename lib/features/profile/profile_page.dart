import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('איזור אישי')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(user?.email ?? 'אורח'),
            subtitle: Text(user?.uid ?? ''),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: user == null ? () => context.push('/login') : () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              context.go('/login');
            },
            icon: Icon(user == null ? Icons.login : Icons.logout),
            label: Text(user == null ? 'התחברות' : 'התנתקות'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const Text('עמודי תוכן', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final e in const [
            ['צור קשר', 'contact'],
            ['ביטול עסקה', 'cancel'],
            ['טיפים', 'tips'],
            ['תקנון', 'terms'],
            ['פרטיות', 'privacy'],
            ['משוב', 'feedback'],
            ['נגישות', 'accessibility'],
          ])
            ListTile(
              title: Text(e[0]),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => context.push('/content/${e[1]}'),
            ),
        ],
      ),
    );
  }
}
