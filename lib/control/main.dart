import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:playlist/control/PlaylistMain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:playlist/service/PlaypopupController.dart';
import '../firebase_options.dart';
import '../service/PlayListController.dart';
import 'Custom.dart';

void main() async{

  //비동기로 데이터를 다룬다음 runapp할 경우 사용
  WidgetsFlutterBinding.ensureInitialized();

  //파이어베이스 연결
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //getx setup
  Get.put(PlayListController(), permanent:true);
  Get.put(PlaypopupController(), permanent:true);

  //음악정보 리스트에 담아주기
  Custom.musicData = await Custom().getMusicJSONData();

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
    return const GetMaterialApp(
        home: PlayList()
    );
  }
}