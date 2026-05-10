import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

/// [Page] — NotificationsPage
/// بتعرض قائمة الإشعارات الجديدة والسابقة.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  // Mock notifications data
  static final List<_NotificationItem> _newNotifs = [
    _NotificationItem(
      icon: Icons.location_on_rounded,
      title: 'تم إضافة كلمة جديدة إلى قاموسك الشخصي',
      subtitle: 'تحقق من القاموس الخاص بك لمراجعة الكلمات الجديدة.',
      isNew: true,
    ),
  ];

  static final List<_NotificationItem> _prevNotifs = [
    _NotificationItem(
      icon: Icons.location_on_rounded,
      title: 'تم إضافة كلمة جديدة إلى قاموسك الشخصي',
      subtitle: 'تحقق من القاموس الخاص بك لمراجعة الكلمات الجديدة.',
      isNew: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Column(
          children: [
            _buildAppBar(context, tt),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ── الإشعارات الجديدة ─────────────────────────────────
                  _buildSectionHeader(tt, 'الجديد'),
                  const SizedBox(height: 10),
                  ..._newNotifs.map((n) => _NotifCard(item: n)),

                  const SizedBox(height: 20),

                  // ── الإشعارات السابقة ─────────────────────────────────
                  _buildSectionHeader(tt, 'الأسبوع الماضي'),
                  const SizedBox(height: 10),
                  ..._prevNotifs.map((n) => _NotifCard(item: n)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          Text('الإشعارات', style: tt.headlineLarge),
          const Spacer(),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(TextTheme tt, String title) {
    return Text(title,
        style: tt.titleLarge!.copyWith(color: EsharaTheme.textPrimary));
  }
}

// ── Notification Card ──────────────────────────────────────────────────────
class _NotifCard extends StatelessWidget {
  final _NotificationItem item;
  const _NotifCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EsharaTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isNew ? EsharaTheme.primaryBlue.withOpacity(0.3) : EsharaTheme.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(item.title,
                    style: tt.titleSmall!.copyWith(
                        color: EsharaTheme.textPrimary),
                    textAlign: TextAlign.right),
                const SizedBox(height: 4),
                Text(item.subtitle,
                    style: tt.bodySmall,
                    textAlign: TextAlign.right),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // الأيقونة
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.isNew
                  ? EsharaTheme.primaryBlue.withOpacity(0.1)
                  : EsharaTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon,
                color: item.isNew
                    ? EsharaTheme.primaryBlue
                    : EsharaTheme.textHint,
                size: 20),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isNew;

  _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isNew,
  });
}
