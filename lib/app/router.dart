import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ticket_app/app/shell.dart';
import 'package:ticket_app/features/listings/feed_page.dart';
import 'package:ticket_app/features/categories/categories_page.dart';
import 'package:ticket_app/features/search/search_page.dart';
import 'package:ticket_app/features/listings/post_listing_page.dart';
import 'package:ticket_app/features/favorites/favorites_page.dart';
import 'package:ticket_app/features/profile/profile_page.dart';
import 'package:ticket_app/features/auth/login_page.dart';
import 'package:ticket_app/features/auth/register_page.dart';
import 'package:ticket_app/features/content/content_page.dart';
import 'package:ticket_app/features/listings/listing_details_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}

final _auth = FirebaseAuth.instance;

final router = GoRouter(
  debugLogDiagnostics: false,
  refreshListenable: GoRouterRefreshStream(_auth.authStateChanges()),
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (c, s, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', name: 'feed', builder: (c, s) => const FeedPage()),
        GoRoute(path: '/categories', name: 'categories', builder: (c, s) => const CategoriesPage()),
        GoRoute(path: '/search', name: 'search', builder: (c, s) => const SearchPage()),
        GoRoute(path: '/favorites', name: 'favorites', builder: (c, s) => const FavoritesPage()),
        GoRoute(path: '/profile', name: 'profile', builder: (c, s) => const ProfilePage()),
      ],
    ),
    GoRoute(path: '/post', name: 'post', builder: (c, s) => const PostListingPage()),
    GoRoute(path: '/login', name: 'login', builder: (c, s) => const LoginPage()),
    GoRoute(path: '/register', name: 'register', builder: (c, s) => const RegisterPage()),
    GoRoute(path: '/content/:slug', name: 'content', builder: (c, s) => ContentPage(slug: s.pathParameters['slug']!)),
    GoRoute(path: '/listing/:id', name: 'listing', builder: (c, s) => ListingDetailsPage(id: s.pathParameters['id']!)),
  ],
  redirect: (context, state) {
    final here = state.uri.toString();
    final loggedIn = _auth.currentUser != null;
    final isAuthRoute = here == '/login' || here == '/register';
    final needsAuth = here.startsWith('/post') || here.startsWith('/favorites') || here.startsWith('/profile');
    if (!loggedIn && needsAuth) return '/login';
    if (loggedIn && isAuthRoute) return '/';
    return null;
  },
);
