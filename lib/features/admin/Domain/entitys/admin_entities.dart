/// [Entity] — AdminWord
/// بيمثل كلمة في قاموس الأدمن
class AdminWord {
  final String id;
  final String word;
  final String category;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? description;
  final DateTime createdAt;

  AdminWord({
    required this.id,
    required this.word,
    required this.category,
    this.videoUrl,
    this.thumbnailUrl,
    this.description,
    required this.createdAt,
  });

  AdminWord copyWith({
    String? word,
    String? category,
    String? videoUrl,
    String? thumbnailUrl,
    String? description,
  }) =>
      AdminWord(
        id: id,
        word: word ?? this.word,
        category: category ?? this.category,
        videoUrl: videoUrl ?? this.videoUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        description: description ?? this.description,
        createdAt: createdAt,
      );
}

/// [Entity] — AdminCategory
/// بيمثل فئة في القاموس
class AdminCategory {
  final String id;
  final String name;
  final int wordCount;

  AdminCategory({
    required this.id,
    required this.name,
    required this.wordCount,
  });
}

/// [Entity] — WordRequest
/// بيمثل طلب إضافة كلمة من مستخدم
class WordRequest {
  final String id;
  final String word;
  final String userName;
  final String userEmail;
  final String? videoUrl;
  final String? description;
  final WordRequestStatus status;
  final DateTime createdAt;

  WordRequest({
    required this.id,
    required this.word,
    required this.userName,
    required this.userEmail,
    this.videoUrl,
    this.description,
    required this.status,
    required this.createdAt,
  });
}

/// [Enum] — WordRequestStatus
enum WordRequestStatus { pending, accepted, rejected }

/// [Entity] — AdminStats
/// إحصائيات لوحة التحكم
class AdminStats {
  final int totalUsers;
  final int totalWords;
  final int pendingRequests;

  AdminStats({
    required this.totalUsers,
    required this.totalWords,
    required this.pendingRequests,
  });
}
