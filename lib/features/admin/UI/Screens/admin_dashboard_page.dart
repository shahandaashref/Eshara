import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/admin/ui/Widget/admin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_bloc.dart';
import '../bloc/admin_event_state.dart';

import 'admin_words_page.dart';
import 'admin_categories_page.dart';
import 'admin_requests_page.dart';

/// [Page] — AdminDashboardPage
/// لوحة تحكم الأدمن — بتعرض الإحصائيات والروابط السريعة
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadDashboardEvent());
  }

  void _reloadData() {
    if (mounted) {
      context.read<AdminBloc>().add(LoadDashboardEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminAppBar(
              title: 'لوحة تحكم المسؤول',
              showBack: false,
              actions: [
                IconButton(
                  icon:  Icon(
                    Icons.person_outline_rounded,
                    size: 28,
                    color: EsharaTheme.textPrimary,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
            Expanded(
              child: BlocConsumer<AdminBloc, AdminState>(
                listener: (context, state) {
                  if (state is AdminActionSuccessState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is AdminLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: EsharaTheme.primaryBlue,
                      ),
                    );
                  }
                  if (state is AdminDashboardState) {
                    return _buildDashboard(context, tt, state);
                  }
                  // This handles showing the updated dashboard after an action
                  if (state is AdminActionSuccessState &&
                      state.previousState is AdminDashboardState) {
                    return _buildDashboard(
                      context,
                      tt,
                      state.previousState as AdminDashboardState,
                    );
                  }
                  if (state is AdminErrorState) {
                    return Center(
                      child: Text(
                        state.message,
                        style: tt.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  // حالة افتراضية في حالة عدم تطابق أي من الحالات السابقة
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    TextTheme tt,
    AdminDashboardState state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── إحصائيات ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: AdminStatCard(
                  value: '${state.stats.totalWords}',
                  label: 'كلمة',
                  icon: Icons.library_books_rounded,
                  color: EsharaTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AdminStatCard(
                  value: '${state.stats.totalUsers}',
                  label: 'مستخدم',
                  icon: Icons.people_rounded,
                  color: EsharaTheme.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── الإجراءات السريعة ────────────────────────────────────────
          Text(
            'الإجراءات الطارئة',
            style: tt.titleLarge!.copyWith(color: EsharaTheme.textPrimary),
          ),
          const SizedBox(height: 10),

          Column(
            children: [
              _QuickActionRow(
                label: 'إضافة فئة جديدة',
                icon: Icons.create_new_folder_rounded,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AdminBloc>(),
                        child: const AdminCategoriesPage(),
                      ),
                    ),
                  );
                  _reloadData();
                },
              ),
              _QuickActionRow(
                label: 'إضافة كلمة جديدة',
                icon: Icons.add_box_rounded,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AdminBloc>(),
                        child: const AdminWordsPage(),
                      ),
                    ),
                  );
                  _reloadData();
                },
              ),
              _QuickActionRow(
                label: 'طلبات الكلمات',
                icon: Icons.mark_email_unread_rounded,
                badgeCount: state.stats.pendingRequests,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AdminBloc>(),
                        child: const AdminRequestsPage(),
                      ),
                    ),
                  );
                  _reloadData();
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── الفئات الطارئة ────────────────────────────────────────────
          Text(
            'الفئات الحالية',
            style: tt.titleLarge!.copyWith(color: EsharaTheme.textPrimary),
          ),
          const SizedBox(height: 10),
          // عرض الفئات الفعلية القادمة من الـ API
          ...state.categories
              .take(5) // نعرض أول 5 فئات فقط كمثال
              .map(
                (cat) =>
                    _CategoryStatRow(label: cat.name, count: cat.wordCount!),
              ),

          const SizedBox(height: 20),

          // ── notification card ─────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: EsharaTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'نبذة عن المسؤول اليوم',
                  style: tt.titleMedium!.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'لديك ${state.stats.pendingRequests} طلبات معلقة تحتاج مراجعة',
                  style: tt.bodySmall!.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final int? badgeCount;
  const _QuickActionRow({
    required this.label,
    required this.icon,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: EsharaTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: EsharaTheme.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.chevron_left_rounded, color: EsharaTheme.textHint),
            if (badgeCount != null && badgeCount! > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: EsharaTheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Spacer(),
            Text(
              label,
              style: tt.bodyLarge!.copyWith(color: EsharaTheme.textPrimary),
            ),
            const SizedBox(width: 10),
            Icon(icon, color: EsharaTheme.primaryBlue, size: 20),
          ],
        ),
      ),
    );
  }
}

class _CategoryStatRow extends StatelessWidget {
  final String label;
  final int count;
  const _CategoryStatRow({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$count',
            style: tt.bodyMedium!.copyWith(
              color: EsharaTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            label,
            style: tt.bodyMedium!.copyWith(color: EsharaTheme.textPrimary),
          ),
        ],
      ),
    );
  }
}
