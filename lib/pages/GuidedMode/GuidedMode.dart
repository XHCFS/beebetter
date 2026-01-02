import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeLogic.dart';
import 'package:beebetter/pages/GuidedMode/GuidedModeContent.dart';
import 'package:beebetter/data/database/app_database.dart';

class GuidedMode extends StatelessWidget{
  final AppDatabase db;
  final int userId;
  
  const GuidedMode({super.key, required this.db, required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GuidedModeLogic(db, userId),
      child: Scaffold(
        body: BackgroundGradient(
          body: GuidedModeContent()
        ),
      ),
    );
  }
}