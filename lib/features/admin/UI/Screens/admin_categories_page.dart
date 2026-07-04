import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/Helper/snackbar_helper.dart';
import 'package:eshara/Core/Widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event_state.dart';

/// [Page] — AdminCategoriesPage
/// بتعرض قائمة الفئات مع إمكانية الإضافة والحذف
class AdminCategoriesPage extends StatefulWidget {
  const AdminCategoriesPage({super.key});

  @override
  State<AdminCategoriesPage> createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: EsharaTheme.background,
      appBar: CustomAppBar(
        title: 'الفئات',
        showBackButton: true,
        leadingActions: [
          GestureDetector(
            onTap: () => _showAddCategorySheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                gradient: EsharaTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'فئة جديدة',
                    style: tt.labelMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
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
              child: CircularProgressIndicator(color: EsharaTheme.primaryBlue),
            );
          }
          if (state is AdminCategoriesState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AdminBloc>().add(LoadCategoriesEvent());
              },
              color: EsharaTheme.primaryBlue,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.categories.length,
                itemBuilder: (_, i) {
                  final cat = state.categories[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: EsharaTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: EsharaTheme.border),
                    ),
                    child: Row(
                      children: [
                        // حذف الفئة
                        GestureDetector(
                          onTap: () =>
                              _showDeleteSheet(context, cat.id, cat.name),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: EsharaTheme.error.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.delete_rounded,
                              color: EsharaTheme.error,
                              size: 16,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // عدد الكلمات
                        Text('${cat.wordCount} كلمة', style: tt.bodySmall),
                        const SizedBox(width: 12),
                        // اسم الفئة
                        Text(
                          cat.name,
                          style: tt.titleMedium!.copyWith(
                            color: EsharaTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // أيقونة الفئة
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: EsharaTheme.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.folder_rounded,
                            color: EsharaTheme.primaryBlue,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showAddCategorySheet(BuildContext pageContext) {
    final ctrl = TextEditingController();
    final descCtrl = TextEditingController();
    showModalBottomSheet(
      context: pageContext,
      isScrollControlled: true,
      backgroundColor: EsharaTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: pageContext.read<AdminBloc>(),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(pageContext).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'إضافة فئة جديدة',
                style: Theme.of(pageContext).textTheme.headlineMedium!.copyWith(
                  color: EsharaTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: ctrl,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(hintText: 'اسم الفئة'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(hintText: 'الوصف (اختياري)'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(pageContext),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (ctrl.text.trim().isEmpty) return;
                        pageContext.read<AdminBloc>().add(
                          AddCategoryEvent(
                            name: ctrl.text.trim(),
                            description: descCtrl.text.trim(),
                          ),
                        );
                        Navigator.pop(pageContext);
                      },
                      child: const Text('إضافة'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteSheet(BuildContext pageContext, String id, String name) {
    showModalBottomSheet(
      context: pageContext,
      backgroundColor: EsharaTheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ConfirmDeleteSheet(
        title: 'حذف الفئة',
        subtitle:
            'هل أنت متأكد من حذف فئة "$name"؟\nسيتم حذف جميع الكلمات المرتبطة بها.',
        onConfirm: () => pageContext.read<AdminBloc>().add(
          DeleteCategoryEvent(categoryId: id),
        ),
      ),
    );
  }
}

/// [Widget] - ConfirmDeleteSheet
/// ورقة سفلية (BottomSheet) لتأكيد عمليات الحذف.
class ConfirmDeleteSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmText;
  final VoidCallback onConfirm;

  const ConfirmDeleteSheet({
    super.key,
    required this.title,
    required this.subtitle,
    this.confirmText = 'نعم، قم بالحذف',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EsharaTheme.error,
                  ),
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                  child: Text(confirmText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
