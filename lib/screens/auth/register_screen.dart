import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';

class RegisterScreen extends StatefulWidget {
  final String role;

  const RegisterScreen({
    super.key,
    required this.role,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _industryController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _companyNameController.dispose();
    _websiteController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRole = UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == widget.role,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(AppTheme.spacingXL),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      userRole == UserRole.company ? Icons.business_rounded : Icons.person_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  Text(
                    'Crear cuenta como ${userRole == UserRole.company ? 'Empresa' : 'Influencer'}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  Text(
                    'Completa tu perfil para comenzar',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),

                  // Form fields
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: userRole == UserRole.company ? 'Nombre de la empresa' : 'Nombre completo',
                      hintText: userRole == UserRole.company ? 'Ej: TechStart Inc.' : 'Ej: Sofia Martinez',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'tu@email.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      if (!value.contains('@')) {
                        return 'Ingresa un email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Ubicación',
                      hintText: 'Ej: Madrid, España',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es obligatorio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingL),

                  // Company-specific fields
                  if (userRole == UserRole.company) ...[
                    TextFormField(
                      controller: _websiteController,
                      decoration: const InputDecoration(
                        labelText: 'Sitio web',
                        hintText: 'https://tuempresa.com',
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: AppTheme.spacingL),

                    DropdownButtonFormField<String>(
                      value: _industryController.text.isEmpty ? null : _industryController.text,
                      decoration: const InputDecoration(
                        labelText: 'Industria',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Tecnología', child: Text('Tecnología')),
                        DropdownMenuItem(value: 'Moda', child: Text('Moda')),
                        DropdownMenuItem(value: 'Comida', child: Text('Comida')),
                        DropdownMenuItem(value: 'Fitness', child: Text('Fitness')),
                        DropdownMenuItem(value: 'Beauty', child: Text('Beauty')),
                        DropdownMenuItem(value: 'Viajes', child: Text('Viajes')),
                        DropdownMenuItem(value: 'Gaming', child: Text('Gaming')),
                        DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                      ],
                      onChanged: (value) {
                        _industryController.text = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona una industria';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                  ],

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingL),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Crear cuenta',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Back to role selection
                  TextButton(
                    onPressed: () => context.go('/role-selection'),
                    child: const Text('Volver a selección de rol'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userRole = UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == widget.role,
      );

      final authProvider = context.read<AuthProvider>();
      
      bool success;
      if (userRole == UserRole.company) {
        success = await authProvider.register(
          name: _nameController.text,
          email: _emailController.text,
          location: _locationController.text,
          role: userRole,
        );
      } else {
        success = await authProvider.register(
          name: _nameController.text,
          email: _emailController.text,
          location: _locationController.text,
          role: userRole,
        );
      }

      if (success && mounted) {
        // Navigate to appropriate dashboard
        switch (userRole) {
          case UserRole.company:
            context.go('/dashboard/company');
            break;
          case UserRole.influencer:
            context.go('/dashboard/influencer');
            break;
          case UserRole.admin:
            context.go('/dashboard/admin');
            break;
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al crear la cuenta. Inténtalo de nuevo.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error inesperado. Inténtalo de nuevo.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}