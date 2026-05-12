import 'package:eshara/features/Dictionary/Domin/usecases/get_signs_usecase.dart';
import 'package:eshara/features/Dictionary/Domin/usecases/search_signs_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshara/features/Dictionary/Domin/entities/sign_entity.dart';
import 'package:equatable/equatable.dart';

part 'dictionary_event.dart';
part 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final GetSignsUseCase getSignsUseCase;
  final SearchSignsUseCase searchSignsUseCase;

  DictionaryBloc({
    required this.getSignsUseCase,
    required this.searchSignsUseCase,
  }) : super(DictionaryInitial()) {
    on<LoadSignsEvent>(_onLoadSigns);
    on<SearchSignsEvent>(_onSearchSigns);
  }

  Future<void> _onLoadSigns(
    LoadSignsEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    emit(DictionaryLoading());
    try {
      final signs = await getSignsUseCase(event.category);
      emit(DictionaryLoaded(signs, event.category));
    } catch (e) {
      emit(DictionaryError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSearchSigns(
    SearchSignsEvent event,
    Emitter<DictionaryState> emit,
  ) async {
    emit(DictionaryLoading());
    try {
      final signs = await searchSignsUseCase(event.query);
      // هنا نرسل category فارغ لأن البحث لا يعتمد على category معين
      emit(DictionaryLoaded(signs, ''));
    } catch (e) {
      emit(DictionaryError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
