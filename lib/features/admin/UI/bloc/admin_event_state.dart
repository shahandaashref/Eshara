import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';



// ══════════════════════════════════════════════════════
// EVENTS
// ══════════════════════════════════════════════════════
abstract class AdminEvent {}

class LoadDashboardEvent extends AdminEvent {}
class LoadWordsEvent extends AdminEvent { final String? categoryId; LoadWordsEvent({this.categoryId}); }
class AddWordEvent extends AdminEvent { final AdminWord word; AddWordEvent({required this.word}); }
class UpdateWordEvent extends AdminEvent { final AdminWord word; UpdateWordEvent({required this.word}); }
class DeleteWordEvent extends AdminEvent { final String wordId; DeleteWordEvent({required this.wordId}); }
class LoadCategoriesEvent extends AdminEvent {}
class AddCategoryEvent extends AdminEvent { final String name; AddCategoryEvent({required this.name}); }
class DeleteCategoryEvent extends AdminEvent { final String categoryId; DeleteCategoryEvent({required this.categoryId}); }
class LoadRequestsEvent extends AdminEvent {}
class AcceptRequestEvent extends AdminEvent { final String requestId; AcceptRequestEvent({required this.requestId}); }
class RejectRequestEvent extends AdminEvent { final String requestId; RejectRequestEvent({required this.requestId}); }

// ══════════════════════════════════════════════════════
// STATES
// ══════════════════════════════════════════════════════
abstract class AdminState {}

class AdminLoadingState extends AdminState {}

class AdminDashboardState extends AdminState {
  final AdminStats stats;
  final List<AdminWord> recentWords;
  AdminDashboardState({required this.stats, required this.recentWords, required List<AdminCategory> categories});
}

class AdminWordsState extends AdminState {
  final List<AdminWord> words;
  final List<AdminCategory> categories;
  final String? selectedCategory;
  AdminWordsState({required this.words, required this.categories, this.selectedCategory});
}

class AdminCategoriesState extends AdminState {
  final List<AdminCategory> categories;
  AdminCategoriesState({required this.categories});
}

class AdminRequestsState extends AdminState {
  final List<WordRequest> requests;
  AdminRequestsState({required this.requests});
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
