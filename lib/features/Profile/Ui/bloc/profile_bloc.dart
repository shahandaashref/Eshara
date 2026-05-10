import 'package:eshara/features/Profile/Domin/usecases/profile_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// [BLoC] — ProfileBloc
/// بيدير كل states الـ profile feature:
/// loading → loaded → updating → updated / error
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final LogoutUseCase logoutUseCase;
  final ToggleNotificationsUseCase toggleNotificationsUseCase;

  ProfileBloc({
    required this.getUserUseCase,
    required this.updateUserUseCase,
    required this.logoutUseCase,
    required this.toggleNotificationsUseCase,
  }) : super(ProfileLoadingState()) {
    on<LoadProfileEvent>(_onLoad);
    on<UpdateProfileEvent>(_onUpdate);
    on<LogoutEvent>(_onLogout);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
  }

  /// [_onLoad] — بيجيب بيانات المستخدم لما الصفحة تفتح
  Future<void> _onLoad(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      final user = await getUserUseCase();
      emit(ProfileLoadedState(user: user));
    } catch (e) {
      emit(ProfileErrorState(message: 'تعذر تحميل البيانات، حاول مرة أخرى'));
    }
  }

  /// [_onUpdate] — بيحفظ التعديلات الجديدة على بيانات المستخدم
  Future<void> _onUpdate(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdatingState(user: event.user));
    try {
      final updated = await updateUserUseCase(event.user);
      emit(ProfileUpdatedState(user: updated));
    } catch (e) {
      emit(ProfileErrorState(
        message: 'تعذر حفظ التغييرات، حاول مرة أخرى',
        user: event.user,
      ));
    }
  }

  /// [_onLogout] — بيعمل تسجيل خروج ويحول الـ state لـ LoggedOut
  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    try {
      await logoutUseCase();
      emit(ProfileLoggedOutState());
    } catch (e) {
      emit(ProfileErrorState(message: 'تعذر تسجيل الخروج، حاول مرة أخرى'));
    }
  }

  /// [_onToggleNotifications] — بيحدث حالة الإشعارات ويـ emit الـ state الجديدة
  Future<void> _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // بناخد الـ user الحالي من الـ state لو موجود
    final currentUser = switch (state) {
      ProfileLoadedState s  => s.user,
      ProfileUpdatedState s => s.user,
      _                     => null,
    };
    if (currentUser == null) return;

    try {
      await toggleNotificationsUseCase(event.enabled);
      emit(ProfileLoadedState(
        user: currentUser.copyWith(notificationsEnabled: event.enabled),
      ));
    } catch (e) {
      // لو فشل نرجع الـ toggle للحالة الأصلية
      emit(ProfileLoadedState(user: currentUser));
    }
  }
}
