import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Notifications/UI/notifications_page.dart';
import 'package:eshara/features/Profile/Ui/Widgets/app_info_card.dart';
import 'package:eshara/features/Profile/Ui/Widgets/settings_section.dart';
import 'package:eshara/features/Profile/Ui/Widgets/profile_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/app_bottom_nav.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import 'edit_profile_page.dart';


/// [Page] — ProfilePage
/// الصفحة الرئيسية للملف الشخصي.
/// بتعرض بيانات المستخدم وإعدادات التطبيق وروابط الـ actions.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _navIndex = 4;

  @override
  void initState() {
    super.initState();
    // بنجيب بيانات المستخدم لما الصفحة تفتح
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  // لما يتسجل خروج نروح لصفحة اللوجين
                  if (state is ProfileLoggedOutState) {
                    // Navigator.pushReplacementNamed(context, '/login');
                  }
                  if (state is ProfileUpdatedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ProfileLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: EsharaTheme.primaryBlue,
                      ),
                    );
                  }
                  if (state is ProfileErrorState && state.user == null) {
                    return _buildError(context, state.message);
                  }

                  // بناخد الـ user من أي state فيها user
                  final user = switch (state) {
                    ProfileLoadedState s  => s.user,
                    ProfileUpdatingState s => s.user,
                    ProfileUpdatedState s => s.user,
                    ProfileErrorState s   => s.user,
                    _                    => null,
                  };

                  if (user == null) return const SizedBox();
                  return _buildBody(context, state, user);
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _navIndex,
          onTap: (i) => setState(() => _navIndex = i),
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      color: EsharaTheme.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        right: 20,
        left: 20,
      ),
      child: Row(
        children: [
          _IconBtn(icon: Icons.refresh_rounded, onTap: () {
            context.read<ProfileBloc>().add(LoadProfileEvent());
          }),
          const SizedBox(width: 8),
          _IconBtn(icon: Icons.notifications_outlined, onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()));
          }),
          const Spacer(),
          Row(children: [
            Text(AppStrings.appName,
                style: tt.headlineLarge!.copyWith(color: EsharaTheme.primaryBlue)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: EsharaTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.sign_language_rounded,
                  color: Colors.white, size: 16),
            ),
          ]),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext context, ProfileState state, user) {
    final tt = Theme.of(context).textTheme;
    final isUpdating = state is ProfileUpdatingState;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 24),

          // ── Avatar + Name ─────────────────────────────────────────────────
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    // الصورة الشخصية
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: EsharaTheme.primaryBlue,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : 'أ',
                        style: tt.displayMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                    // زرار التعديل
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () => _goToEdit(context, user),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: EsharaTheme.primaryBlue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(user.name, style: tt.displaySmall!.copyWith(
                    color: EsharaTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(user.email, style: tt.bodyMedium),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── بيانات المستخدم ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: EsharaTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: EsharaTheme.border),
            ),
            child: Column(
              children: [
                ProfileInfoRow(
                  icon: Icons.person_outline_rounded,
                  label: 'الاسم',
                  value: user.name,
                ),
                const Divider(height: 1, color: EsharaTheme.divider),
                ProfileInfoRow(
                  icon: Icons.email_outlined,
                  label: 'البريد الإلكتروني',
                  value: user.email,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── الإشعارات toggle ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: EsharaTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: EsharaTheme.border),
            ),
            child: Row(
              children: [
                Switch(
                  value: user.notificationsEnabled,
                  activeColor: EsharaTheme.primaryBlue,
                  onChanged: (val) {
                    context.read<ProfileBloc>()
                        .add(ToggleNotificationsEvent(enabled: val));
                  },
                ),
                const Spacer(),
                Text('الإشعارات', style: tt.titleMedium!.copyWith(
                    color: EsharaTheme.textPrimary)),
                const SizedBox(width: 8),
                const Icon(Icons.notifications_outlined,
                    color: EsharaTheme.primaryBlue, size: 20),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── معلومات التطبيق ───────────────────────────────────────────────
          const AppInfoCard(),

          const SizedBox(height: 16),

          // ── إعدادات الحساب ────────────────────────────────────────────────
          SettingsSection(
            onEditProfile: () => _goToEdit(context, user),
            onLogout: () => _showLogoutDialog(context),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Error state ────────────────────────────────────────────────────────────
  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 64, color: EsharaTheme.error),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                context.read<ProfileBloc>().add(LoadProfileEvent()),
            child: const Text('حاول مرة أخرى'),
          ),
        ],
      ),
    );
  }

  // ── Navigation helpers ─────────────────────────────────────────────────────
  void _goToEdit(BuildContext context, user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ProfileBloc>(),
          child: EditProfilePage(user: user),
        ),
      ),
    );
  }

  /// [_showLogoutDialog] — بيظهر الـ bottom sheet لتأكيد تسجيل الخروج
  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _LogoutSheet(
        onConfirm: () {
          Navigator.pop(context);
          context.read<ProfileBloc>().add(LogoutEvent());
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}

// ── Logout Bottom Sheet ────────────────────────────────────────────────────
/// [Widget] — _LogoutSheet
/// الـ bottom sheet اللي بيتظهر لتأكيد تسجيل الخروج
class _LogoutSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _LogoutSheet({required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة التحذير
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: EsharaTheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  color: EsharaTheme.error, size: 32),
            ),
            const SizedBox(height: 16),
            Text('تسجيل الخروج',
                style: tt.headlineMedium!.copyWith(
                    color: EsharaTheme.textPrimary)),
            const SizedBox(height: 8),
            Text(
              'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
              style: tt.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // زرار تسجيل الخروج
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: EsharaTheme.error,
                  side: const BorderSide(color: EsharaTheme.error),
                ),
                child: const Text('تسجيل الخروج'),
              ),
            ),
            const SizedBox(height: 10),
            // زرار إلغاء
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                child: const Text('إلغاء'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Helper widget ──────────────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: EsharaTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: EsharaTheme.textSecondary),
      ),
    );
  }
}
