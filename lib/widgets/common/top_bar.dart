import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';

class TopBar extends StatelessWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;

  const TopBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL, vertical: AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          // Back button or Logo
          if (showBackButton)
            IconButton(
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
              icon: const Icon(Icons.arrow_back_ios),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                const Text(
                  'InfluenceHub',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          
          // Title
          if (title != null) ...[
            const SizedBox(width: AppTheme.spacingL),
            Flexible(
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          
          const Spacer(),
          
          // Navigation (only show on landing page)
          if (!showBackButton) ...[
            // Hide navigation on small screens
            if (MediaQuery.of(context).size.width > 600) ...[
              TextButton(
                onPressed: () => context.go('/explore/influencers'),
                child: const Text('Explorar Influencers'),
              ),
              const SizedBox(width: AppTheme.spacingS),
              TextButton(
                onPressed: () => context.go('/explore/campaigns'),
                child: const Text('Explorar Campañas'),
              ),
              const SizedBox(width: AppTheme.spacingS),
              TextButton(
                onPressed: () => _scrollToHowItWorks(context),
                child: const Text('Cómo funciona'),
              ),
            ],
          ],
          
          const SizedBox(width: AppTheme.spacingL),
          
          // User actions
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoggedIn) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // User avatar and name
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: authProvider.currentUser?.avatar != null
                          ? NetworkImage(authProvider.currentUser!.avatar!)
                          : null,
                      child: authProvider.currentUser?.avatar == null
                          ? Text(
                              authProvider.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Flexible(
                      child: Text(
                        authProvider.currentUser?.name ?? 'Usuario',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'settings':
                            context.go('/settings');
                            break;
                          case 'logout':
                            authProvider.logout();
                            context.go('/');
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings, size: 20),
                              SizedBox(width: AppTheme.spacingS),
                              Text('Configuración'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 20),
                              SizedBox(width: AppTheme.spacingS),
                              Text('Cerrar sesión'),
                            ],
                          ),
                        ),
                      ],
                      child: const Icon(Icons.more_vert),
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go('/role-selection'),
                      child: const Text('Acceder'),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    ElevatedButton(
                      onPressed: () => context.go('/role-selection'),
                      child: const Text('Crear cuenta'),
                    ),
                  ],
                );
              }
            },
          ),
          
          // Custom actions
          if (actions != null) ...[
            const SizedBox(width: AppTheme.spacingM),
            ...actions!,
          ],
        ],
      ),
    );
  }

  void _scrollToHowItWorks(BuildContext context) {
    // Navigate to landing page and scroll to how it works section
    context.go('/');
    // The scroll will be handled by the landing page itself
  }
}
