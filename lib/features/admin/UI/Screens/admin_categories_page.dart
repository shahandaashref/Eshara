import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/admin/UI/Widget/admin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event_state.dart';

import 'admin_words_page.dart';

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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        body: Column(
          children: [
            AdminAppBar(
              title: 'الفئات',
              actions: [
                GestureDetector(
                  onTap: () => _showAddCategorySheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: EsharaTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text('فئة جديدة', style: tt.labelMedium!.copyWith(color: Colors.white)),
                    ]),
                  ),
                ),
              ],
            ),
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
                  if (state is AdminCategoriesState) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.categories.length,
                      itemBuilder: (_, i) {
                        final cat = state.categories[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: EsharaTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: EsharaTheme.border),
                          ),
                          child: Row(
                            children: [
                              // حذف الفئة
                              GestureDetector(
                                onTap: () => _showDeleteSheet(context, cat.id, cat.name),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: EsharaTheme.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.delete_rounded,
                                      color: EsharaTheme.error, size: 16),
                                ),
                              ),
                              const Spacer(),
                              // عدد الكلمات
                              Text('${cat.wordCount} كلمة', style: tt.bodySmall),
                              const SizedBox(width: 12),
                              // اسم الفئة
                              Text(cat.name,
                                  style: tt.titleMedium!.copyWith(color: EsharaTheme.textPrimary)),
                              const SizedBox(width: 12),
                              // أيقونة الفئة
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: EsharaTheme.primaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.folder_rounded,
                                    color: EsharaTheme.primaryBlue, size: 18),
                              ),
                            ],
                          ),
                        );
                      },
                    );
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

  void _showAddCategorySheet(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(
        value: context.read<AdminBloc>(),
        child: Directionality(
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
                Text('إضافة فئة جديدة',
                    style: Theme.of(context).textTheme.headlineMedium!
                        .copyWith(color: EsharaTheme.textPrimary)),
                const SizedBox(height: 14),
                TextField(
                  controller: ctrl,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(hintText: 'اسم الفئة'),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(
                    onPressed: () {
                      if (ctrl.text.trim().isEmpty) return;
                      context.read<AdminBloc>().add(AddCategoryEvent(name: ctrl.text.trim()));
                      Navigator.pop(context);
                    },
                    child: const Text('إضافة'),
                  )),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteSheet(BuildContext context, String id, String name) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => ConfirmDeleteSheet(
        title: 'حذف الفئة',
        subtitle: 'هل أنت متأكد من حذف فئة "$name"؟\nسيتم حذف جميع الكلمات المرتبطة بها.',
        onConfirm: () => context.read<AdminBloc>().add(DeleteCategoryEvent(categoryId: id)),
      ),
    );
  }
}
