import 'package:eshara/features/admin/domain/entities/admin_entities.dart';
import 'package:eshara/features/admin/domain/usecases/admin_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_event_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetWordsUseCaseAdmin getWords;
  final AddWordUseCase addWord;
  final UpdateWordUseCase updateWord;
  final DeleteWordUseCase deleteWord;
  final GetCategoriesUseCaseAdmin getCategories;
  final AddCategoryUseCase addCategory;
  final DeleteCategoryUseCase deleteCategory;
  final GetWordRequestsUseCase getRequests;
  final AcceptRequestUseCase acceptRequest;
  final RejectRequestUseCase rejectRequest;
  final GetUsersUseCase getUsers;

  AdminBloc({
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
    required this.getUsers,
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

  Future<void> _onLoadDashboard(
    LoadDashboardEvent e,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoadingState());

    final List<AdminWord> words = [];
    final List<AdminCategory> categories = [];
    final List<WordRequest> requests = [];
    dynamic users = [];
    final List<String> errors = [];

    try {
      words.addAll(await getWords());
    } catch (e) {
      errors.add('فشل تحميل الكلمات: $e');
    }

    try {
      categories.addAll(await getCategories());
    } catch (e) {
      errors.add('فشل تحميل الفئات: $e');
    }

    try {
      requests.addAll(await getRequests());
    } catch (e) {
      errors.add('فشل تحميل طلبات الكلمات: $e');
    }

    try {
      users = await getUsers();
    } catch (e) {
      errors.add('فشل تحميل المستخدمين: $e');
    }

    if (errors.length == 4) {
      emit(
        AdminErrorState(
          message: errors.isNotEmpty
              ? errors.join(' | ')
              : 'تعذر تحميل البيانات',
        ),
      );
      return;
    }

    final stats = AdminStats(
      totalWords: words.length,
      pendingRequests: requests
          .where((r) => r.status == WordRequestStatus.pending)
          .length,
      totalUsers: (users is List) ? users.length : 0,
    );

    emit(
      AdminDashboardState(
        stats: stats,
        recentWords: words.take(4).toList(),
        categories: categories,
      ),
    );
  }

  Future<void> _onLoadWords(LoadWordsEvent e, Emitter<AdminState> emit) async {
    emit(AdminLoadingState());
    try {
      final cats = await getCategories();
      final words = await getWords(categoryId: e.categoryId);
      emit(
        AdminWordsState(
          words: words,
          categories: cats,
          selectedCategory: e.categoryId,
        ),
      );
    } catch (_) {
      emit(AdminErrorState(message: 'تعذر تحميل الكلمات'));
    }
  }

  // ✅ تعديل: reload مباشرة بدل add()
  Future<void> _onAddWord(AddWordEvent e, Emitter<AdminState> emit) async {
    try {
      await addWord(e.word);
      emit(
        AdminActionSuccessState(
          message: 'تمت إضافة الكلمة بنجاح',
          previousState: state,
        ),
      );

      // ✅ reload مباشرة
      emit(AdminLoadingState());
      final cats = await getCategories();
      final words = await getWords();
      emit(AdminWordsState(words: words, categories: cats));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر إضافة الكلمة: $e'));
    }
  }

  Future<void> _onUpdateWord(
    UpdateWordEvent e,
    Emitter<AdminState> emit,
  ) async {
    try {
      await updateWord(e.word);
      emit(
        AdminActionSuccessState(
          message: 'تم تعديل الكلمة بنجاح',
          previousState: state,
        ),
      );

      // ✅ reload مباشرة
      emit(AdminLoadingState());
      final cats = await getCategories();
      final words = await getWords();
      emit(AdminWordsState(words: words, categories: cats));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر تعديل الكلمة: $e'));
    }
  }

  Future<void> _onDeleteWord(
    DeleteWordEvent e,
    Emitter<AdminState> emit,
  ) async {
    try {
      await deleteWord(e.wordId);
      emit(
        AdminActionSuccessState(
          message: 'تم حذف الكلمة بنجاح',
          previousState: state,
        ),
      );

      // ✅ reload مباشرة
      emit(AdminLoadingState());
      final cats = await getCategories();
      final words = await getWords();
      emit(AdminWordsState(words: words, categories: cats));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر حذف الكلمة: $e'));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent e,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoadingState());
    try {
      final cats = await getCategories();
      emit(AdminCategoriesState(categories: cats));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر تحميل الفئات: $e'));
    }
  }

  Future<void> _onAddCategory(
    AddCategoryEvent e,
    Emitter<AdminState> emit,
  ) async {
    try {
      await addCategory(name: e.name, description: e.description);
      emit(
        AdminActionSuccessState(
          message: 'تمت إضافة الفئة بنجاح',
          previousState: state,
        ),
      );

      // ✅ reload مباشرة
      emit(AdminLoadingState());
      final cats = await getCategories();
      emit(AdminCategoriesState(categories: cats));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر إضافة الفئة: $e'));
    }
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent e,
    Emitter<AdminState> emit,
  ) async {
    try {
      await deleteCategory(e.categoryId);
      emit(
        AdminActionSuccessState(
          message: 'تم حذف الفئة بنجاح',
          previousState: state,
        ),
      );

      // ✅ reload مباشرة
      emit(AdminLoadingState());
      final cats = await getCategories();
      emit(AdminCategoriesState(categories: cats));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر حذف الفئة: $e'));
    }
  }

  Future<void> _onLoadRequests(
    LoadRequestsEvent e,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoadingState());
    try {
      final requests = await getRequests();
      emit(AdminRequestsState(requests: requests));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر تحميل الطلبات: $e'));
    }
  }

  Future<void> _onAcceptRequest(
    AcceptRequestEvent e,
    Emitter<AdminState> emit,
  ) async {
    try {
      await acceptRequest(e.requestId);
      emit(
        AdminActionSuccessState(
          message: 'تم قبول الطلب بنجاح',
          previousState: state,
        ),
      );

      // ✅ reload مباشرة
      emit(AdminLoadingState());
      final requests = await getRequests();
      emit(AdminRequestsState(requests: requests));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر قبول الطلب: $e'));
    }
  }

  Future<void> _onRejectRequest(
    RejectRequestEvent e,
    Emitter<AdminState> emit,
  ) async {
    try {
      await rejectRequest(e.requestId);
      emit(
        AdminActionSuccessState(message: 'تم رفض الطلب', previousState: state),
      );

      // ✅ reload مباشرة
      emit(AdminLoadingState());
      final requests = await getRequests();
      emit(AdminRequestsState(requests: requests));
    } catch (e) {
      emit(AdminErrorState(message: 'تعذر رفض الطلب: $e'));
    }
  }
}
