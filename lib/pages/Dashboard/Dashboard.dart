import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beebetter/pages/Dashboard/DashboardUI.dart';
import 'package:beebetter/pages/Dashboard/DashboardLogic.dart';

class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardLogic(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0), // top & horizontal padding
            child: DashboardUI(),
          ),
        ),
      ),
    );
  }
}