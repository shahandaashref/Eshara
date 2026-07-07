import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/Helper/snackbar_helper.dart';
import 'package:eshara/features/admin/domain/entities/admin_entities.dart';
import 'package:eshara/features/admin/ui/Widget/admin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event_state.dart';
import 'admin_word_detail_page.dart';

/// [Page] — AdminWordsPage
/// بتعرض قائمة الكلمات مع فلتر الفئات + إضافة / تعديل / حذف
class AdminWordsPage extends StatefulWidget {
  const AdminWordsPage({super.key});

  @override
  State<AdminWordsPage> createState() => _AdminWordsPageState();
}

class _AdminWordsPageState extends State<AdminWordsPage> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadWordsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Column(
          children: [
            AdminAppBar(
              title: 'كلمات الفئة',
              actions: [
                // زرار إضافة كلمة جديدة
                BlocBuilder<AdminBloc, AdminState>(
                  builder: (ctx, state) {
                    return GestureDetector(
                      onTap: () async {
                        if (state is AdminWordsState) {
                          await _showAddWordSheet(ctx, state.categories);
                          ctx.read<AdminBloc>().add(
                            LoadWordsEvent(categoryId: _selectedCategory),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          gradient: EsharaTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'كلمة جديدة',
                              style: tt.labelMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: BlocConsumer<AdminBloc, AdminState>(
                listener: (context, state) {
                  if (state is AdminActionSuccessState) {
                    SnackbarHelper.showCustomSnackBar(context, state.message);
                  } else if (state is AdminErrorState) {
                    SnackbarHelper.showCustomSnackBar(
                      context,
                      state.message,
                      isError: true,
                    );
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
                  if (state is AdminWordsState) {
                    return _buildContent(context, tt, state, state.isLoading);
                  }
                  if (state is AdminErrorState) {
                    return Center(child: Text(state.message));
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

  Widget _buildContent(
    BuildContext context,
    TextTheme tt,
    AdminWordsState state,
    bool isLoading,
  ) {
    return Column(
      children: [
        // ── Category filter chips ────────────────────────────────────
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = state.categories[i];
              final selected = state.selectedCategory == cat.id;
              return GestureDetector(
                onTap: () {
                  setState(
                    () =>
                        _selectedCategory = cat.name == 'الكل' ? null : cat.id,
                  );
                  context.read<AdminBloc>().add(
                    LoadWordsEvent(categoryId: _selectedCategory),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? EsharaTheme.primaryBlue
                        : EsharaTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? EsharaTheme.primaryBlue
                          : EsharaTheme.border,
                    ),
                  ),
                  child: Text(
                    cat.name,
                    style: tt.labelMedium!.copyWith(
                      color: selected
                          ? Colors.white
                          : EsharaTheme.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Words list ───────────────────────────────────────────────
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<AdminBloc>().add(
                LoadWordsEvent(categoryId: _selectedCategory),
              );
            },
            color: EsharaTheme.primaryBlue,
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.words.length,
                  itemBuilder: (_, i) {
                    final word = state.words[i];
                    return AdminWordTile(
                      word: word.word,
                      thumbnailUrl: word.thumbnailUrl,
                      onEdit: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<AdminBloc>(),
                              child: AdminWordDetailPage(
                                word: word,
                                isEdit: true,
                              ),
                            ),
                          ),
                        );
                        context.read<AdminBloc>().add(
                          LoadWordsEvent(categoryId: _selectedCategory),
                        );
                      },
                      onDelete: () => _showDeleteSheet(context, word),
                    );
                  },
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: EsharaTheme.primaryBlue,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Add Word Sheet ─────────────────────────────────────────────────────────
  Future<void> _showAddWordSheet(
    BuildContext context,
    List<AdminCategory> categories,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AdminBloc>(),
        child: _AddWordSheet(
          categories: categories.where((c) => c.name != 'الكل').toList(),
        ),
      ),
    );
  }

  // ── Delete Sheet ───────────────────────────────────────────────────────────
  void _showDeleteSheet(BuildContext context, AdminWord word) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ConfirmDeleteSheet(
        title: 'حذف الكلمة',
        subtitle: 'هل أنت متأكد من حذف كلمة "${word.word}"؟',
        onConfirm: () {
          context.read<AdminBloc>().add(DeleteWordEvent(wordId: word.id));
        },
      ),
    );
  }
}

// ── Add Word Bottom Sheet ──────────────────────────────────────────────────
class _AddWordSheet extends StatefulWidget {
  final List<AdminCategory> categories;
  const _AddWordSheet({required this.categories});

  @override
  State<_AddWordSheet> createState() => _AddWordSheetState();
}

class _AddWordSheetState extends State<_AddWordSheet> {
  final _wordCtrl = TextEditingController();
  final _glossCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _selectedCategoryId;
  bool _videoPicked = false;

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
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'إضافة كلمة جديدة',
                style: tt.headlineMedium!.copyWith(
                  color: EsharaTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // الكلمة
              TextField(
                controller: _wordCtrl,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(hintText: 'الكلمة'),
              ),
              const SizedBox(height: 12),

              // Gloss
              TextField(
                controller: _glossCtrl,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: 'Gloss (المصطلح الأجنبي)',
                ),
              ),
              const SizedBox(height: 12),

              // الفئة dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: EsharaTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: EsharaTheme.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategoryId,
                    hint: const Text('اختر الفئة'),
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerEnd,
                    items: widget.categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name, textAlign: TextAlign.right),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // رفع فيديو
              GestureDetector(
                onTap: () => setState(() => _videoPicked = true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: EsharaTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _videoPicked
                          ? EsharaTheme.primaryBlue
                          : EsharaTheme.border,
                    ),
                  ),
                  child: _videoPicked
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('video_sign.mp4', style: tt.bodyMedium),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.video_file_rounded,
                              color: EsharaTheme.primaryBlue,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const Icon(
                              Icons.cloud_upload_outlined,
                              color: EsharaTheme.textHint,
                              size: 32,
                            ),
                            const SizedBox(height: 6),
                            Text('رفع فيديو من المعرض', style: tt.bodyMedium),
                            Text('يدعم ملفات MP4، MOV', style: tt.bodySmall),
                          ],
                        ),
                ),
              ),

              if (_videoPicked) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _videoPicked = false),
                  child: Text(
                    'إلغاء العملية',
                    style: tt.labelMedium!.copyWith(color: EsharaTheme.error),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // الوصف
              TextField(
                controller: _descCtrl,
                textAlign: TextAlign.right,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'وصف الكلمة (اختياري)',
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_wordCtrl.text.trim().isEmpty ||
                        _glossCtrl.text.trim().isEmpty ||
                        _selectedCategoryId == null)
                      return;
                    context.read<AdminBloc>().add(
                      AddWordEvent(
                        word: AdminWord(
                          id: '',
                          word: _wordCtrl.text.trim(),
                          gloss: _glossCtrl.text.trim(),
                          categoryId: _selectedCategoryId,
                          description: _descCtrl.text.trim(),
                          createdAt: DateTime.now(),
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('إضافة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
