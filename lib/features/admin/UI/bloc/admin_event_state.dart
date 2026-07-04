import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';

// ══════════════════════════════════════════════════════
// EVENTS
// ══════════════════════════════════════════════════════
abstract class AdminEvent {}

class LoadDashboardEvent extends AdminEvent {}

class LoadWordsEvent extends AdminEvent {
  final String? categoryId;
  LoadWordsEvent({this.categoryId});
}

class AddWordEvent extends AdminEvent {
  final AdminWord word;
  AddWordEvent({required this.word});
}

class UpdateWordEvent extends AdminEvent {
  final AdminWord word;
  UpdateWordEvent({required this.word});
}

class DeleteWordEvent extends AdminEvent {
  final String wordId;
  DeleteWordEvent({required this.wordId});
}

class LoadCategoriesEvent extends AdminEvent {}

class AddCategoryEvent extends AdminEvent {
  final String name;
  final String? description;
  AddCategoryEvent({required this.name, this.description});
}

class DeleteCategoryEvent extends AdminEvent {
  final String categoryId;
  DeleteCategoryEvent({required this.categoryId});
}

class UpdateCategoryEvent extends AdminEvent {
  final AdminCategory category;
  UpdateCategoryEvent({required this.category});
}

class LoadRequestsEvent extends AdminEvent {}

class AcceptRequestEvent extends AdminEvent {
  final String requestId;
  AcceptRequestEvent({required this.requestId});
}

class RejectRequestEvent extends AdminEvent {
  final String requestId;
  RejectRequestEvent({required this.requestId});
}

// ══════════════════════════════════════════════════════
// STATES
// ══════════════════════════════════════════════════════
abstract class AdminState {}

class AdminLoadingState extends AdminState {}

class AdminDashboardState extends AdminState {
  final AdminStats stats;
  final List<AdminWord> recentWords;
  final List<AdminCategory> categories;

  AdminDashboardState({
    required this.stats,
    required this.recentWords,
    required this.categories,
  });

  AdminDashboardState copyWith({
    AdminStats? stats,
    List<AdminWord>? recentWords,
    List<AdminCategory>? categories,
  }) {
    return AdminDashboardState(
      stats: stats ?? this.stats,
      recentWords: recentWords ?? this.recentWords,
      categories: categories ?? this.categories,
    );
  }
}

class AdminWordsState extends AdminState {
  final List<AdminWord> words;
  final List<AdminCategory> categories;
  final String? selectedCategory;
  final bool isLoading; // للتحكم في مؤشر التحميل الجزئي
  AdminWordsState({
    required this.words,
    required this.categories,
    this.selectedCategory,
    this.isLoading = false,
  });

  AdminWordsState copyWith({
    List<AdminWord>? words,
    List<AdminCategory>? categories,
    String? selectedCategory,
    bool? isLoading,
  }) {
    return AdminWordsState(
      words: words ?? this.words,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AdminCategoriesState extends AdminState {
  final List<AdminCategory> categories;
  AdminCategoriesState({required this.categories});

  AdminCategoriesState copyWith({List<AdminCategory>? categories}) {
    return AdminCategoriesState(categories: categories ?? this.categories);
  }
}

class AdminRequestsState extends AdminState {
  final List<WordRequest> requests;
  AdminRequestsState({required this.requests});

  AdminRequestsState copyWith({List<WordRequest>? requests}) {
    return AdminRequestsState(requests: requests ?? this.requests);
  }
}

class AdminActionSuccessState extends AdminState {
  final String message;
  final AdminState previousState;
  AdminActionSuccessState({required this.message, required this.previousState});
}

class AdminErrorState extends AdminState {
  final String message;
  AdminErrorState({required this.message});
}
