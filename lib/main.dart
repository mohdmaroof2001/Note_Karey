import 'package:flutter/material.dart';
import 'package:me_note/note_dashbord.dart';
import 'package:me_note/sqlite_dphelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DbHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apna Notes',
      theme: ThemeData(

          // primarySwatch: Colors.blue,
          ),
      home: const Note_Dashbord(),
    );
  }
}
