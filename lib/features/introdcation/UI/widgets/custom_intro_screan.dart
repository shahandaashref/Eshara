import 'package:eshara/features/introdcation/UI/widgets/custom_background_intro_screan.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomIntroScrean extends StatefulWidget {
  final String title;
  final String content;
  final String introImageInStack;
  final bool isFirstIntroScrean;
  final Function onPressed;
  const CustomIntroScrean({
    super.key,
    required this.title,
    required this.content,
    required this.introImageInStack,
    this.isFirstIntroScrean = false,
    required this.onPressed,
  });

  @override
  State<CustomIntroScrean> createState() => _CustomIntroScreanState();
}

class _CustomIntroScreanState extends State<CustomIntroScrean> {
  int selectedIndex = 0;
  final List<String> buttonNames = ['التالي', 'السابق'];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          child: CustomBackgroundIntroScrean(image: widget.introImageInStack),
        ),
        Gap(10),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(widget.title, style: theme.textTheme.displayLarge),
              Text(widget.content, style: theme.textTheme.displayMedium),
            ],
          ),
        ),
        Gap(20),
        bottomsintroscreans(),
      ],
    );
  }

  Row bottomsintroscreans() {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedIndex = 0;

            });
            widget.onPressed;

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIndex == 0
                ? theme.colorScheme.primary
                : Colors.white,
            foregroundColor: selectedIndex == 0
                ? Colors.white
                : theme.colorScheme.primary,
          ),
          child: Text('التالي'),
        ),

        SizedBox(width: 30), 

        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedIndex = 1;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIndex == 1
                ? theme.colorScheme.primary
                : Colors.white,
            foregroundColor: selectedIndex == 1
                ? Colors.white
                : theme.colorScheme.primary,
          ),
          child: Text(widget.isFirstIntroScrean ? 'تخطي' : 'السابق'),
        ),
      ],
    );
  }
}

//===================================================//
//==================================================//
