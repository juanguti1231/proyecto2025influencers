import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class CampaignDetailScreen extends StatelessWidget {
  final String campaignId;

  const CampaignDetailScreen({
    super.key,
    required this.campaignId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Campaña'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: Center(
        child: Text('Campaign Detail Screen - ID: $campaignId'),
      ),
    );
  }
}
