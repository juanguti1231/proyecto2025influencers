import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../utils/theme.dart';

class SideBar extends StatelessWidget {
  final String currentRoute;
  final Widget? child;

  const SideBar({
    super.key,
    required this.currentRoute,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isLoggedIn) return const SizedBox.shrink();
        
        final user = authProvider.currentUser!;
        final navigationItems = _getNavigationItems(user.role);
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar
            Container(
              width: 280,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: AppTheme.surfaceColor,
                border: Border(
                  right: BorderSide(color: AppTheme.textTertiary, width: 0.5),
                ),
              ),
              child: Column(
                children: [
                  // User info
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingL),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppTheme.textTertiary, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: user.avatar != null
                              ? NetworkImage(user.avatar!)
                              : null,
                          child: user.avatar == null
                              ? Text(
                                  user.name.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _getRoleDisplayName(user.role),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Navigation items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                      itemCount: navigationItems.length,
                      itemBuilder: (context, index) {
                        final item = navigationItems[index];
                        final isSelected = currentRoute == item.route;
                        
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM, vertical: 2),
                          child: ListTile(
                            leading: Icon(
                              item.icon,
                              color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                              size: 20,
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            trailing: item.badge != null
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      item.badge.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                            selected: isSelected,
                            selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            ),
                            onTap: () {
                              if (item.route != currentRoute) {
                                context.go(item.route);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content
            if (child != null)
              Expanded(child: child!),
          ],
        );
      },
    );
  }

  List<NavigationItem> _getNavigationItems(UserRole role) {
    switch (role) {
      case UserRole.company:
        return [
          NavigationItem(
            title: 'Resumen',
            icon: Icons.dashboard_rounded,
            route: '/dashboard/company',
          ),
          NavigationItem(
            title: 'Mis Campañas',
            icon: Icons.campaign_rounded,
            route: '/dashboard/company',
            badge: 3, // Mock data
          ),
          NavigationItem(
            title: 'Postulaciones',
            icon: Icons.people_rounded,
            route: '/dashboard/company',
            badge: 5, // Mock data
          ),
          NavigationItem(
            title: 'Mensajes',
            icon: Icons.message_rounded,
            route: '/messaging',
            badge: 2, // Mock data
          ),
          NavigationItem(
            title: 'Pagos',
            icon: Icons.payment_rounded,
            route: '/dashboard/company',
          ),
          NavigationItem(
            title: 'Reseñas',
            icon: Icons.star_rounded,
            route: '/dashboard/company',
          ),
          NavigationItem(
            title: 'Configuración',
            icon: Icons.settings_rounded,
            route: '/settings',
          ),
        ];
      case UserRole.influencer:
        return [
          NavigationItem(
            title: 'Resumen',
            icon: Icons.dashboard_rounded,
            route: '/dashboard/influencer',
          ),
          NavigationItem(
            title: 'Mis Postulaciones',
            icon: Icons.assignment_rounded,
            route: '/dashboard/influencer',
            badge: 4, // Mock data
          ),
          NavigationItem(
            title: 'Campañas Guardadas',
            icon: Icons.bookmark_rounded,
            route: '/dashboard/influencer',
          ),
          NavigationItem(
            title: 'Mensajes',
            icon: Icons.message_rounded,
            route: '/messaging',
            badge: 1, // Mock data
          ),
          NavigationItem(
            title: 'Pagos',
            icon: Icons.payment_rounded,
            route: '/dashboard/influencer',
          ),
          NavigationItem(
            title: 'Reseñas',
            icon: Icons.star_rounded,
            route: '/dashboard/influencer',
          ),
          NavigationItem(
            title: 'Configuración',
            icon: Icons.settings_rounded,
            route: '/settings',
          ),
        ];
      case UserRole.admin:
        return [
          NavigationItem(
            title: 'Panel Admin',
            icon: Icons.admin_panel_settings_rounded,
            route: '/dashboard/admin',
          ),
          NavigationItem(
            title: 'Usuarios',
            icon: Icons.people_rounded,
            route: '/dashboard/admin',
          ),
          NavigationItem(
            title: 'Campañas',
            icon: Icons.campaign_rounded,
            route: '/dashboard/admin',
          ),
          NavigationItem(
            title: 'Reportes',
            icon: Icons.report_rounded,
            route: '/dashboard/admin',
          ),
        ];
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.company:
        return 'Empresa';
      case UserRole.influencer:
        return 'Influencer';
      case UserRole.admin:
        return 'Administrador';
    }
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final String route;
  final int? badge;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.route,
    this.badge,
  });
}
