import 'package:flutter/material.dart';
import 'package:beebetter/widgets/BackgroundGradient.dart';

class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
      body: Center(child: Text('Dashboard', style: TextStyle(fontSize: 24))),
    );
  }
}
