class ChatThread {
  final String id;
  final String campaignId;
  final String companyId;
  final String influencerId;
  final DateTime lastMessageAt;
  final DateTime createdAt;

  ChatThread({
    required this.id,
    required this.campaignId,
    required this.companyId,
    required this.influencerId,
    required this.lastMessageAt,
    required this.createdAt,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      id: json['id'],
      campaignId: json['campaignId'],
      companyId: json['companyId'],
      influencerId: json['influencerId'],
      lastMessageAt: DateTime.parse(json['lastMessageAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'companyId': companyId,
      'influencerId': influencerId,
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Message {
  final String id;
  final String threadId;
  final String senderId;
  final String text;
  final List<String> attachments;
  final DateTime createdAt;
  final bool isRead;

  Message({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.text,
    required this.attachments,
    required this.createdAt,
    this.isRead = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      threadId: json['threadId'],
      senderId: json['senderId'],
      text: json['text'],
      attachments: List<String>.from(json['attachments']),
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'threadId': threadId,
      'senderId': senderId,
      'text': text,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}
