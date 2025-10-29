import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/mock_data_service.dart';
import '../../utils/theme.dart';

class InfluencerCard extends StatelessWidget {
  final String influencerId;
  final VoidCallback? onTap;

  const InfluencerCard({
    super.key,
    required this.influencerId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.getUserById(influencerId);
    final profile = MockDataService.getInfluencerProfileByUserId(influencerId);
    
    if (user == null || profile == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingL),
          child: Text('Influencer no encontrado'),
        ),
      );
    }

    final avgRating = MockDataService.getAverageRatingByUserId(influencerId);
    final totalFollowers = profile.handles.fold<int>(0, (sum, handle) => sum + handle.followers);
    final minPrice = profile.pricing.isNotEmpty 
        ? profile.pricing.map((p) => p.priceFrom).reduce((a, b) => a < b ? a : b)
        : 0.0;

    return Card(
      child: InkWell(
        onTap: onTap ?? () => context.go('/profile/influencer/$influencerId'),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and basic info
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user.avatar != null
                        ? NetworkImage(user.avatar!)
                        : null,
                    child: user.avatar == null
                        ? Text(
                            user.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
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
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                            if (user.verified) ...[
                              const SizedBox(width: AppTheme.spacingS),
                              const Icon(
                                Icons.verified,
                                color: AppTheme.primaryColor,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.location,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14,
                              color: AppTheme.warningColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              avgRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Niches
              Wrap(
                spacing: AppTheme.spacingS,
                runSpacing: AppTheme.spacingS,
                children: profile.niches.take(3).map((niche) => Chip(
                  label: Text(
                    niche,
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  labelStyle: const TextStyle(color: AppTheme.primaryColor),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Platform handles
              Column(
                children: profile.handles.take(2).map((handle) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        _getPlatformIcon(handle.platform),
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        handle.username,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatFollowers(handle.followers),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Price and CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desde €${minPrice.toInt()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_formatFollowers(totalFollowers)} seguidores',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onTap ?? () => context.go('/profile/influencer/$influencerId'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM, vertical: AppTheme.spacingS),
                    ),
                    child: const Text(
                      'Ver perfil',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
