import 'package:eshara/features/Profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future<void> updateProfile(ProfileEntity profile);
  Future<void> logout();
}
