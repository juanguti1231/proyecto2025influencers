import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../models/user.dart';
import '../services/mock_data_service.dart';

class MessagingProvider with ChangeNotifier {
  List<ChatThread> _threads = [];
  Map<String, List<Message>> _messages = {};
  String? _selectedThreadId;
  bool _isLoading = false;

  List<ChatThread> get threads => _threads;
  Map<String, List<Message>> get messages => _messages;
  String? get selectedThreadId => _selectedThreadId;
  bool get isLoading => _isLoading;

  List<Message> getMessagesForThread(String threadId) {
    return _messages[threadId] ?? [];
  }

  ChatThread? getSelectedThread() {
    if (_selectedThreadId == null) return null;
    return _threads.firstWhere(
      (thread) => thread.id == _selectedThreadId,
      orElse: () => throw Exception('Thread not found'),
    );
  }

  void loadThreads(String userId) {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      _threads = MockDataService.getChatThreadsByUserId(userId);
      
      // Load messages for each thread
      for (final thread in _threads) {
        _messages[thread.id] = MockDataService.getMessagesByThreadId(thread.id);
      }
      
      _isLoading = false;
      notifyListeners();
    });
  }

  void selectThread(String threadId) {
    _selectedThreadId = threadId;
    notifyListeners();
  }

  void sendMessage(String threadId, String text) {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      threadId: threadId,
      senderId: '1', // Mock current user ID
      text: text.trim(),
      attachments: [],
      createdAt: DateTime.now(),
    );

    // Add message to local state
    _messages[threadId] = _messages[threadId] ?? [];
    _messages[threadId]!.add(newMessage);

    // Update thread's last message time
    final threadIndex = _threads.indexWhere((t) => t.id == threadId);
    if (threadIndex != -1) {
      _threads[threadIndex] = ChatThread(
        id: _threads[threadIndex].id,
        campaignId: _threads[threadIndex].campaignId,
        companyId: _threads[threadIndex].companyId,
        influencerId: _threads[threadIndex].influencerId,
        lastMessageAt: DateTime.now(),
        createdAt: _threads[threadIndex].createdAt,
      );
    }

    // Add to mock data service
    MockDataService.addMessage(newMessage);

    notifyListeners();
  }

  void createThread(String campaignId, String companyId, String influencerId) {
    final newThread = ChatThread(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      campaignId: campaignId,
      companyId: companyId,
      influencerId: influencerId,
      lastMessageAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    _threads.add(newThread);
    _messages[newThread.id] = [];
    _selectedThreadId = newThread.id;

    notifyListeners();
  }

  String getOtherUserId(String threadId, String currentUserId) {
    final thread = _threads.firstWhere((t) => t.id == threadId);
    return thread.companyId == currentUserId ? thread.influencerId : thread.companyId;
  }

  User? getOtherUser(String threadId, String currentUserId) {
    final otherUserId = getOtherUserId(threadId, currentUserId);
    return MockDataService.getUserById(otherUserId);
  }

  String getThreadTitle(String threadId, String currentUserId) {
    final otherUser = getOtherUser(threadId, currentUserId);
    return otherUser?.name ?? 'Usuario desconocido';
  }

  String getLastMessagePreview(String threadId) {
    final threadMessages = _messages[threadId] ?? [];
    if (threadMessages.isEmpty) return 'No hay mensajes';
    
    final lastMessage = threadMessages.last;
    return lastMessage.text.length > 50 
        ? '${lastMessage.text.substring(0, 50)}...'
        : lastMessage.text;
  }

  String formatLastMessageTime(String threadId) {
    final thread = _threads.firstWhere((t) => t.id == threadId);
    final now = DateTime.now();
    final difference = now.difference(thread.lastMessageAt);
    
    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}s';
    }
  }
}
