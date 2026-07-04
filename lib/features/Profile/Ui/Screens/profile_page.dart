import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/Widgets/custom_app_bar.dart';
import 'package:eshara/features/Profile/Ui/Screens/edit_profile_page.dart';
import 'package:eshara/features/Profile/Ui/Widgets/settings_section.dart';
import 'package:eshara/features/admin/UI/Screens/admin_categories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoggedOutState) {
          // عند تسجيل الخروج بنجاح، يتم توجيه المستخدم لصفحة تسجيل الدخول
          // مع حذف جميع الصفحات السابقة من الـ stack
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'الملف الشخصي', showBackButton: true),
        backgroundColor: EsharaTheme.background,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: EsharaTheme.primaryBlue,
                ),
              );
            }
            if (state is ProfileError) {
              return Center(
                child: Text(
                  'حدث خطأ أثناء تحميل الملف الشخصي: \n${state.message}',
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (state is ProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // You can add a profile picture here
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: EsharaTheme.primaryLight,
                      child: Icon(
                        Icons.person_rounded,
                        size: 50,
                        color: EsharaTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.fullName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    _ProfileInfoTile(
                      icon: Icons.person_outline_rounded,
                      title: 'الاسم الكامل',
                      value: profile.fullName,
                    ),
                    _ProfileInfoTile(
                      icon: Icons.email_outlined,
                      title: 'البريد الإلكتروني',
                      value: profile.email,
                    ),
                    const SizedBox(height: 24),
                    SettingsSection(
                      onEditProfile: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<ProfileBloc>(),
                              child: EditProfilePage(profile: profile),
                            ),
                          ),
                        );
                      },
                      onLogout: () => _showLogoutConfirmation(context),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Please load your profile.'));
          },
        ),
      ),
    );
  }
}

/// دالة لعرض ورقة تأكيد تسجيل الخروج
void _showLogoutConfirmation(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: EsharaTheme.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ConfirmDeleteSheet(
      title: 'تسجيل الخروج',
      subtitle: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      confirmText: 'نعم، قم بتسجيل الخروج',
      onConfirm: () {
        // إرسال حدث تسجيل الخروج إلى الـ BLoC
        context.read<ProfileBloc>().add(LogoutEvent());
      },
    ),
  );
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: EsharaTheme.primaryBlue),
      title: Text(title),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
