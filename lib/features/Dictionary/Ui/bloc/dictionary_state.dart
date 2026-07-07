part of 'dictionary_bloc.dart';

abstract class DictionaryState extends Equatable {
  const DictionaryState();

  @override
  List<Object> get props => [];
}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionaryCategoriesLoaded extends DictionaryState {
  final List<CategoryEntity> categories;
  const DictionaryCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class DictionaryWordsLoaded extends DictionaryState {
  final List<SignEntity> words;
  final String? selectedCategoryId;
  const DictionaryWordsLoaded({
    required this.words,
    this.selectedCategoryId,
  });

  @override
  List<Object> get props => [words, selectedCategoryId ?? ''];
}

class DictionaryError extends DictionaryState {
  final String message;
  const DictionaryError(this.message);

  @override
  List<Object> get props => [message];
}