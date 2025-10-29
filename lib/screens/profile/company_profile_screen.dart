import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class CompanyProfileScreen extends StatelessWidget {
  final String companyId;

  const CompanyProfileScreen({
    super.key,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Empresa'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: Center(
        child: Text('Company Profile Screen - ID: $companyId'),
      ),
    );
  }
}
