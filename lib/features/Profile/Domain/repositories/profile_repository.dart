import 'package:eshara/features/Profile/Domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future<void> updateProfile(ProfileEntity profile);
  Future<void> logout();
}
