import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/top_bar.dart';
import '../../widgets/cards/influencer_card.dart';
import '../../services/mock_data_service.dart';
import '../../utils/theme.dart';

class InfluencersScreen extends StatefulWidget {
  const InfluencersScreen({super.key});

  @override
  State<InfluencersScreen> createState() => _InfluencersScreenState();
}

class _InfluencersScreenState extends State<InfluencersScreen> {
  String _selectedCategory = 'Todos';
  String _searchQuery = '';

  final List<String> _categories = [
    'Todos',
    'Comida',
    'Fitness',
    'Música',
    'Tech',
    'Moda',
    'Beauty',
    'Viajes',
    'Gaming',
  ];

  @override
  Widget build(BuildContext context) {
    final influencers = _getFilteredInfluencers();

    return Scaffold(
      body: Column(
        children: [
          TopBar(
            title: 'Explorar Influencers',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search and filters
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Buscar influencers...',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      DropdownButton<String>(
                        value: _selectedCategory,
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Results
                  Text(
                    '${influencers.length} influencers encontrados',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Influencer grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: AppTheme.spacingL,
                      mainAxisSpacing: AppTheme.spacingL,
                    ),
                    itemCount: influencers.length,
                    itemBuilder: (context, index) {
                      return InfluencerCard(
                        influencerId: influencers[index].id,
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

  List<dynamic> _getFilteredInfluencers() {
    var influencers = MockDataService.users.where((user) => user.role.toString().contains('influencer')).toList();
    
    // Filter by category
    if (_selectedCategory != 'Todos') {
      influencers = influencers.where((influencer) {
        final profile = MockDataService.getInfluencerProfileByUserId(influencer.id);
        return profile?.niches.contains(_selectedCategory) ?? false;
      }).toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      influencers = influencers.where((influencer) {
        return influencer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               influencer.location.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    return influencers;
  }
}
