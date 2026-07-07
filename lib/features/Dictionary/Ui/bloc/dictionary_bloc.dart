import 'package:eshara/features/Dictionary/domain/entities/sign_entity.dart';
import 'package:eshara/features/Dictionary/domain/entities/category_entity.dart';
import 'package:eshara/features/Dictionary/domain/usecases/get_categories_usecase.dart';
import 'package:eshara/features/Dictionary/domain/usecases/get_words_usecase.dart';
import 'package:eshara/features/Dictionary/domain/usecases/search_signs_usecase.dart';
import 'package:eshara/features/Dictionary/ui/bloc/dictionary_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dictionary_event.dart';
part 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetWordsUseCase getWordsUseCase;
  final SearchSignsUseCase searchSignsUseCase;

  DictionaryBloc({
    required this.getCategoriesUseCase,
    required this.getWordsUseCase,
    required this.searchSignsUseCase,
  }) : super(DictionaryInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadWordsEvent>(_onLoadWords);
    on<SearchSignsEvent>(_onSearchSigns);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    emit(DictionaryLoading());
    try {
      final categories = await getCategoriesUseCase();
      emit(DictionaryCategoriesLoaded(categories));
      
      // ✅ نحمل كلمات أول فئة تلقائياً
      if (categories.isNotEmpty) {
        add(LoadWordsEvent(categoryId: categories.first.id));
      }
    } catch (e) {
      emit(DictionaryError('فشل تحميل الفئات: ${e.toString()}'));
    }
  }

  Future<void> _onLoadWords(
    LoadWordsEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    emit(DictionaryLoading());
    try {
      final words = await getWordsUseCase(categoryId: event.categoryId);
      emit(DictionaryWordsLoaded(
        words: words,
        selectedCategoryId: event.categoryId,
      ));
    } catch (e) {
      emit(DictionaryError('فشل تحميل الكلمات: ${e.toString()}'));
    }
  }

  Future<void> _onSearchSigns(
    SearchSignsEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    emit(DictionaryLoading());
    try {
      final words = await searchSignsUseCase(event.query);
      emit(DictionaryWordsLoaded(
        words: words,
        selectedCategoryId: null, // في وضع البحث مفيش فئة محددة
      ));
    } catch (e) {
      emit(DictionaryError('فشل البحث: ${e.toString()}'));
    }
  }
}