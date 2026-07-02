import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/Widgets/app_bar.dart';
import 'package:eshara/features/Home/UI/Widget/feature_card.dart';
import 'package:eshara/features/Profile/Ui/bloc/profile_bloc.dart';
import 'package:eshara/features/Profile/Ui/bloc/profile_state.dart';
import 'package:eshara/features/SignToText/UI/Screens/sign_to_text_page.dart';
import 'package:eshara/features/Text_to_sign/Ui/Screens/text_to_sign_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';

/// الصفحة الرئيسية للتطبيق (Home Page)
/// تحتوي على رسالة الترحيب والوصول السريع لميزات التطبيق (مثل الترجمة بالكاميرا)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // متحكمات الأنيميشن (Animation) لعمل تأثيرات عند فتح الصفحة
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    // إعداد متحكم الأنيميشن بمدة 600 جزء من الثانية
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // إعداد تأثير الظهور التدريجي (Fade) من الشفافية إلى الظهور الكامل
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    // إعداد تأثير الانزلاق (Slide) بحيث يبدأ المحتوى من الأسفل قليلاً ثم يرتفع لمكانه الطبيعي
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    // تشغيل الأنيميشن بمجرد فتح هذه الصفحة
    _animController.forward();
  }

  @override
  void dispose() {
    // التخلص من متحكم الأنيميشن عند إغلاق الصفحة لتجنب استهلاك الذاكرة (Memory Leaks)
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // جلب تنسيقات النصوص من ثيم التطبيق لتوحيد شكل الخطوط
    final tt = Theme.of(context).textTheme;

    // تم إزالة ويدجت Directionality المكرر من هنا
    // لأن MainPage (الصفحة الأم) توفره بالفعل
    return Scaffold(
      backgroundColor: EsharaTheme.background,
      body: Column(
        children: [
          // استدعاء وبناء شريط التطبيق العلوي (AppBar)
          BuildAppBar(tt: tt),

          // باقي محتوى الصفحة القابل للتمدد
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: _buildBody(tt),
              ),
            ),
          
      )],
        ),
      );
    
  }

  /// دالة بناء محتوى الصفحة الأساسي (الجزء الموجود أسفل الـ AppBar)
  /// يتم وضعه داخل SingleChildScrollView ليصبح قابل للتمرير (Scrollable) إذا كانت الشاشة صغيرة
  Widget _buildBody(TextTheme tt) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 24),
          // استدعاء قسم الترحيب بالمستخدم
          _buildWelcomeSection(tt),
          const SizedBox(height: 24),
          // استدعاء كروت الميزات (ترجمة إشارة لنص، إلخ)
          _buildFeatureCards(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// تصميم بطاقة الترحيب العلوية (Welcome Card)
  Widget _buildWelcomeSection(TextTheme tt) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String displayName = '';

        if (state is ProfileLoadedState) {
          displayName = state.user.name.trim().isNotEmpty
              ? state.user.name
              : '';
        } else if (state is ProfileUpdatedState) {
          displayName = state.user.name.trim().isNotEmpty
              ? state.user.name
              : '';
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: EsharaTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: EsharaTheme.background.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // أيقونة المستخدم (مكان الصورة الشخصية)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  icon: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const Spacer(),
              // نصوص ورسائل الترحيب
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${AppStrings.welcomeMessage} $displayName',
                    style: tt.displayMedium!.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.welcomeSubtitle,
                    style: tt.bodyMedium!.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// قائمة البطاقات التي تمثل الميزات الرئيسية للتطبيق
  Widget _buildFeatureCards() {
    return Column(
      children: [
        // البطاقة الأولى: ترجمة الإشارة إلى نص
        FeatureCard(
          icon: Icons.camera_alt_rounded,
          title: AppStrings.signToText,
          description: AppStrings.signToTextDesc,
          tags: const ['فوري', 'ذكاء اصطناعي'],
          // عند الضغط على هذه البطاقة يتم استدعاء دالة الانتقال للصفحة
          onTap: () => _navigateToSignToText(),
        ),
        const SizedBox(height: 14),
        // البطاقة الثانية: ترجمة النص إلى إشارة
        FeatureCard(
          icon: Icons.text_fields_rounded,
          title: AppStrings.textToSign,
          description: AppStrings.textToSignDesc,
          tags: const ['تفاعلي', 'نشاط يومي'],
          onTap: () =>
              _navigateToTextToSign(), // لم يتم برمجة مسار هذه الشاشة بعد
        ),
      ],
    );
  }

  /// دالة الانتقال (Navigation) إلى صفحة "ترجمة الإشارة إلى نص" عبر الكاميرا
  void _navigateToSignToText() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignToTextPage()),
    );
  }

  //
  void _navigateToTextToSign() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TextToSignPage()),
    );
  }
}
