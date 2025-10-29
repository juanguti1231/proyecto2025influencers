import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: const Center(
        child: Text('Admin Dashboard - Coming Soon'),
      ),
    );
  }
}
