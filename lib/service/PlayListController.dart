import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../model/PlayListModel.dart';



class PlayListController{

  RxList<PlayListModel> playList = RxList<PlayListModel>();

  set setPlayListModel(List<PlayListModel> value){
    playList(value);
  }

  // void updatePlayModel(PlayListModel value, int index){
  //   playList[index] = value;
  // }

  void updateFavPlayModel(int index, bool isFav){
    playList[index].isFav = isFav;

  }
}