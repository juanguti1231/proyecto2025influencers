import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/theme.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL, vertical: AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Row(
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      const Text(
                        'InfluenceHub',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Navigation
                  Row(
                    children: [
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
                        onPressed: () => _scrollToHowItWorks(),
                        child: const Text('Cómo funciona'),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppTheme.spacingL),
                  // CTA Buttons
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
              ),
            ),
            
            // Hero Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL, vertical: AppTheme.spacingXXL),
              child: Column(
                children: [
                  const Text(
                    'Conecta marcas con influencers auténticos',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  const Text(
                    'La plataforma que facilita la colaboración entre empresas e influencers para crear campañas exitosas y auténticas.',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/explore/influencers'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL, vertical: AppTheme.spacingL),
                        ),
                        child: const Text(
                          'Encontrar influencers',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      OutlinedButton(
                        onPressed: () => context.go('/explore/campaigns'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL, vertical: AppTheme.spacingL),
                        ),
                        child: const Text(
                          'Encontrar campañas',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // How it works section
            Container(
              key: const ValueKey('how-it-works'),
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL, vertical: AppTheme.spacingXXL),
              color: AppTheme.surfaceColor,
              child: Column(
                children: [
                  const Text(
                    'Cómo funciona',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),
                  Row(
                    children: [
                      // For Companies
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Para Empresas',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingL),
                            _buildStepCard(
                              '1',
                              'Crea tu campaña',
                              'Define objetivos, presupuesto y requisitos para tu campaña de marketing.',
                            ),
                            const SizedBox(height: AppTheme.spacingL),
                            _buildStepCard(
                              '2',
                              'Recibe postulaciones',
                              'Los influencers interesados se postulan con sus propuestas y tarifas.',
                            ),
                            const SizedBox(height: AppTheme.spacingL),
                            _buildStepCard(
                              '3',
                              'Contrata y ejecuta',
                              'Selecciona los mejores candidatos y ejecuta tu campaña con seguimiento completo.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingXL),
                      // For Influencers
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Para Influencers',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingL),
                            _buildStepCard(
                              '1',
                              'Completa tu perfil',
                              'Muestra tu trabajo, nichos y métricas para atraer a las mejores marcas.',
                            ),
                            const SizedBox(height: AppTheme.spacingL),
                            _buildStepCard(
                              '2',
                              'Explora campañas',
                              'Encuentra campañas que se alineen con tu audiencia y valores.',
                            ),
                            const SizedBox(height: AppTheme.spacingL),
                            _buildStepCard(
                              '3',
                              'Postúlate y colabora',
                              'Envía propuestas, negocia términos y ejecuta contenido de calidad.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Value proposition
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL, vertical: AppTheme.spacingXXL),
              child: Column(
                children: [
                  const Text(
                    '¿Por qué elegir InfluenceHub?',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),
                  Row(
                    children: [
                      Expanded(
                        child: _buildValueCard(
                          Icons.security_rounded,
                          'Seguridad garantizada',
                          'Pagos seguros y contratos claros para ambas partes.',
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(
                        child: _buildValueCard(
                          Icons.analytics_rounded,
                          'Métricas reales',
                          'Acceso a datos auténticos de engagement y alcance.',
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(
                        child: _buildValueCard(
                          Icons.star_rounded,
                          'Reputación verificada',
                          'Sistema de reseñas y verificación de perfiles.',
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(
                        child: _buildValueCard(
                          Icons.payment_rounded,
                          'Pagos integrados',
                          'Procesamiento de pagos automático y transparente.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Categories
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL, vertical: AppTheme.spacingXXL),
              color: AppTheme.surfaceColor,
              child: Column(
                children: [
                  const Text(
                    'Categorías populares',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),
                  Wrap(
                    spacing: AppTheme.spacingM,
                    runSpacing: AppTheme.spacingM,
                    children: [
                      _buildCategoryChip('Comida'),
                      _buildCategoryChip('Fitness'),
                      _buildCategoryChip('Música'),
                      _buildCategoryChip('Tech'),
                      _buildCategoryChip('Moda'),
                      _buildCategoryChip('Beauty'),
                      _buildCategoryChip('Viajes'),
                      _buildCategoryChip('Gaming'),
                    ],
                  ),
                ],
              ),
            ),

            // Featured influencers
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL, vertical: AppTheme.spacingXXL),
              child: Column(
                children: [
                  const Text(
                    'Influencers destacados',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),
                  Row(
                    children: [
                      Expanded(child: _buildInfluencerCard()),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(child: _buildInfluencerCard()),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(child: _buildInfluencerCard()),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXL),
                  ElevatedButton(
                    onPressed: () => context.go('/explore/influencers'),
                    child: const Text('Ver todos los influencers'),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL, vertical: AppTheme.spacingXL),
              color: AppTheme.textPrimary,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© 2024 InfluenceHub. Todos los derechos reservados.',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      Text('Términos de servicio', style: TextStyle(color: Colors.white)),
                      SizedBox(width: AppTheme.spacingL),
                      Text('Política de privacidad', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToHowItWorks() {
    // Find the how it works section and scroll to it
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      // Calculate the position of the "How it works" section
      final double targetPosition = 600; // Approximate position
      _scrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildStepCard(String number, String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(IconData icon, String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Chip(
      label: Text(category),
      backgroundColor: AppTheme.surfaceColor,
      side: const BorderSide(color: AppTheme.primaryColor),
      labelStyle: const TextStyle(color: AppTheme.primaryColor),
    );
  }

  Widget _buildInfluencerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face'),
            ),
            const SizedBox(height: AppTheme.spacingM),
            const Text(
              '@sofia_cocina',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            const Text(
              'Comida • 45K seguidores',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(5, (index) => Icon(
                  Icons.star,
                  size: 16,
                  color: index < 4 ? AppTheme.warningColor : AppTheme.textTertiary,
                )),
                const SizedBox(width: AppTheme.spacingS),
                const Text(
                  '4.8',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            const Text(
              'Desde €500',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}