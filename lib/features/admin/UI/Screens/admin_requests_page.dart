import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';
import 'package:eshara/features/admin/UI/Widget/admin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event_state.dart';


/// [Page] — AdminRequestsPage
/// بتعرض طلبات الكلمات من المستخدمين مع إمكانية القبول والرفض
class AdminRequestsPage extends StatefulWidget {
  const AdminRequestsPage({super.key});

  @override
  State<AdminRequestsPage> createState() => _AdminRequestsPageState();
}

class _AdminRequestsPageState extends State<AdminRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Column(
          children: [
            const AdminAppBar(title: 'طلبات الكلمات'),
            Expanded(
              child: BlocConsumer<AdminBloc, AdminState>(
                listener: (context, state) {
                  if (state is AdminActionSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is AdminLoadingState) {
                    return const Center(child: CircularProgressIndicator(color: EsharaTheme.primaryBlue));
                  }
                  if (state is AdminRequestsState) {
                    return _buildList(context, state.requests);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<WordRequest> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.inbox_rounded, size: 64, color: EsharaTheme.textHint),
          const SizedBox(height: 12),
          Text('لا توجد طلبات معلقة',
              style: Theme.of(context).textTheme.bodyLarge),
        ]),
      );
    }

    // نقسم الطلبات: الجديدة أولاً
    final pending = requests.where((r) => r.status == WordRequestStatus.pending).toList();
    final others = requests.where((r) => r.status != WordRequestStatus.pending).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pending.isNotEmpty) ...[
          _SectionHeader(title: 'طلبات الكلمات الجديدة'),
          ...pending.map((r) => _RequestCard(
                request: r,
                onReview: () => _showReviewSheet(context, r),
              )),
        ],
        if (others.isNotEmpty) ...[
          const SizedBox(height: 8),
          _SectionHeader(title: 'طلبات أُخرى'),
          ...others.map((r) => _RequestCard(request: r)),
        ],
      ],
    );
  }

  void _showReviewSheet(BuildContext context, WordRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(
        value: context.read<AdminBloc>(),
        child: _ReviewSheet(request: request),
      ),
    );
  }
}

// ── Review Bottom Sheet ────────────────────────────────────────────────────
class _ReviewSheet extends StatelessWidget {
  final WordRequest request;
  const _ReviewSheet({required this.request});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('مراجعة طلب كلمة',
                style: tt.headlineMedium!.copyWith(color: EsharaTheme.textPrimary)),
            const SizedBox(height: 16),

            // بيانات الطلب
            _ReviewRow(label: 'الكلمة', value: request.word, tt: tt),
            _ReviewRow(label: 'المستخدم', value: request.userName, tt: tt),
            _ReviewRow(label: 'البريد', value: request.userEmail, tt: tt),

            const SizedBox(height: 8),

            // فيديو placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 160,
                color: const Color(0xFF0A0E27),
                child: const Center(
                  child: Icon(Icons.play_circle_outline_rounded,
                      color: Colors.white38, size: 48),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // التصنيف
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: EsharaTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: EsharaTheme.border)),
              child: Row(
                children: [
                  Text('طبية', style: tt.bodyMedium),
                  const Spacer(),
                  Text('التصنيف', style: tt.bodySmall),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // أزرار القبول والرفض
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<AdminBloc>().add(RejectRequestEvent(requestId: request.id));
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: EsharaTheme.error,
                    side: const BorderSide(color: EsharaTheme.error),
                  ),
                  child: const Text('رفض الطلب'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AdminBloc>().add(AcceptRequestEvent(requestId: request.id));
                    Navigator.pop(context);
                  },
                  child: const Text('قبول الطلب'),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme tt;
  const _ReviewRow({required this.label, required this.value, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(value, style: tt.bodyLarge!.copyWith(color: EsharaTheme.textPrimary)),
          const Spacer(),
          Text(label, style: tt.bodySmall),
        ],
      ),
    );
  }
}

// ── Request Card ───────────────────────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final WordRequest request;
  final VoidCallback? onReview;
  const _RequestCard({required this.request, this.onReview});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isPending = request.status == WordRequestStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EsharaTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPending ? EsharaTheme.primaryBlue.withOpacity(0.3) : EsharaTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              // status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPending
                      ? EsharaTheme.warning.withOpacity(0.15)
                      : request.status == WordRequestStatus.accepted
                          ? EsharaTheme.success.withOpacity(0.15)
                          : EsharaTheme.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isPending ? 'معلق' : request.status == WordRequestStatus.accepted ? 'مقبول' : 'مرفوض',
                  style: tt.labelSmall!.copyWith(
                    color: isPending
                        ? EsharaTheme.warning
                        : request.status == WordRequestStatus.accepted
                            ? EsharaTheme.success
                            : EsharaTheme.error,
                  ),
                ),
              ),
              const Spacer(),
              Text(request.word,
                  style: tt.titleMedium!.copyWith(color: EsharaTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(request.userName, style: tt.bodySmall),
          const SizedBox(height: 10),
          Row(
            children: [
              if (isPending && onReview != null)
                ElevatedButton(
                  onPressed: onReview,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    textStyle: const TextStyle(fontSize: 13, fontFamily: 'Cairo'),
                  ),
                  child: const Text('مراجعة الطلب'),
                ),
              if (isPending && onReview != null)
                const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  textStyle: const TextStyle(fontSize: 13, fontFamily: 'Cairo'),
                ),
                child: const Text('عرض التفاصيل'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: EsharaTheme.textPrimary)),
    );
  }
}
