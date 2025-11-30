import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeUI.dart';

class GuidedMode extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuidedModeLogic(),

      child: Scaffold(
        body: BackgroundGradient(
          body:
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // top & horizontal padding
              child: ChangeNotifierProvider(
                create: (_) => GuidedModeLogic(),
                child: GuidedModeUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}