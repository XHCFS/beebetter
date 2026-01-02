import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/data/database/app_database.dart';
import 'MainPageLogic.dart';
import 'MainPageUI.dart';

class MainPage extends StatefulWidget {
  final AppDatabase db;
  final int userId;
  
  const MainPage({super.key, required this.db, required this.userId});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late MainPageLogic logic;

  @override
  void initState() {
    super.initState();
    logic = MainPageLogic(this, widget.db, widget.userId);
  }

  @override
  void dispose() {
    logic.disposeLogic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: logic,
      child: MainPageUI(),
    );
  }
}
