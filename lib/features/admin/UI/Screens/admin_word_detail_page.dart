import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';
import 'package:eshara/features/admin/UI/Widget/admin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event_state.dart';

/// [Page] — AdminWordDetailPage
/// بتعرض تفاصيل الكلمة مع إمكانية التعديل
/// [isEdit] — لو true بتظهر الـ fields قابلة للتعديل
class AdminWordDetailPage extends StatefulWidget {
  final AdminWord word;
  final bool isEdit;

  const AdminWordDetailPage({
    super.key,
    required this.word,
    this.isEdit = false,
  });

  @override
  State<AdminWordDetailPage> createState() => _AdminWordDetailPageState();
}

class _AdminWordDetailPageState extends State<AdminWordDetailPage> {
  late TextEditingController _wordCtrl;
  late TextEditingController _glossCtrl;
  late TextEditingController _descCtrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEdit;
    _wordCtrl = TextEditingController(text: widget.word.word);
    _glossCtrl = TextEditingController(text: widget.word.gloss);
    _descCtrl = TextEditingController(text: widget.word.description ?? '');
  }

  @override
  void dispose() {
    _wordCtrl.dispose();
    _glossCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: BlocListener<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state is AdminActionSuccessState) {
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              AdminAppBar(
                title: _isEditing ? 'تعديل الكلمة' : 'الكلمة',
                actions: [
                  // زرار تغيير لتعديل / حذف
                  if (!_isEditing)
                    Row(
                      children: [
                        _HeaderBtn(
                          label: 'تعديل',
                          color: EsharaTheme.primaryBlue,
                          onTap: () => setState(() => _isEditing = true),
                        ),
                        const SizedBox(width: 8),
                        _HeaderBtn(
                          label: 'حذف',
                          color: EsharaTheme.error,
                          onTap: () => _showDeleteSheet(context),
                        ),
                      ],
                    ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // ── Video thumbnail ──────────────────────────────
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          color: const Color(0xFF0A0E27),
                          child: Stack(
                            children: [
                              const Center(
                                child: Icon(Icons.smart_toy_rounded,
                                    size: 72, color: Colors.white24),
                              ),
                              // Play button
                              Center(
                                child: Container(
                                  width: 50, height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.white24, shape: BoxShape.circle),
                                  child: const Icon(Icons.play_arrow_rounded,
                                      color: Colors.white, size: 28),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── اسم الكلمة ───────────────────────────────────
                      Text('اسم الكلمة', style: tt.titleSmall),
                      const SizedBox(height: 6),
                      _isEditing
                          ? TextField(
                              controller: _wordCtrl,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(hintText: 'اسم الكلمة'),
                            )
                          : _InfoBox(value: widget.word.word, tt: tt),

                      const SizedBox(height: 16),

                      // ── Gloss ───────────────────────────────────
                      Text('Gloss (المصطلح الأجنبي)', style: tt.titleSmall),
                      const SizedBox(height: 6),
                      _isEditing
                          ? TextField(
                              controller: _glossCtrl,
                              textAlign: TextAlign.right,
                              decoration:
                                  const InputDecoration(hintText: 'Gloss'),
                            )
                          : _InfoBox(value: widget.word.gloss, tt: tt),
                      const SizedBox(height: 16),

                      // ── شرح الحركة ───────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: EsharaTheme.primaryBlue, size: 16),
                          const SizedBox(width: 6),
                          Text('شرح الحركة',
                              style: tt.titleSmall!
                                  .copyWith(color: EsharaTheme.primaryBlue)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _isEditing
                          ? TextField(
                              controller: _descCtrl,
                              textAlign: TextAlign.right,
                              maxLines: 3,
                              decoration: const InputDecoration(hintText: 'شرح الحركة'),
                            )
                          : _InfoBox(
                              value: widget.word.description ??
                                  'حرك اليد من جانب الرأس مع إبقاء الأصابع مفتوحة، ثم أدِّه في اتجاه عمودي.',
                              tt: tt,
                              maxLines: 4,
                            ),

                      const SizedBox(height: 24),

                      if (_isEditing) ...[
                        // ── رفع فيديو جديد ────────────────────────────
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: EsharaTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: EsharaTheme.border),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.cloud_upload_outlined,
                                    color: EsharaTheme.textHint, size: 32),
                                const SizedBox(height: 6),
                                Text('رفع فيديو من المعرض', style: tt.bodyMedium),
                                Text('يدعم ملفات MP4، MOV', style: tt.bodySmall),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // أزرار حفظ وإلغاء
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() => _isEditing = false),
                                child: const Text('إلغاء'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<AdminBloc>().add(
                                    UpdateWordEvent(
                                      word: widget.word.copyWith(
                                        word: _wordCtrl.text.trim(),
                                        gloss: _glossCtrl.text.trim(),
                                        description: _descCtrl.text.trim(),
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('حفظ التغييرات'),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // ── أزرار تعديل / مشاهدة في القاموس ──────────
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('مشاهدة الكلمة في القاموس'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ConfirmDeleteSheet(
        title: 'حذف الكلمة',
        subtitle: 'هل أنت متأكد من حذف كلمة "${widget.word.word}"؟',
        onConfirm: () => context.read<AdminBloc>()
            .add(DeleteWordEvent(wordId: widget.word.id)),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String value;
  final TextTheme tt;
  final int maxLines;
  const _InfoBox({required this.value, required this.tt, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: EsharaTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: EsharaTheme.border),
      ),
      child: Text(value,
          style: tt.bodyLarge!.copyWith(color: EsharaTheme.textPrimary),
          textAlign: TextAlign.right,
          maxLines: maxLines),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _HeaderBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(label,
            style: TextStyle(color: color, fontSize: 13, fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
      ),
    );
  }
}
