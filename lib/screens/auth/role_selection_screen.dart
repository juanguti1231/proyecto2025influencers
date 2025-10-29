import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/user.dart';
import '../../utils/theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(AppTheme.spacingXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  ),
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXL),
                
                const Text(
                  '¿Cómo quieres usar InfluenceHub?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                const Text(
                  'Selecciona tu rol para continuar',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingXXL),

                // Role selection cards
                Column(
                  children: [
                    _buildRoleCard(
                      context,
                      UserRole.company,
                      Icons.business_rounded,
                      'Empresa',
                      'Publica campañas y encuentra influencers para tu marca',
                      'Crear campañas',
                      'Contratar influencers',
                      'Gestionar presupuestos',
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildRoleCard(
                      context,
                      UserRole.influencer,
                      Icons.person_rounded,
                      'Influencer',
                      'Encuentra campañas y colabora con marcas auténticas',
                      'Explorar campañas',
                      'Mostrar tu trabajo',
                      'Generar ingresos',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingXXL),
                
                // Already have account
                TextButton(
                  onPressed: () {
                    // For demo purposes, we'll just show a simple login
                    _showLoginDialog(context);
                  },
                  child: const Text('Ya tengo una cuenta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    UserRole role,
    IconData icon,
    String title,
    String description,
    String feature1,
    String feature2,
    String feature3,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => context.go('/register?role=${role.toString().split('.').last}'),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingXL),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingXL),
              
              // Features
              Column(
                children: [
                  _buildFeatureItem(Icons.check_circle, feature1),
                  const SizedBox(height: AppTheme.spacingS),
                  _buildFeatureItem(Icons.check_circle, feature2),
                  const SizedBox(height: AppTheme.spacingS),
                  _buildFeatureItem(Icons.check_circle, feature3),
                ],
              ),
              const SizedBox(height: AppTheme.spacingXL),
              
              // CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/register?role=${role.toString().split('.').last}'),
                  child: Text('Continuar como $title'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.successColor,
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Iniciar sesión'),
        content: const Text('Para esta demo, selecciona un rol para continuar. En una aplicación real, aquí habría un formulario de login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}