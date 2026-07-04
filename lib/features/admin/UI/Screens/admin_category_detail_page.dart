import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';
import 'package:eshara/features/admin/UI/Widget/admin_widgets.dart';
import 'package:eshara/features/admin/UI/bloc/admin_bloc.dart';
import 'package:eshara/features/admin/UI/bloc/admin_event_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCategoryDetailPage extends StatefulWidget {
  final AdminCategory category;

  const AdminCategoryDetailPage({super.key, required this.category});

  @override
  State<AdminCategoryDetailPage> createState() =>
      _AdminCategoryDetailPageState();
}

class _AdminCategoryDetailPageState extends State<AdminCategoryDetailPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(
      text: widget.category.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final updatedCategory = widget.category.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      context.read<AdminBloc>().add(
        UpdateCategoryEvent(category: updatedCategory),
      );
      Navigator.of(context).pop();
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
          children: [
            AdminAppBar(title: 'تعديل الفئة'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('اسم الفئة', style: tt.titleMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'ادخل اسم الفئة',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'اسم الفئة مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text('الوصف (اختياري)', style: tt.titleMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'ادخل وصف الفئة',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveCategory,
                          child: const Text('حفظ التعديلات'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
