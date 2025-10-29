import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/top_bar.dart';
import '../../services/mock_data_service.dart';
import '../../utils/theme.dart';

class InfluencerProfileScreen extends StatelessWidget {
  final String influencerId;

  const InfluencerProfileScreen({
    super.key,
    required this.influencerId,
  });

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.getUserById(influencerId);
    final profile = MockDataService.getInfluencerProfileByUserId(influencerId);
    
    if (user == null || profile == null) {
      return Scaffold(
        body: Column(
          children: [
            TopBar(
              title: 'Perfil no encontrado',
              showBackButton: true,
            ),
            const Expanded(
              child: Center(
                child: Text('Influencer no encontrado'),
              ),
            ),
          ],
        ),
      );
    }

    final avgRating = MockDataService.getAverageRatingByUserId(influencerId);
    final totalFollowers = profile.handles.fold<int>(0, (sum, handle) => sum + handle.followers);

    return Scaffold(
      body: Column(
        children: [
          TopBar(
            title: 'Perfil de Influencer',
            showBackButton: true,
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  // Mock contact action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad de contacto próximamente'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
                icon: const Icon(Icons.message, size: 18),
                label: const Text('Contactar'),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingXL),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user.avatar != null
                                ? NetworkImage(user.avatar!)
                                : null,
                            child: user.avatar == null
                                ? Text(
                                    user.name.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                  )
                                : null,
                          ),
                          const SizedBox(width: AppTheme.spacingXL),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    if (user.verified) ...[
                                      const SizedBox(width: AppTheme.spacingS),
                                      const Icon(
                                        Icons.verified,
                                        color: AppTheme.primaryColor,
                                        size: 24,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: AppTheme.spacingS),
                                Text(
                                  user.location,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingM),
                                Text(
                                  profile.bio,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingM),
                                // Niches
                                Wrap(
                                  spacing: AppTheme.spacingS,
                                  runSpacing: AppTheme.spacingS,
                                  children: profile.niches.map((niche) => Chip(
                                    label: Text(niche),
                                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                    labelStyle: const TextStyle(color: AppTheme.primaryColor),
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Seguidores',
                          _formatFollowers(totalFollowers),
                          Icons.people_rounded,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(
                        child: _buildStatCard(
                          'Rating',
                          avgRating.toStringAsFixed(1),
                          Icons.star_rounded,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(
                        child: _buildStatCard(
                          'Engagement',
                          '${profile.metrics.engagementRate}%',
                          Icons.trending_up_rounded,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Platforms
                  const Text(
                    'Plataformas',
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
                        children: profile.handles.map((handle) => Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                          child: Row(
                            children: [
                              Icon(
                                _getPlatformIcon(handle.platform),
                                size: 24,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: AppTheme.spacingM),
                              Text(
                                handle.username,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatFollowers(handle.followers),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Pricing
                  const Text(
                    'Servicios y Tarifas',
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
                        children: profile.pricing.map((pricing) => Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pricing.type,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                '€${pricing.priceFrom.toInt()}${pricing.priceTo != null ? '-${pricing.priceTo!.toInt()}' : '+'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Portfolio
                  const Text(
                    'Portfolio',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: AppTheme.spacingM,
                      mainAxisSpacing: AppTheme.spacingM,
                    ),
                    itemCount: profile.portfolio.length,
                    itemBuilder: (context, index) {
                      final item = profile.portfolio[index];
                      return Card(
                        child: InkWell(
                          onTap: () {
                            // Mock portfolio item click
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Ver ${item.title}'),
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getPlatformIcon(item.platform),
                                size: 32,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(height: AppTheme.spacingS),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppTheme.primaryColor),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt_rounded;
      case 'tiktok':
        return Icons.music_note_rounded;
      case 'youtube':
        return Icons.play_circle_rounded;
      default:
        return Icons.public_rounded;
    }
  }

  String _formatFollowers(int followers) {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    } else if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}K';
    } else {
      return followers.toString();
    }
  }
}
