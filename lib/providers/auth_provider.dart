import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/mock_data_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Login with role selection (mock)
  Future<bool> loginWithRole(UserRole role) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Find a user with the selected role
      final users = MockDataService.users.where((user) => user.role == role).toList();
      if (users.isNotEmpty) {
        _currentUser = users.first;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register new user (mock)
  Future<bool> register({
    required String name,
    required String email,
    required String location,
    required UserRole role,
    String? avatar,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        location: location,
        role: role,
        avatar: avatar,
        verified: false,
        createdAt: DateTime.now(),
      );

      // Add to mock data (in real app, this would be an API call)
      MockDataService.users.add(newUser);
      
      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? location,
    String? avatar,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Update user in mock data
      final userIndex = MockDataService.users.indexWhere((u) => u.id == _currentUser!.id);
      if (userIndex != -1) {
        MockDataService.users[userIndex] = User(
          id: _currentUser!.id,
          name: name ?? _currentUser!.name,
          email: _currentUser!.email,
          location: location ?? _currentUser!.location,
          role: _currentUser!.role,
          avatar: avatar ?? _currentUser!.avatar,
          verified: _currentUser!.verified,
          createdAt: _currentUser!.createdAt,
        );
        
        _currentUser = MockDataService.users[userIndex];
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
