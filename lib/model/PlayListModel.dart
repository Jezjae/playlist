import 'package:cloud_firestore/cloud_firestore.dart';

class PlayListModel {

  String? playListKey;
  String? title;
  String? musicList;

  PlayListModel(
  {
    this.playListKey,
    this.title,
    this.musicList,


}
      );


  PlayListModel.fromMap(Map<String, dynamic> map)
      : playListKey = map['PlayListKey'],
        title = map['Title'],
        musicList = map['MusicList'];

  PlayListModel.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data() as Map<String, dynamic>);


  Map<String, dynamic> toMap(){
    final map = <String,dynamic>{};
    map['PlayListKey'] = playListKey;
    map['Title'] = title;
    map['MusicList'] = musicList;
    return map;
  }
}