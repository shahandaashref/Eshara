import 'package:dio/dio.dart';
import 'package:eshara/features/Profile/domain/usecases/profile_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshara/features/Profile/ui/bloc/profile_event.dart';
import 'package:eshara/features/Profile/ui/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.logoutUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUseCase();
      emit(ProfileLoaded(profile));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(ProfileSessionExpired(
          message: 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
        ));
      } else {
        emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
      }
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());
    try {
      await updateProfileUseCase(event.profile);
      emit(ProfileUpdateSuccess());
      
      emit(ProfileLoading());
      final profile = await getProfileUseCase();
      emit(ProfileLoaded(profile));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(ProfileSessionExpired(
          message: 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
        ));
      } else {
        emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
      }
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      await logoutUseCase();
      emit(ProfileLoggedOutState());
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}