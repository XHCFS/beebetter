import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';
import 'package:beebetter/pages/NewEntryPage/NewEntryPageLogic.dart';
import 'package:beebetter/pages/NewEntryPage/NewEntryPageUI.dart';

class NewEntryPage extends StatelessWidget {
  const NewEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewEntryPageLogic(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BackgroundGradient(
          body:
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // top & horizontal padding
              child: NewEntryPageUI(),
            ),
          ),
        ),
      ),
    );
  }
}
