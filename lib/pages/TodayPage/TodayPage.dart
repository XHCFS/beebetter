import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';
import 'package:beebetter/pages/TodayPage/TodayPageLogic.dart';
import 'package:beebetter/pages/TodayPage/TodayPageUI.dart';

class TodayPage extends StatelessWidget {
  final VoidCallback openGuidedMode;
  const TodayPage({super.key, required this.openGuidedMode});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => TodayPageLogic(),
        child: Scaffold(
          body: BackgroundGradient(
            body:
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // top & horizontal padding
                    child: TodayPageUI(openGuidedMode: openGuidedMode),
                  ),
                ),
          ),
        ),
    );
  }
}
