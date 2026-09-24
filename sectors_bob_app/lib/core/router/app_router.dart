import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/forgot_password_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/belajar/article_detail_screen.dart';
import '../../features/belajar/belajar_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/stock_detail/stock_detail_screen.dart';
import '../theme/app_colors.dart';
import 'page_transitions.dart';

/// Route path constants, kept in one place so screens can navigate by name
/// without string typos.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';

  /// Sign up. Navigated to from the login screen.
  static const String signup = '/signup';

  /// Forgot password. Navigated to from the login screen.
  static const String forgotPassword = '/forgot-password';

  /// Belajar tab (videos and news). Replaces the old news route as the first
  /// shell branch.
  static const String belajar = '/belajar';

  /// The in-app article reader. Navigate with '/article/art-ihsg'.
  static const String articlePattern = '/article/:id';
  static String article(String id) => '/article/$id';
  static const String home = '/home';
  static const String ai = '/ai';

  /// Full-screen stock search, pushed from the Home search bar.
  static const String search = '/search';

  /// Profile, pushed from the Home avatar.
  static const String profile = '/profile';

  /// Edit profile, pushed from the profile screen.
  static const String editProfile = '/profile/edit';

  /// Builds the AI tab location, optionally carrying a seed prompt or a ticker
  /// so the chat can open pre-filled. FEAT-003 reads these query parameters.
  static String aiWith({String? seed, String? ticker}) {
    final Map<String, String> query = <String, String>{};
    if (seed != null && seed.trim().isNotEmpty) {
      query['seed'] = seed.trim();
    }
    if (ticker != null && ticker.trim().isNotEmpty) {
      query['ticker'] = ticker.trim();
    }
    if (query.isEmpty) {
      return ai;
    }
    return Uri(path: ai, queryParameters: query).toString();
  }

  /// Stock detail. Navigate with '/stock/BBCA'.
  static const String stockPattern = '/stock/:ticker';
  static String stock(String ticker) => '/stock/$ticker';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorBelajar = GlobalKey<NavigatorState>();
final _shellNavigatorHome = GlobalKey<NavigatorState>();
final _shellNavigatorAi = GlobalKey<NavigatorState>();

/// The app router.
///
/// FEAT-002 and FEAT-003 replace the placeholder builders below with the real
/// screens. The route graph itself is final: splash, onboarding, auth, a
/// three-tab shell (Berita, Beranda, AI), and stock detail.
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((ref) {
  // No redirect/auth guard is wired here on purpose: this is a mock-only hero
  // flow demo, so /home, /ai, and /stock/:ticker stay directly reachable for
  // easy walkthroughs. Before shipping a real backend, add a `redirect` that
  // watches authStateProvider and sends unauthenticated users to /auth while
  // keeping the Splash -> Onboarding -> Auth -> Home path intact.
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            AppPageTransitions.fadeThrough(state, const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            AppPageTransitions.fadeThrough(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.auth,
        pageBuilder: (context, state) =>
            AppPageTransitions.fadeThrough(state, const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.signup,
        pageBuilder: (context, state) =>
            AppPageTransitions.slideUp(state, const SignupScreen()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) =>
            AppPageTransitions.slideUp(state, const ForgotPasswordScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _HomeShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBelajar,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.belajar,
                pageBuilder: (context, state) =>
                    AppPageTransitions.fadeThrough(state, const BelajarScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    AppPageTransitions.fadeThrough(state, const HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAi,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.ai,
                pageBuilder: (context, state) {
                  final String? seed = state.uri.queryParameters['seed'];
                  final String? ticker = state.uri.queryParameters['ticker'];
                  // A key derived from the seed and ticker remounts the chat
                  // screen when Home or Stock Detail opens it with a new prompt,
                  // which resets and re-seeds the conversation. Without a new
                  // seed the branch stays alive (indexedStack) and an existing
                  // conversation is preserved across tab switches on purpose.
                  return AppPageTransitions.fadeThrough(
                    state,
                    ChatScreen(
                      key: ValueKey<String>('ai-${seed ?? ''}-${ticker ?? ''}'),
                      seed: seed,
                      ticker: ticker,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            AppPageTransitions.slideUp(state, const SearchScreen()),
      ),
      GoRoute(
        path: AppRoutes.profile,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            AppPageTransitions.slideUp(state, const ProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) =>
            AppPageTransitions.slideUp(state, const EditProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.articlePattern,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final String id = state.pathParameters['id'] ?? '';
          return AppPageTransitions.slideUp(
            state,
            ArticleDetailScreen(articleId: id),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.stockPattern,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final String ticker = state.pathParameters['ticker'] ?? '';
          return AppPageTransitions.slideUp(
            state,
            StockDetailScreen(ticker: ticker.toUpperCase()),
          );
        },
      ),
    ],
  );
});

/// The three-tab shell. Beranda sits in the center as the hero destination.
class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.accentPress,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              );
            }
            return const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.accentPress);
            }
            return const IconThemeData(color: AppColors.textSecondary);
          }),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.surfaceAlt,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school),
              label: 'Belajar',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'BOB AI',
            ),
          ],
        ),
      ),
    );
  }
}

