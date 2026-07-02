/// [Entity] — AdminWord
/// بيمثل كلمة في قاموس الأدمن
class AdminWord {
  final String id;
  final String word;
  final String gloss;
  final String? categoryId;
  final String? categoryName;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? description;
  final DateTime createdAt;

  AdminWord({
    required this.id,
    required this.word,
    required this.gloss,
    this.categoryId,
    this.categoryName,
    this.videoUrl,
    this.thumbnailUrl,
    this.description,
    required this.createdAt,
  });

  AdminWord copyWith({
    String? word,
    String? gloss,
    String? categoryId,
    String? categoryName,
    String? videoUrl,
    String? thumbnailUrl,
    String? description,
    String? id,
  }) => AdminWord(
    id: id ?? this.id,
    word: word ?? this.word,
    gloss: gloss ?? this.gloss,
    categoryId: categoryId ?? this.categoryId,
    videoUrl: videoUrl ?? this.videoUrl,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    description: description ?? this.description,
    createdAt: createdAt,
  );

  factory AdminWord.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt =
        json['createdAt'] ?? json['CreatedAt'] ?? json['created_at'];
    DateTime createdAt;
    if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else if (rawCreatedAt is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    } else {
      createdAt = DateTime.now();
    }

    return AdminWord(
      id: json['id']?.toString() ?? '',
      word: json['arabicMeaning']?.toString() ?? '',
      gloss: json['gloss']?.toString() ?? '',
      categoryId:
          json['categoryId']?.toString() ?? json['category']?['id']?.toString(),
      categoryName: json['category']?['name']?.toString(),
      videoUrl: json['videoUrl']?.toString() ?? json['VideoUrl']?.toString(),
      thumbnailUrl:
          json['thumbnailUrl']?.toString() ?? json['ThumbnailUrl']?.toString(),
      description:
          json['description']?.toString() ?? json['Description']?.toString(),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'arabicMeaning': word,
    'gloss': gloss,
    if (categoryId != null) 'categoryId': categoryId,
    if (videoUrl != null) 'videoUrl': videoUrl,
    if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
    if (description != null) 'description': description,
  };
}

/// [Entity] — AdminCategory
/// بيمثل فئة في القاموس
class AdminCategory {
  final String id;
  final String name;
  final String? description;
  final int? wordCount;

  AdminCategory({
    required this.id,
    required this.name,
    this.description,
    this.wordCount,
  });

  factory AdminCategory.fromJson(Map<String, dynamic> json) {
    return AdminCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      wordCount: json['wordCount'] is int
          ? json['wordCount'] as int
          : int.tryParse(json['wordCount']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'wordCount': wordCount,
  };
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

  factory WordRequest.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt =
        json['createdAt'] ?? json['CreatedAt'] ?? json['created_at'];
    DateTime createdAt;
    if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else if (rawCreatedAt is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    } else {
      createdAt = DateTime.now();
    }

    return WordRequest(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      word: json['word']?.toString() ?? json['Word']?.toString() ?? '',
      userName:
          json['userName']?.toString() ?? json['UserName']?.toString() ?? '',
      userEmail:
          json['userEmail']?.toString() ?? json['UserEmail']?.toString() ?? '',
      videoUrl: json['videoUrl']?.toString() ?? json['VideoUrl']?.toString(),
      description:
          json['description']?.toString() ?? json['Description']?.toString(),
      status: WordRequestStatusX.fromString(json['status']?.toString()),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'userName': userName,
    'userEmail': userEmail,
    if (videoUrl != null) 'videoUrl': videoUrl,
    if (description != null) 'description': description,
    'status': status.toApiString(),
  };
}

/// [Enum] — WordRequestStatus
enum WordRequestStatus { pending, accepted, rejected }

extension WordRequestStatusX on WordRequestStatus {
  String toApiString() => name;

  static WordRequestStatus fromString(String? value) {
    if (value == null) return WordRequestStatus.pending;
    final normalized = value.toLowerCase();
    if (normalized.contains('accept')) return WordRequestStatus.accepted;
    if (normalized.contains('reject')) return WordRequestStatus.rejected;
    return WordRequestStatus.pending;
  }
}

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

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: json['totalUsers'] is int
          ? json['totalUsers'] as int
          : int.tryParse(json['totalUsers']?.toString() ?? '') ?? 0,
      totalWords: json['totalWords'] is int
          ? json['totalWords'] as int
          : int.tryParse(json['totalWords']?.toString() ?? '') ?? 0,
      pendingRequests: json['pendingRequests'] is int
          ? json['pendingRequests'] as int
          : int.tryParse(json['pendingRequests']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalUsers': totalUsers,
    'totalWords': totalWords,
    'pendingRequests': pendingRequests,
  };
}
