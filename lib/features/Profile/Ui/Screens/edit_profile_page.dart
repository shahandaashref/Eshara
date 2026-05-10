import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Profile/Domin/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

/// [Page] — EditProfilePage
/// بتتعرض لما المستخدم يضغط "تعديل الملف الشخصي".
/// بتاخد [user] الحالي وبتظهره في الـ fields للتعديل.
class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // بنحط بيانات المستخدم الحالية في الـ controllers
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    // مهم تـ dispose الـ controllers عشان ما يحصلش memory leak
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            // لما التحديث ينجح نرجع للصفحة السابقة
            if (state is ProfileUpdatedState) {
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              _buildAppBar(context, tt),
              Expanded(
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state is ProfileUpdatingState;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 16),

                            // ── الاسم الجديد ──────────────────────────────
                            _buildLabel(tt, 'الاسم الجديد'),
                            const SizedBox(height: 6),
                            _buildField(
                              controller: _nameController,
                              hint: 'أدخل اسمك الجديد',
                              icon: Icons.person_outline_rounded,
                              validator: (v) => v == null || v.isEmpty
                                  ? 'الاسم مطلوب'
                                  : null,
                            ),

                            const SizedBox(height: 16),

                            // ── البريد الإلكتروني الجديد ──────────────────
                            _buildLabel(tt, 'البريد الإلكتروني الجديد'),
                            const SizedBox(height: 6),
                            _buildField(
                              controller: _emailController,
                              hint: 'أدخل بريدك الإلكتروني',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || !v.contains('@')
                                  ? 'بريد إلكتروني غير صحيح'
                                  : null,
                            ),

                            const SizedBox(height: 32),

                            // ── زرار الحفظ ────────────────────────────────
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _onSave,
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('حفظ التغييرات'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, TextTheme tt) {
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: EsharaTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 18, color: EsharaTheme.textPrimary),
            ),
          ),
          const Spacer(),
          Text('تعديل الملف الشخصي', style: tt.headlineLarge),
          const Spacer(),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  // ── Helper builders ────────────────────────────────────────────────────────
  Widget _buildLabel(TextTheme tt, String text) {
    return Text(text,
        style: tt.titleMedium!.copyWith(color: EsharaTheme.textPrimary));
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: EsharaTheme.textHint, size: 20),
      ),
    );
  }

  /// [_onSave] — بتـ validate الـ form وتبعت الـ event للـ BLoC
  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedUser = widget.user.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );
      context.read<ProfileBloc>().add(UpdateProfileEvent(user: updatedUser));
    }
  }
}
