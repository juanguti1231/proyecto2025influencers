import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/side_bar.dart';
import '../../widgets/common/top_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../../services/mock_data_service.dart';
import '../../utils/theme.dart';

class InfluencerDashboardScreen extends StatefulWidget {
  const InfluencerDashboardScreen({super.key});

  @override
  State<InfluencerDashboardScreen> createState() => _InfluencerDashboardScreenState();
}

class _InfluencerDashboardScreenState extends State<InfluencerDashboardScreen> {
  String _currentTab = 'resumen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SideBar(
        currentRoute: '/dashboard/influencer',
        child: Column(
          children: [
            TopBar(
              title: 'Dashboard Influencer',
              actions: [
                ElevatedButton.icon(
                  onPressed: () => context.go('/explore/campaigns'),
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Explorar Campañas'),
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
    switch (_currentTab) {
      case 'resumen':
        return _buildResumenTab();
      case 'postulaciones':
        return _buildPostulacionesTab();
      case 'guardadas':
        return _buildGuardadasTab();
      case 'mensajes':
        return _buildMensajesTab();
      default:
        return _buildResumenTab();
    }
  }

  Widget _buildResumenTab() {
    final applications = MockDataService.getApplicationsByInfluencerId('1'); // Mock influencer ID
    final hiredCount = applications.where((a) => a.status.toString().contains('hired')).length;
    final totalEarnings = MockDataService.payments
        .where((p) => p.influencerId == '1' && p.status.toString().contains('paid'))
        .fold<double>(0, (sum, p) => sum + p.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile completion reminder
          Card(
            color: AppTheme.warningColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.warningColor,
                    size: 24,
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completa tu perfil',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.warningColor,
                          ),
                        ),
                        const Text(
                          'Agrega más información a tu perfil para atraer a más marcas.',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/settings'),
                    child: const Text('Completar'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingXL),
          
          // KPI Cards
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  'Postulaciones',
                  applications.length.toString(),
                  Icons.assignment_rounded,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: _buildKPICard(
                  'Contratos',
                  hiredCount.toString(),
                  Icons.check_circle_rounded,
                  AppTheme.successColor,
                ),
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: _buildKPICard(
                  'Ingresos',
                  '€${totalEarnings.toInt()}',
                  Icons.euro_rounded,
                  AppTheme.warningColor,
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
                    'Postulación enviada',
                    'Te postulaste a "Lanzamiento App de Fitness"',
                    Icons.send_rounded,
                    'Hace 2 horas',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Nueva campaña disponible',
                    'Se publicó "Colección Primavera 2024" en tu nicho',
                    Icons.campaign_rounded,
                    'Hace 1 día',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Pago recibido',
                    'Recibiste €3,500 por la campaña completada',
                    Icons.payment_rounded,
                    'Hace 3 días',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostulacionesTab() {
    final applications = MockDataService.getApplicationsByInfluencerId('1');
    
    if (applications.isEmpty) {
      return EmptyState(
        title: 'No tienes postulaciones',
        description: 'Explora campañas disponibles y postúlate para comenzar a trabajar con marcas.',
        icon: Icons.assignment_rounded,
        actionText: 'Explorar Campañas',
        onAction: () => context.go('/explore/campaigns'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis Postulaciones',
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
              final campaign = MockDataService.campaigns.firstWhere((c) => c.id == application.campaignId);
              final company = MockDataService.getUserById(campaign.companyId);
              
              if (company == null) return const SizedBox.shrink();
              
              return Card(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: company.avatar != null
                                ? NetworkImage(company.avatar!)
                                : null,
                            child: company.avatar == null
                                ? Text(company.name.substring(0, 1).toUpperCase())
                                : null,
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  campaign.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  company.name,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildStatusChip(application.status),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      Text(
                        application.message,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Propuesta: €${application.proposalAmount.toInt()}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            'Enviada: ${_formatDate(application.createdAt)}',
                            style: const TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 12,
                            ),
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
      ),
    );
  }

  Widget _buildGuardadasTab() {
    return EmptyState(
      title: 'No tienes campañas guardadas',
      description: 'Guarda campañas que te interesen para postularte más tarde.',
      icon: Icons.bookmark_rounded,
      actionText: 'Explorar Campañas',
      onAction: () => context.go('/explore/campaigns'),
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

  Widget _buildStatusChip(dynamic status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status.toString()) {
      case 'ApplicationStatus.submitted':
        backgroundColor = AppTheme.warningColor.withOpacity(0.1);
        textColor = AppTheme.warningColor;
        text = 'Enviada';
        break;
      case 'ApplicationStatus.review':
        backgroundColor = AppTheme.primaryColor.withOpacity(0.1);
        textColor = AppTheme.primaryColor;
        text = 'En revisión';
        break;
      case 'ApplicationStatus.hired':
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
        textColor = AppTheme.successColor;
        text = 'Contratado';
        break;
      case 'ApplicationStatus.rejected':
        backgroundColor = AppTheme.errorColor.withOpacity(0.1);
        textColor = AppTheme.errorColor;
        text = 'Rechazado';
        break;
      default:
        backgroundColor = AppTheme.textTertiary.withOpacity(0.1);
        textColor = AppTheme.textTertiary;
        text = 'Desconocido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMensajesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
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
                        'Gestiona todas tus conversaciones con empresas',
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
                'name': 'TechStartup Inc.',
                'lastMessage': '¡Hola! Nos interesa mucho tu perfil para nuestra campaña...',
                'time': '5 min',
                'unread': index == 0,
              },
              {
                'name': 'Fashion Brand Co.',
                'lastMessage': 'Perfecto, enviaremos el brief mañana',
                'time': '2 horas',
                'unread': false,
              },
              {
                'name': 'Fitness App',
                'lastMessage': '¿Podrías enviar algunos ejemplos de tu trabajo?',
                'time': '1 día',
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
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Ayer';
    } else if (difference < 7) {
      return 'Hace $difference días';
    } else {
      return '${(difference / 7).floor()} semanas';
    }
  }
}
