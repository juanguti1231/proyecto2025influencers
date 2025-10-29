import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/top_bar.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  String _selectedLanguage = 'Español';
  String _selectedTheme = 'Claro';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBar(
            title: 'Configuración',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  _buildSection(
                    'Perfil',
                    Icons.person_rounded,
                    [
                      _buildListTile(
                        'Editar perfil',
                        'Actualiza tu información personal',
                        Icons.edit_rounded,
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de editar perfil próximamente'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        'Cambiar foto de perfil',
                        'Actualiza tu avatar',
                        Icons.camera_alt_rounded,
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de cambiar foto próximamente'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Notifications Section
                  _buildSection(
                    'Notificaciones',
                    Icons.notifications_rounded,
                    [
                      _buildSwitchTile(
                        'Notificaciones generales',
                        'Recibe notificaciones importantes',
                        _notificationsEnabled,
                        (value) => setState(() => _notificationsEnabled = value),
                      ),
                      _buildSwitchTile(
                        'Notificaciones por email',
                        'Recibe actualizaciones por correo',
                        _emailNotifications,
                        (value) => setState(() => _emailNotifications = value),
                      ),
                      _buildSwitchTile(
                        'Notificaciones push',
                        'Recibe notificaciones en el navegador',
                        _pushNotifications,
                        (value) => setState(() => _pushNotifications = value),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Preferences Section
                  _buildSection(
                    'Preferencias',
                    Icons.settings_rounded,
                    [
                      _buildDropdownTile(
                        'Idioma',
                        'Selecciona tu idioma preferido',
                        Icons.language_rounded,
                        _selectedLanguage,
                        ['Español', 'English'],
                        (value) => setState(() => _selectedLanguage = value!),
                      ),
                      _buildDropdownTile(
                        'Tema',
                        'Selecciona el tema de la aplicación',
                        Icons.palette_rounded,
                        _selectedTheme,
                        ['Claro', 'Oscuro', 'Automático'],
                        (value) => setState(() => _selectedTheme = value!),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Account Section
                  _buildSection(
                    'Cuenta',
                    Icons.account_circle_rounded,
                    [
                      _buildListTile(
                        'Cambiar contraseña',
                        'Actualiza tu contraseña de acceso',
                        Icons.lock_rounded,
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de cambiar contraseña próximamente'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                      _buildListTile(
                        'Verificar cuenta',
                        'Verifica tu identidad',
                        Icons.verified_rounded,
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funcionalidad de verificación próximamente'),
                              backgroundColor: AppTheme.primaryColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXL),

                  // Danger Zone
                  _buildSection(
                    'Zona de peligro',
                    Icons.warning_rounded,
                    [
                      _buildDangerTile(
                        'Cerrar sesión',
                        'Cierra tu sesión actual',
                        Icons.logout_rounded,
                        () => _showLogoutDialog(),
                      ),
                      _buildDangerTile(
                        'Eliminar cuenta',
                        'Elimina permanentemente tu cuenta',
                        Icons.delete_forever_rounded,
                        () => _showDeleteAccountDialog(),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacingM),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingL),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(Icons.notifications_rounded, color: AppTheme.textSecondary),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        underline: const SizedBox(),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDangerTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.errorColor),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppTheme.errorColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthProvider>().logout();
              context.go('/');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada exitosamente'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          'Esta acción no se puede deshacer. Se eliminará permanentemente tu cuenta y todos los datos asociados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidad de eliminar cuenta próximamente'),
                  backgroundColor: AppTheme.warningColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}