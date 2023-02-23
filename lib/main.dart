import 'package:flutter/material.dart';
import 'package:team2todolist/calendar.dart';
import 'package:team2todolist/todolist.dart';
import 'package:team2todolist/write.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: Calendar(),
    );
  }
}


