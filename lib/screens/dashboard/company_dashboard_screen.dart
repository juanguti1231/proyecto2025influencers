import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/side_bar.dart';
import '../../widgets/common/top_bar.dart';
import '../../widgets/cards/campaign_card.dart';
import '../../widgets/common/empty_state.dart';
import '../../services/mock_data_service.dart';
import '../../utils/theme.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  String _currentTab = 'resumen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SideBar(
        currentRoute: '/dashboard/company',
        child: Column(
          children: [
            TopBar(
              title: 'Dashboard Empresa',
              actions: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/campaign/create'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nueva Campaña'),
                ),
              ],
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab navigation
          Row(
            children: [
              _buildTabButton('resumen', 'Resumen', Icons.dashboard_rounded),
              const SizedBox(width: AppTheme.spacingM),
              _buildTabButton('campanas', 'Mis Campañas', Icons.campaign_rounded),
              const SizedBox(width: AppTheme.spacingM),
              _buildTabButton('postulaciones', 'Postulaciones', Icons.people_rounded),
              const SizedBox(width: AppTheme.spacingM),
              _buildTabButton('mensajes', 'Mensajes', Icons.message_rounded),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXL),
          
          // Content based on selected tab
          if (_currentTab == 'resumen')
            _buildResumenContent()
          else if (_currentTab == 'campanas')
            _buildCampanasContent()
          else if (_currentTab == 'postulaciones')
            _buildPostulacionesContent()
          else if (_currentTab == 'mensajes')
            _buildMensajesContent(),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tab, String label, IconData icon) {
    final isSelected = _currentTab == tab;
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          _currentTab = tab;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
        foregroundColor: isSelected ? Colors.white : AppTheme.textPrimary,
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Widget _buildResumenContent() {
    final campaigns = MockDataService.getCampaignsByCompanyId('4'); // Mock company ID
    final applications = MockDataService.applications;
    final totalSpent = MockDataService.payments
        .where((p) => p.companyId == '4' && p.status.toString().contains('paid'))
        .fold<double>(0, (sum, p) => sum + p.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KPI Cards
        Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  'Campañas Activas',
                  campaigns.where((c) => c.status.toString().contains('open')).length.toString(),
                  Icons.campaign_rounded,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: _buildKPICard(
                  'Postulaciones',
                  applications.length.toString(),
                  Icons.people_rounded,
                  AppTheme.successColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: _buildKPICard(
                  'Contratados',
                  applications.where((a) => a.status.toString().contains('hired')).length.toString(),
                  Icons.check_circle_rounded,
                  AppTheme.warningColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: _buildKPICard(
                  'Gastos Totales',
                  '€${totalSpent.toInt()}',
                  Icons.euro_rounded,
                  AppTheme.errorColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingXXL),
          
          // Recent Activity
          const Text(
            'Actividad Reciente',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  _buildActivityItem(
                    'Nueva postulación recibida',
                    'Carlos Rodriguez se postuló a "Lanzamiento App de Fitness"',
                    Icons.person_add_rounded,
                    'Hace 2 horas',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Campaña publicada',
                    'Tu campaña "Colección Primavera 2024" está ahora activa',
                    Icons.campaign_rounded,
                    'Hace 1 día',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Pago completado',
                    'Pago de €3,500 procesado para Carlos Rodriguez',
                    Icons.payment_rounded,
                    'Hace 3 días',
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }

  Widget _buildCampanasContent() {
    final campaigns = MockDataService.getCampaignsByCompanyId('4');
    
    if (campaigns.isEmpty) {
      return EmptyState(
        title: 'No tienes campañas',
        description: 'Crea tu primera campaña para comenzar a trabajar con influencers.',
        icon: Icons.campaign_rounded,
        actionText: 'Crear Campaña',
        onAction: () => context.go('/campaign/create'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mis Campañas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.go('/campaign/create'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Nueva Campaña'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: AppTheme.spacingL,
              mainAxisSpacing: AppTheme.spacingL,
            ),
            itemCount: campaigns.length,
            itemBuilder: (context, index) {
              return CampaignCard(campaignId: campaigns[index].id);
            },
          ),
        ],
      );
  }

  Widget _buildPostulacionesContent() {
    final applications = MockDataService.applications;
    
    if (applications.isEmpty) {
      return EmptyState(
        title: 'No hay postulaciones',
        description: 'Las postulaciones de influencers aparecerán aquí cuando publiques campañas.',
        icon: Icons.people_rounded,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            'Postulaciones',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              final influencer = MockDataService.getUserById(application.influencerId);
              final campaign = MockDataService.campaigns.firstWhere((c) => c.id == application.campaignId);
              
              if (influencer == null) return const SizedBox.shrink();
              
              return Card(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: influencer.avatar != null
                            ? NetworkImage(influencer.avatar!)
                            : null,
                        child: influencer.avatar == null
                            ? Text(influencer.name.substring(0, 1).toUpperCase())
                            : null,
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              influencer.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              campaign.title,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              application.message,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '€${application.proposalAmount.toInt()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () => context.go('/profile/influencer/${influencer.id}'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                                ),
                                child: const Text('Ver perfil'),
                              ),
                              const SizedBox(width: AppTheme.spacingS),
                              ElevatedButton(
                                onPressed: () {
                                  // Mock hire action
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Influencer contratado exitosamente'),
                                      backgroundColor: AppTheme.successColor,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                                ),
                                child: const Text('Contratar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
  }

  Widget _buildMensajesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Conversaciones recientes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        
        // Quick access to messaging
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.message_rounded,
                color: AppTheme.primaryColor,
                size: 32,
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mensajería',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Text(
                      'Gestiona todas tus conversaciones con influencers',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/messaging');
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Abrir mensajes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingXL),
        
        // Recent conversations preview
        const Text(
          'Conversaciones recientes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        
        // Mock recent conversations
        ...List.generate(3, (index) {
          final conversations = [
            {
              'name': 'María García',
              'lastMessage': '¡Hola! Me interesa mucho tu campaña de fitness...',
              'time': '2 min',
              'unread': index == 0,
            },
            {
              'name': 'Carlos López',
              'lastMessage': 'Perfecto, enviaré el contenido mañana',
              'time': '1 hora',
              'unread': false,
            },
            {
              'name': 'Ana Martínez',
              'lastMessage': '¿Podrías revisar mi propuesta?',
              'time': '3 horas',
              'unread': false,
            },
          ];
          
          final conv = conversations[index];
          
          return Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: conv['unread'] as bool 
                    ? AppTheme.primaryColor.withOpacity(0.3)
                    : AppTheme.textTertiary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    conv['name'].toString().substring(0, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            conv['name'] as String,
                            style: TextStyle(
                              fontWeight: conv['unread'] as bool 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            conv['time'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        conv['lastMessage'] as String,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontWeight: conv['unread'] as bool 
                              ? FontWeight.w500 
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (conv['unread'] as bool)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        }),
        
        const SizedBox(height: AppTheme.spacingL),
        
        Center(
          child: TextButton.icon(
            onPressed: () {
              context.go('/messaging');
            },
            icon: const Icon(Icons.message_rounded),
            label: const Text('Ver todas las conversaciones'),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String description, IconData icon, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
