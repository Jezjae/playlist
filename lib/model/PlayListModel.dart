import 'package:cloud_firestore/cloud_firestore.dart';

class PlayListModel {

  String? playListKey;
  String? title;
  dynamic? musicList;
  bool isFav = false;
  bool isHide = false;

  PlayListModel(
  {
    this.playListKey,
    this.title,
    this.musicList,
    required this.isFav,
    required this.isHide,
  }
  );


  PlayListModel.fromMap(Map<dynamic, dynamic> map)
      : playListKey = map['PlayListKey'],
        title = map['Title'],
        musicList = map['MusicList'],
        isFav = map['IsFav'],
        isHide = map['IsHide']
  ;

  PlayListModel.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data() as Map<dynamic, dynamic>);


  Map<dynamic, dynamic> toMap(){
    final map = <dynamic,dynamic>{};
    map['PlayListKey'] = playListKey;
    map['Title'] = title;
    map['MusicList'] = musicList;
    map['IsFav'] = isFav;
    map['IsHide'] = isHide;
    return map;
  }

}