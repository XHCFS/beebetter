import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainPageLogic.dart';
import 'MainPageUI.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late MainPageLogic logic;

  @override
  void initState() {
    super.initState();
    logic = MainPageLogic(this);
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
