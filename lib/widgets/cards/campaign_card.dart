import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/campaign.dart';
import '../../services/mock_data_service.dart';
import '../../utils/theme.dart';

class CampaignCard extends StatelessWidget {
  final String campaignId;
  final VoidCallback? onTap;

  const CampaignCard({
    super.key,
    required this.campaignId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final campaign = MockDataService.campaigns.firstWhere(
      (c) => c.id == campaignId,
      orElse: () => throw Exception('Campaign not found'),
    );
    
    final company = MockDataService.getUserById(campaign.companyId);
    if (company == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingL),
          child: Text('Empresa no encontrada'),
        ),
      );
    }

    return Card(
      child: InkWell(
        onTap: onTap ?? () => context.go('/campaign/$campaignId'),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with company and status
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: company.avatar != null
                        ? NetworkImage(company.avatar!)
                        : null,
                    child: company.avatar == null
                        ? Text(
                            company.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 14,
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
                          company.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          company.location,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(campaign.status),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Campaign title and description
              Text(
                campaign.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppTheme.spacingS),
              Text(
                campaign.description,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Category and deliverables
              Row(
                children: [
                  Chip(
                    label: Text(
                      campaign.category,
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppTheme.primaryColor),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    '${campaign.deliverables.length} entregables',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Budget and deadline
              Row(
                children: [
                  Icon(
                    Icons.euro,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatBudget(campaign.budget),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDeadline(campaign.deadline),
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap ?? () => context.go('/campaign/$campaignId'),
                  child: const Text('Ver campaña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(CampaignStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case CampaignStatus.open:
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
        textColor = AppTheme.successColor;
        text = 'Abierta';
        break;
      case CampaignStatus.review:
        backgroundColor = AppTheme.warningColor.withOpacity(0.1);
        textColor = AppTheme.warningColor;
        text = 'En revisión';
        break;
      case CampaignStatus.hired:
        backgroundColor = AppTheme.primaryColor.withOpacity(0.1);
        textColor = AppTheme.primaryColor;
        text = 'Contratada';
        break;
      case CampaignStatus.closed:
        backgroundColor = AppTheme.textTertiary.withOpacity(0.1);
        textColor = AppTheme.textTertiary;
        text = 'Cerrada';
        break;
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

  String _formatBudget(Budget budget) {
    if (budget.fixed != null) {
      return '€${budget.fixed!.toInt()}';
    } else if (budget.min != null && budget.max != null) {
      return '€${budget.min!.toInt()}-${budget.max!.toInt()}';
    } else if (budget.min != null) {
      return 'Desde €${budget.min!.toInt()}';
    } else {
      return 'Presupuesto a consultar';
    }
  }

  String _formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now).inDays;
    
    if (difference < 0) {
      return 'Vencida';
    } else if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Mañana';
    } else if (difference < 7) {
      return '$difference días';
    } else {
      return '${(difference / 7).floor()} semanas';
    }
  }
}
