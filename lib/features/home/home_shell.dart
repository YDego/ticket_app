import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatefulWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indexFromLocation(String location) {
    return switch (location) {
      '/' => 0,
      '/search' => 1,
      '/post' => 2,
      '/favorites' => 3,
      '/me' => 4,
      _ => 0,
    };
  }

  void _onTap(int index) {
    final paths = ['/', '/search', '/post', '/favorites', '/me'];
    context.go(paths[index]);
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(loc);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'בית'),
          NavigationDestination(icon: Icon(Icons.search), label: 'חיפוש'),
          NavigationDestination(icon: Icon(Icons.add_box_outlined), label: 'פרסום'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'אהבתי'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'אישי'),
        ],
      ),
    );
  }
}
