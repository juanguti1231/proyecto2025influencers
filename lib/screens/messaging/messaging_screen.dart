import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/top_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/messaging_provider.dart';
import '../../utils/theme.dart';

class MessagingScreen extends StatefulWidget {
  final String? threadId;

  const MessagingScreen({
    super.key,
    this.threadId,
  });

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final messagingProvider = context.read<MessagingProvider>();
      
      if (authProvider.currentUser != null) {
        messagingProvider.loadThreads(authProvider.currentUser!.id);
        
        if (widget.threadId != null) {
          messagingProvider.selectThread(widget.threadId!);
        }
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBar(
            title: 'Mensajes',
            showBackButton: true,
          ),
          Expanded(
            child: Consumer2<AuthProvider, MessagingProvider>(
              builder: (context, authProvider, messagingProvider, child) {
                if (authProvider.currentUser == null) {
                  return const Center(
                    child: Text('Debes iniciar sesión para ver los mensajes'),
                  );
                }

                if (messagingProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (messagingProvider.threads.isEmpty) {
                  return _buildEmptyState();
                }

                return Row(
                  children: [
                    // Thread list
                    Container(
                      width: 350,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppTheme.textTertiary, width: 0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacingL),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppTheme.textTertiary, width: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Conversaciones',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    // Mock new conversation
                                    _showNewConversationDialog(context, messagingProvider);
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                          // Thread list
                          Expanded(
                            child: ListView.builder(
                              itemCount: messagingProvider.threads.length,
                              itemBuilder: (context, index) {
                                final thread = messagingProvider.threads[index];
                                final isSelected = messagingProvider.selectedThreadId == thread.id;
                                final otherUser = messagingProvider.getOtherUser(thread.id, authProvider.currentUser!.id);
                                
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
                                    border: isSelected 
                                        ? const Border(left: BorderSide(color: AppTheme.primaryColor, width: 3))
                                        : null,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: otherUser?.avatar != null
                                          ? NetworkImage(otherUser!.avatar!)
                                          : null,
                                      child: otherUser?.avatar == null
                                          ? Text(otherUser?.name.substring(0, 1).toUpperCase() ?? 'U')
                                          : null,
                                    ),
                                    title: Text(
                                      otherUser?.name ?? 'Usuario desconocido',
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                    subtitle: Text(
                                      messagingProvider.getLastMessagePreview(thread.id),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                      messagingProvider.formatLastMessageTime(thread.id),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textTertiary,
                                      ),
                                    ),
                                    onTap: () {
                                      messagingProvider.selectThread(thread.id);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chat area
                    Expanded(
                      child: messagingProvider.selectedThreadId != null
                          ? _buildChatArea(messagingProvider, authProvider)
                          : _buildNoThreadSelected(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_rounded,
            size: 80,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          const Text(
            'No tienes conversaciones',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          const Text(
            'Las conversaciones aparecerán aquí cuando comiences a colaborar con otros usuarios.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          ElevatedButton.icon(
            onPressed: () => context.go('/explore/influencers'),
            icon: const Icon(Icons.search),
            label: const Text('Explorar Influencers'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoThreadSelected() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppTheme.textTertiary,
          ),
          SizedBox(height: AppTheme.spacingXL),
          Text(
            'Selecciona una conversación',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppTheme.spacingM),
          Text(
            'Elige una conversación de la lista para comenzar a chatear.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(MessagingProvider messagingProvider, AuthProvider authProvider) {
    final selectedThread = messagingProvider.getSelectedThread();
    final otherUser = selectedThread != null 
        ? messagingProvider.getOtherUser(selectedThread.id, authProvider.currentUser!.id)
        : null;
    final messages = messagingProvider.getMessagesForThread(messagingProvider.selectedThreadId!);

    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppTheme.textTertiary, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: otherUser?.avatar != null
                    ? NetworkImage(otherUser!.avatar!)
                    : null,
                child: otherUser?.avatar == null
                    ? Text(otherUser?.name.substring(0, 1).toUpperCase() ?? 'U')
                    : null,
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherUser?.name ?? 'Usuario desconocido',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      otherUser?.location ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Mock call action
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad de llamada próximamente'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
                icon: const Icon(Icons.call),
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppTheme.spacingL),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isMe = message.senderId == authProvider.currentUser!.id;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                child: Row(
                  mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isMe) ...[
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: otherUser?.avatar != null
                            ? NetworkImage(otherUser!.avatar!)
                            : null,
                        child: otherUser?.avatar == null
                            ? Text(otherUser?.name.substring(0, 1).toUpperCase() ?? 'U')
                            : null,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                    ],
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? AppTheme.primaryColor : AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.text,
                              style: TextStyle(
                                color: isMe ? Colors.white : AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatMessageTime(message.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: isMe 
                                    ? Colors.white.withOpacity(0.7)
                                    : AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: AppTheme.spacingS),
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: authProvider.currentUser?.avatar != null
                            ? NetworkImage(authProvider.currentUser!.avatar!)
                            : null,
                        child: authProvider.currentUser?.avatar == null
                            ? Text(authProvider.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U')
                            : null,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        // Message input
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppTheme.textTertiary, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                  ),
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(messagingProvider),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              IconButton(
                onPressed: () => _sendMessage(messagingProvider),
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage(MessagingProvider messagingProvider) {
    final text = _messageController.text.trim();
    if (text.isEmpty || messagingProvider.selectedThreadId == null) return;

    messagingProvider.sendMessage(messagingProvider.selectedThreadId!, text);
    _messageController.clear();
    
    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  void _showNewConversationDialog(BuildContext context, MessagingProvider messagingProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva conversación'),
        content: const Text('Esta funcionalidad estará disponible próximamente. Por ahora, las conversaciones se crean automáticamente cuando te postulas a campañas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}