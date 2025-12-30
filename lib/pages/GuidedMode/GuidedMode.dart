import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeContent.dart';

class GuidedMode extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuidedModeLogic(),
      child: Scaffold(
        body: BackgroundGradient(
          body: GuidedModeContent()
        ),
      ),
    );
  }
}