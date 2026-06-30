import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/admin_usecases.dart';
import 'admin_event_state.dart';

/// [BLoC] — AdminBloc
/// بيدير كل عمليات الأدمن: dashboard, words, categories, requests
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetStatsUseCase getStats;
  final GetWordsUseCase getWords;
  final AddWordUseCase addWord;
  final UpdateWordUseCase updateWord;
  final DeleteWordUseCase deleteWord;
  final GetCategoriesUseCase getCategories;
  final AddCategoryUseCase addCategory;
  final DeleteCategoryUseCase deleteCategory;
  final GetWordRequestsUseCase getRequests;
  final AcceptRequestUseCase acceptRequest;
  final RejectRequestUseCase rejectRequest;

  AdminBloc({
    required this.getStats,
    required this.getWords,
    required this.addWord,
    required this.updateWord,
    required this.deleteWord,
    required this.getCategories,
    required this.addCategory,
    required this.deleteCategory,
    required this.getRequests,
    required this.acceptRequest,
    required this.rejectRequest,
  }) : super(AdminLoadingState()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<LoadWordsEvent>(_onLoadWords);
    on<AddWordEvent>(_onAddWord);
    on<UpdateWordEvent>(_onUpdateWord);
    on<DeleteWordEvent>(_onDeleteWord);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<LoadRequestsEvent>(_onLoadRequests);
    on<AcceptRequestEvent>(_onAcceptRequest);
    on<RejectRequestEvent>(_onRejectRequest);
  }

  Future<void> _onLoadDashboard(LoadDashboardEvent e, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final stats = await getStats();
      final words = await getWords();
      emit(AdminDashboardState(stats: stats, recentWords: words.take(4).toList()));
    } catch (_) { emit(AdminErrorState(message: 'تعذر تحميل البيانات')); }
  }

  Future<void> _onLoadWords(LoadWordsEvent e, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final cats = await getCategories();
      final words = await getWords(categoryId: e.categoryId);
      emit(AdminWordsState(words: words, categories: cats, selectedCategory: e.categoryId));
    } catch (_) { emit(AdminErrorState(message: 'تعذر تحميل الكلمات')); }
  }

  Future<void> _onAddWord(AddWordEvent e, Emitter<AdminState> emit) async {
    final prev = state;
    try {
      await addWord(e.word);
      emit(AdminActionSuccessState(message: 'تمت إضافة الكلمة بنجاح', previousState: prev));
      add(LoadWordsEvent());
    } catch (_) { emit(AdminErrorState(message: 'تعذر إضافة الكلمة')); }
  }

  Future<void> _onUpdateWord(UpdateWordEvent e, Emitter<AdminState> emit) async {
    final prev = state;
    try {
      await updateWord(e.word);
      emit(AdminActionSuccessState(message: 'تم تعديل الكلمة بنجاح', previousState: prev));
      add(LoadWordsEvent());
    } catch (_) { emit(AdminErrorState(message: 'تعذر تعديل الكلمة')); }
  }

  Future<void> _onDeleteWord(DeleteWordEvent e, Emitter<AdminState> emit) async {
    final prev = state;
    try {
      await deleteWord(e.wordId);
      emit(AdminActionSuccessState(message: 'تم حذف الكلمة بنجاح', previousState: prev));
      add(LoadWordsEvent());
    } catch (_) { emit(AdminErrorState(message: 'تعذر حذف الكلمة')); }
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent e, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final cats = await getCategories();
      emit(AdminCategoriesState(categories: cats));
    } catch (_) { emit(AdminErrorState(message: 'تعذر تحميل الفئات')); }
  }

  Future<void> _onAddCategory(AddCategoryEvent e, Emitter<AdminState> emit) async {
    final prev = state;
    try {
      await addCategory(e.name);
      emit(AdminActionSuccessState(message: 'تمت إضافة الفئة بنجاح', previousState: prev));
      add(LoadCategoriesEvent());
    } catch (_) { emit(AdminErrorState(message: 'تعذر إضافة الفئة')); }
  }

  Future<void> _onDeleteCategory(DeleteCategoryEvent e, Emitter<AdminState> emit) async {
    final prev = state;
    try {
      await deleteCategory(e.categoryId);
      emit(AdminActionSuccessState(message: 'تم حذف الفئة بنجاح', previousState: prev));
      add(LoadCategoriesEvent());
    } catch (_) { emit(AdminErrorState(message: 'تعذر حذف الفئة')); }
  }

  Future<void> _onLoadRequests(LoadRequestsEvent e, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final requests = await getRequests();
      emit(AdminRequestsState(requests: requests));
    } catch (_) { emit(AdminErrorState(message: 'تعذر تحميل الطلبات')); }
  }

  Future<void> _onAcceptRequest(AcceptRequestEvent e, Emitter<AdminState> emit) async {
    final prev = state;
    try {
      await acceptRequest(e.requestId);
      emit(AdminActionSuccessState(message: 'تم قبول الطلب بنجاح', previousState: prev));
      add(LoadRequestsEvent());
    } catch (_) { emit(AdminErrorState(message: 'تعذر قبول الطلب')); }
  }

  Future<void> _onRejectRequest(RejectRequestEvent e, Emitter<AdminState> emit) async {
    final prev = state;
    try {
      await rejectRequest(e.requestId);
      emit(AdminActionSuccessState(message: 'تم رفض الطلب', previousState: prev));
      add(LoadRequestsEvent());
    } catch (_) { emit(AdminErrorState(message: 'تعذر رفض الطلب')); }
  }
}
