import 'package:eshara/features/Pages/UI/introdcation/Screens/introdaction_screan_1.dart';
import 'package:eshara/features/Pages/UI/introdcation/Screens/introdaction_screan_2.dart';
import 'package:eshara/features/Pages/UI/introdcation/Screens/introdaction_screan_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  State<Onbording> createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  // PageController to manage the PageView
  // final int _currentPage = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                IntrodactionScrean1(),
                IntrodactionScrean2(),
                IntrodactionScrean3(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ScrollingDotsEffect(
                dotHeight: 12,
                dotWidth: 12,
                spacing: 8,
                dotColor: Colors.grey,
                activeDotColor: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
