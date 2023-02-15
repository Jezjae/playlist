import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../model/MusicItemsModel.dart';



class PlaypopupController{

  RxBool isPlay = RxBool(false);
  RxList<MusicItemsModel> popupPlayList = RxList<MusicItemsModel>();


  set setisPlay(bool value){
    isPlay(value);
  }

  set setPopupPlayListListModel(List<MusicItemsModel> value){
    popupPlayList(value);
  }


  // void updatePlayModel(PlayListModel value, int index){
  //   playList[index] = value;
  // }

  // void updatepopupPlayList(List<MusicItemsModel> value){
  //   popupPlayList(value);
  // }

  void updatePlaybool(bool isplay){
    isPlay(isplay);
  }
}