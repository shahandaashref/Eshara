part of 'dictionary_bloc.dart';

abstract class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoriesEvent extends DictionaryEvent {}

class LoadWordsEvent extends DictionaryEvent {
  final String categoryId;
  const LoadWordsEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class SearchSignsEvent extends DictionaryEvent {
  final String query;
  const SearchSignsEvent(this.query);

  @override
  List<Object> get props => [query];
}