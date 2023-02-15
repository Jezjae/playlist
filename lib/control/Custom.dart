import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:playlist/model/MusicItemsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/PlayListModel.dart';

Custom custom = Custom();

class Custom {
  static late SharedPreferences prefs;

  static const FAVORITE = "favorite";

  static List musicData = [];

  Future<List> getMusicJSONData() async {
    var jsonResponse = json.decode(
        await rootBundle.loadString('assets/music/music.json'));
    //Custom.musicData = jsonResponse;
    return jsonResponse;
  }

  Future<List<PlayListModel>> getPlayListModel() async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance
        .collection('playlist');
    List<PlayListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.get();
    //where('Title', isEqualTo: "아이유").get();

    querySnapshot.docs.forEach((element) {
      resultPlayList.add(PlayListModel.fromSnapshot(element));
    });
    return resultPlayList;
  }

  Future<List> getMyMusic(String pLkey) async{

    // var jsonResponse = json.decode(await rootBundle.loadString('assets/music/music.json'));
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    DocumentReference documentReference = playListCollRef.doc('$pLkey');

    DocumentSnapshot documentSnapshot = await documentReference.get();
    //tempList = documentSnapshot.get("MusicList");
    List list = await documentSnapshot.get("MusicList");
    return list;
  }


  void setPlayList(String title, bool fales) async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance
        .collection('playlist');
    DocumentReference documentReference = playListCollRef.doc();

    final json = {
      'Title': title,
      'PlayListKey': documentReference.id,
      'MusicList': [],
      'IsFav': fales,
      'IsHide': fales,
    };
    await documentReference.set(json);
  }

  Future<void> deleteDoc(String docID) async {
    await FirebaseFirestore.instance.collection('playlist').doc(docID).delete();
    //return resultPlayList;

  }

  void updateDocTitle(String docID, String name) {
    FirebaseFirestore.instance.collection('playlist').doc(docID).update({
      'Title': name,
    });
  }

  // void updateDocFav(String docID, bool isfav) {
  //   FirebaseFirestore.instance.collection('playlist').doc(docID).update({
  //     'IsFav': isfav,
  //   });
  // }

  Future<String> updatePlayListFav(String playListKey, bool isFav) async{
    final DocumentReference playListRef = FirebaseFirestore.instance.collection('playlist').doc(playListKey);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      tx.update(playListRef, {'IsFav': isFav});
    });
    return playListKey;
  }

  void updateDocHide(String docID, bool isHide) {
    FirebaseFirestore.instance.collection('playlist').doc(docID).update({
      'IsHide': isHide,
    });
  }


  void updatePlayListAll(String docId, bool isHide) {
    final CollectionReference playListCollRef = FirebaseFirestore.instance
        .collection('playlist');
    DocumentReference documentReference = playListCollRef.doc();
    FirebaseFirestore.instance.collection('playlist').doc(docId).update(
        {'IsHide': isHide,});
  }


  Future<void> songDeleteDoc(String docID) async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance
        .collection('playlist');
    List<PlayListModel> resultPlayList = [];

    await FirebaseFirestore.instance.collection('playlist').doc(docID).update({
      'MusicList': '',
    });
  }

  Future<void> songUpdateDoc(String docID, dynamic addMusic) async {
    await FirebaseFirestore.instance.collection('playlist').doc(docID).update({
      'MusicList': addMusic,
    });
    print("dnjskfa");
    print(addMusic);
  }

}