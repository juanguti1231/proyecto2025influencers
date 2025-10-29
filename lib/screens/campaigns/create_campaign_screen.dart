import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class CreateCampaignScreen extends StatelessWidget {
  final String? campaignId;

  const CreateCampaignScreen({
    super.key,
    this.campaignId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(campaignId == null ? 'Crear Campaña' : 'Editar Campaña'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: Center(
        child: Text(campaignId == null ? 'Create Campaign Screen' : 'Edit Campaign Screen - ID: $campaignId'),
      ),
    );
  }
}
