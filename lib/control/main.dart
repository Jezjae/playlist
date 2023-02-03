import 'package:flutter/material.dart';
import 'package:playlist/control/PlaylistMain.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../model/firebase_options.dart';


void main() async{

  //비동기로 데이터를 다룬다음 runapp할 경우 사용
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

  Widget build(BuildContext context) {
    return const MaterialApp(
        home: PlayList()
    );
  }
}