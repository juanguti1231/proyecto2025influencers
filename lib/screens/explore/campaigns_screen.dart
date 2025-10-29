import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Campañas'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: const Center(
        child: Text('Campaigns Screen - Coming Soon'),
      ),
    );
  }
}
