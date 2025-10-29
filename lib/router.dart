import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'screens/landing_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/explore/influencers_screen.dart';
import 'screens/explore/campaigns_screen.dart';
import 'screens/profile/influencer_profile_screen.dart';
import 'screens/profile/company_profile_screen.dart';
import 'screens/dashboard/company_dashboard_screen.dart';
import 'screens/dashboard/influencer_dashboard_screen.dart';
import 'screens/dashboard/admin_dashboard_screen.dart';
import 'screens/campaigns/campaign_detail_screen.dart';
import 'screens/campaigns/create_campaign_screen.dart';
import 'screens/messaging/messaging_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'providers/auth_provider.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Public routes
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        name: 'role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'influencer';
          return RegisterScreen(role: role);
        },
      ),
      GoRoute(
        path: '/explore/influencers',
        name: 'explore-influencers',
        builder: (context, state) => const InfluencersScreen(),
      ),
      GoRoute(
        path: '/explore/campaigns',
        name: 'explore-campaigns',
        builder: (context, state) => const CampaignsScreen(),
      ),
      GoRoute(
        path: '/profile/influencer/:id',
        name: 'influencer-profile',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return InfluencerProfileScreen(influencerId: id);
        },
      ),
      GoRoute(
        path: '/profile/company/:id',
        name: 'company-profile',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CompanyProfileScreen(companyId: id);
        },
      ),
      GoRoute(
        path: '/campaign/:id',
        name: 'campaign-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CampaignDetailScreen(campaignId: id);
        },
      ),
      GoRoute(
        path: '/campaign/create',
        name: 'create-campaign',
        builder: (context, state) => const CreateCampaignScreen(),
      ),
      GoRoute(
        path: '/campaign/edit/:id',
        name: 'edit-campaign',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreateCampaignScreen(campaignId: id);
        },
      ),
      GoRoute(
        path: '/messaging',
        name: 'messaging',
        builder: (context, state) => const MessagingScreen(),
      ),
      GoRoute(
        path: '/messaging/:threadId',
        name: 'messaging-thread',
        builder: (context, state) {
          final threadId = state.pathParameters['threadId']!;
          return MessagingScreen(threadId: threadId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // Dashboard routes with role-based access
      GoRoute(
        path: '/dashboard/company',
        name: 'company-dashboard',
        builder: (context, state) => const CompanyDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/influencer',
        name: 'influencer-dashboard',
        builder: (context, state) => const InfluencerDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/admin',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
    redirect: (context, state) {
      final authProvider = context.read<AuthProvider>();
      final isLoggedIn = authProvider.currentUser != null;
      final isAuthRoute = state.matchedLocation.startsWith('/role-selection') ||
          state.matchedLocation.startsWith('/register');
      final isPublicRoute = state.matchedLocation == '/' ||
          state.matchedLocation.startsWith('/explore') ||
          state.matchedLocation.startsWith('/profile') ||
          state.matchedLocation.startsWith('/campaign') ||
          state.matchedLocation.startsWith('/messaging');

      // If not logged in and trying to access protected routes
      if (!isLoggedIn && !isAuthRoute && !isPublicRoute) {
        return '/role-selection';
      }

      // If logged in and trying to access auth routes
      if (isLoggedIn && isAuthRoute) {
        final user = authProvider.currentUser!;
        switch (user.role) {
          case UserRole.company:
            return '/dashboard/company';
          case UserRole.influencer:
            return '/dashboard/influencer';
          case UserRole.admin:
            return '/dashboard/admin';
        }
      }

      // If logged in and accessing root, redirect to appropriate dashboard
      if (isLoggedIn && state.matchedLocation == '/') {
        final user = authProvider.currentUser!;
        switch (user.role) {
          case UserRole.company:
            return '/dashboard/company';
          case UserRole.influencer:
            return '/dashboard/influencer';
          case UserRole.admin:
            return '/dashboard/admin';
        }
      }

      return null;
    },
  );
}
