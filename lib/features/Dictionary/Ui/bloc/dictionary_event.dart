part of 'dictionary_bloc.dart';

abstract class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  List<Object> get props => [];
}

class LoadSignsEvent extends DictionaryEvent {
  final String category;
  const LoadSignsEvent(this.category);

  @override
  List<Object> get props => [category];
}

class SearchSignsEvent extends DictionaryEvent {
  final String query;
  const SearchSignsEvent(this.query);

  @override
  List<Object> get props => [query];
}
