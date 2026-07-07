import 'dart:async';
import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Dictionary/domain/entities/category_entity.dart';
import 'package:eshara/features/Dictionary/ui/bloc/dictionary_bloc.dart';
import 'package:eshara/features/Dictionary/ui/widgets/sign_video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'word_detail_page.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  String? selectedCategoryId;
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // ✅ نحمل الفئات أولاً
    context.read<DictionaryBloc>().add(LoadCategoriesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: EsharaTheme.primaryBlue,
            ),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          title: Center(child: Image.asset('assets/logo/logo.png', height: 30)),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: EsharaTheme.primaryBlue),
              onPressed: () {
                if (selectedCategoryId != null) {
                  context.read<DictionaryBloc>().add(
                    LoadWordsEvent(categoryId: selectedCategoryId!),
                  );
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryList(),
            const SizedBox(height: 10),
            Expanded(child: _buildBlocBuilder()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/add_word'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text("كلمة جديدة"),
            style: ElevatedButton.styleFrom(
              backgroundColor: EsharaTheme.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Text("قاموس الإشارات", style: EsharaTheme.textTheme.headlineMedium),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: "...البحث عن كلمة",
          prefixIcon: const Icon(Icons.search, color: EsharaTheme.textHint),
          fillColor: EsharaTheme.surface,
        ),
        onChanged: (query) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            if (query.trim().isNotEmpty) {
              context.read<DictionaryBloc>().add(SearchSignsEvent(query));
            } else if (selectedCategoryId != null) {
              context.read<DictionaryBloc>().add(
                LoadWordsEvent(categoryId: selectedCategoryId!),
              );
            }
          });
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return BlocBuilder<DictionaryBloc, DictionaryState>(
      buildWhen: (previous, current) => current is DictionaryCategoriesLoaded,
      builder: (context, state) {
        if (state is DictionaryCategoriesLoaded) {
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                final isSelected = selectedCategoryId == category.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedCategoryId = category.id);
                      context.read<DictionaryBloc>().add(
                        LoadWordsEvent(categoryId: category.id),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? EsharaTheme.primaryBlue
                            : EsharaTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? EsharaTheme.primaryBlue
                              : EsharaTheme.border,
                        ),
                      ),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : EsharaTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBlocBuilder() {
    return BlocBuilder<DictionaryBloc, DictionaryState>(
      builder: (context, state) {
        if (state is DictionaryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: EsharaTheme.primaryBlue),
          );
        } else if (state is DictionaryWordsLoaded) {
          if (state.words.isEmpty) {
            return const Center(child: Text("لا توجد كلمات في هذا التصنيف"));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: state.words.length,
            itemBuilder: (context, index) {
              final sign = state.words[index];
              return SignVideoCard(
                sign: sign,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WordDetailPage(sign: sign),
                    ),
                  );
                },
              );
            },
          );
        } else if (state is DictionaryError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text("جارٍ التحميل..."));
      },
    );
  }
}