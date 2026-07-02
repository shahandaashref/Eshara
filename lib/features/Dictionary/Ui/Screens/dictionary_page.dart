import 'dart:async';
import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dictionary_bloc.dart';
import 'word_detail_page.dart';
import '../widgets/sign_video_card.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  // قائمة التصنيفات زي ما في الصورة
  final List<String> categories = const [
    "الكل",
    "تحيات",
    "طيبة",
    "عائلة",
    "تعليم",
  ];
  String selectedCategory = "الكل";

  // Controller للتحكم في حقل البحث
  final _searchController = TextEditingController();
  // Timer لتأخير البحث أثناء الكتابة (Debouncing)
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // أول ما الصفحة تفتح بننادي أول تصنيف
    context.read<DictionaryBloc>().add(LoadSignsEvent(selectedCategory));
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
            tooltip: 'الملف الشخصي', // نص يظهر عند الضغط المطول
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          title: Center(child: Image.asset('assets/logo/logo.png', height: 30)),

          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: EsharaTheme.primaryBlue),
              onPressed: () => context.read<DictionaryBloc>().add(
                LoadSignsEvent(selectedCategory),
              ),
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
            onPressed: () {
              Navigator.pushNamed(context, '/add_word');
            },
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
          // إلغاء الـ Timer القديم لو المستخدم لسه بيكتب
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          // إنشاء Timer جديد
          _debounce = Timer(const Duration(milliseconds: 500), () {
            if (query.trim().isNotEmpty) {
              // إرسال حدث البحث للـ Bloc
              context.read<DictionaryBloc>().add(SearchSignsEvent(query));
            } else {
              // لو حقل البحث فاضي، بنرجع نحمل التصنيف المحدد
              context.read<DictionaryBloc>().add(
                LoadSignsEvent(selectedCategory),
              );
            }
          });
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true, // عشان يبدأ من اليمين للشمال زي العربي
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedCategory = category);
                context.read<DictionaryBloc>().add(LoadSignsEvent(category));
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
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : EsharaTheme.primaryBlue,
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

  Widget _buildBlocBuilder() {
    return BlocBuilder<DictionaryBloc, DictionaryState>(
      builder: (context, state) {
        if (state is DictionaryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: EsharaTheme.primaryBlue),
          );
        } else if (state is DictionaryLoaded) {
          if (state.signs.isEmpty) {
            return const Center(child: Text("لا توجد إشارات في هذا التصنيف"));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: state.signs.length,
            itemBuilder: (context, index) {
              final sign = state.signs[index];
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
        return const Center(child: Text("اختر تصنيفاً للبدء"));
      },
    );
  }
}
