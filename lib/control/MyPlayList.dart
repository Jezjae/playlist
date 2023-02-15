import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../model/MusicItemsModel.dart';
import '../model/PlayListModel.dart';
import '../service/PlayListController.dart';
import '../service/PlaypopupController.dart';
import 'Custom.dart';
import 'Music.dart';



class MyPlayLIst extends StatefulWidget {
  const MyPlayLIst({Key? key}) : super(key: key);

  @override
  State<MyPlayLIst> createState() => MyPlayLIstState();
}

//파이어베이스 스토어에 있는 데이터 담아주는 곳
late Future<List<PlayListModel>> playList;

//숨긴 플리의 데이터 키 값 저장하는 것 (숨기고 불러오기 위해서)
List<String> tempId = [];

//입력창 텍스트 컨트롤러
final inputText = TextEditingController();

//입력된 텍스트 저장할 스트링
String? setTitle;

//음악플레이를 위한 선언
late AssetsAudioPlayer assetsAudioPlayer;

class MyPlayLIstState extends State<MyPlayLIst> {

  //get x 사용을 위해 불러오는 작업
  PlayListController playListController = Get.find();

  //숨김이 아닌 플리 데이터 가져오기
  Future<List<PlayListModel>> getPlayListModel() async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    List<PlayListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.where('IsHide', isEqualTo: false).get();

    querySnapshot.docs.forEach((element) {
      resultPlayList.add(PlayListModel.fromSnapshot(element));
    });
    return resultPlayList;
  }

  //숨김 플리 데이터 가져오기
  Future<List<PlayListModel>> getHidePlayListModel() async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    List<PlayListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.where('IsHide', isEqualTo: true).get();

    querySnapshot.docs.forEach((element) {
      resultPlayList.add(PlayListModel.fromSnapshot(element));
    });
    return resultPlayList;
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();

    //만들어지기 전에 리스트에 첫화면에 띄울 데이터 넣어주기
    playList = getPlayListModel();
    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //앱 상단
      appBar: AppBar(
        backgroundColor: Colors.white,

        //왼쪽 상단 아이콘버튼 (숨김리스트 전체 불러오기)
        leading: IconButton(onPressed: (){
          showDialog(context: context,
              barrierDismissible: true,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('숨김 플레이리스트 불러오기'),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();

                      for (int i = 0; i < tempId.length; i++)
                      {
                        //숨김 풀기
                        custom.updatePlayListAll(tempId[i],false);
                      }

                      setState(() {
                        tempId = []; //저장된 아이디 리스트 초기화
                        playList = getPlayListModel();
                      });
                    }, child: Text('불러오기'))
                  ],
                );
              });
        }, icon: Icon(Icons.more_vert, color: Colors.black87,)),

        //상단 가운데 텍스트
        title: Center(child: Text('플레이리스트', style: TextStyle(color: Colors.black87, fontSize: 15))),

        //오른쪽 상단 아이콘버튼 (새 플레이리스트 추가)
        actions: [IconButton(onPressed: (){
          showDialog(context: context,
              barrierDismissible: true,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('플레이리스트 이름을 입력하세요'),
                  content: Container(
                    width: 200, height: 70, padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: inputText,
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: (){
                      setTitle = inputText.text;

                      //이름빈칸예외처리
                      if(setTitle == '') { }
                      else
                        {
                          //정한 이름 데이터베이스에 넣고 초기화
                          Custom().setPlayList(setTitle!, false);
                          inputText.text = '';
                          setState(() {
                            playList = getPlayListModel();
                          });
                          Navigator.of(context).pop();
                        }
                    }, child: Text('확인'))
                  ],
                );
              });
        }, icon: Icon(Icons.add, color: Colors.black87,))],
      ),



      //앱 중단
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: playList,
                //파이어베이스 데이터를 담아준 리스트

                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {

                    case ConnectionState.none:
                          return Center(child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ));
                  //스냅샷 정보가 없으면 빨강 동그라미

                  case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ));
                  //스냅샷 정보를 불러오는 중이면 빨강 동그라미

                    default:
                      //다 불러오면 상태변화할 데이터의 주소에 스냅샷 데이터 넣기
                      playListController.setPlayListModel = snapshot.data;

                      return
                        snapshot.data.length == 0? //스냅샷 데이터가 없을때와 있을때

                        //없을때 = 플레이리스트 만들라고 한다
                        Center(
                            child: Container(
                              width: 400, height: 400, padding: EdgeInsets.fromLTRB(0, 225, 0, 0),
                              child: Column(
                                children: [
                                  Text('플레이리스트 이름을 입력하세요.'),
                                  Container(
                                    width: 250, height: 70, padding: EdgeInsets.all(10),
                                    child: TextField(
                                      controller: inputText,
                              ),
                            ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                      child: TextButton(onPressed: (){
                                        setTitle = inputText.text;

                                        //이름빈칸예외처리
                                        if(setTitle == '') { }
                                        else
                                        {
                                          //정한 이름 데이터베이스에 넣고 초기화
                                          Custom().setPlayList(setTitle!, false);
                                          inputText.text = '';
                                          setState(() {
                                            playList = getPlayListModel();
                                          });
                                          setState(() {});
                                        }
                                        },
                                          child: Text('확인'))
                            ),
                          )

                          ],
                        ),
                            )) :


                        //있을때
                        Column(
                          children: [


                            //젤 위에 새 리스트 만들기 버튼
                            InkWell(
                              child: Container(
                                width: 400, height: 100, padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 80, height: 80, padding: EdgeInsets.all(10),
                                      child: Icon(Icons.add, color: Colors.deepPurple,),
                                    ),
                                    Container(
                                        width: 260, height: 100, padding: EdgeInsets.fromLTRB(8, 33, 0, 0),
                                        child: Text('새 플레이리스트 만들기', style: TextStyle(fontSize: 15),)),
                                  ],
                                ),
                              ),
                              onTap: (){
                                showDialog(context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('플레이리스트 이름을 입력하세요'),
                                    content: Container(
                                      width: 200, height: 70, padding: EdgeInsets.all(10),
                                      child: TextField(
                                        controller: inputText,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: (){
                                        setTitle = inputText.text;

                                        //이름빈칸예외처리
                                        if(setTitle == '') { }
                                        else
                                        {
                                          //정한 이름 데이터베이스에 넣고 초기화
                                          Custom().setPlayList(setTitle!, false);
                                          inputText.text = '';
                                          setState(() {
                                            playList = getPlayListModel();
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      }, child: Text('확인'))
                                    ],
                                  );
                                    });
                              },
                            ),
                            Divider(
                                color: Colors.black.withOpacity(0.2), thickness: 1.0),

                            //리스트뷰 만들기
                            Container(
                              width: 450,
                              height: 675,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return
                                      Items(snapshot: snapshot, index: index); //하나하나 담을 형식
                                  }),
                            ),

                          ],
                        );
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}


// 아이템 하나하나 디자인?
class Items extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;
  const Items({super.key, required this.snapshot, required this.index});

  @override
  State<Items> createState() => _ItemsState();

}
late Future<List<dynamic>> myPlayList;
String? pLkey; //각 아이템당 데이터 키 값 저장할 스트링 (파라미터로 옮겨줘야 해서...)

class _ItemsState extends State<Items> {

  bool _play = false;

  //get x 사용을 위해 불러오는 작업
  PlayListController playListController = Get.find();

  Future<List<PlayListModel>> getPlayListModel() async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    List<PlayListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.where('IsHide', isEqualTo: false).get();

    querySnapshot.docs.forEach((element) {
      resultPlayList.add(PlayListModel.fromSnapshot(element));
    });
    return resultPlayList;
  } //파이어베이스의 데이터 불러오기

  //텍스트 입력창을 위한 세팅
  final inputText = TextEditingController();
  String? setTitle;

  //final bool isPlaying = assetsAudioPlayer.isPlaying.value;

  //플레이리스트 전체 재생 패스를 담을 리스트
  // List<String> playlistItemsPath = [];
  //

  List<MusicItemsModel> playlistItems() {
    List<MusicItemsModel> playlistItems = [];
    for(int i = 0; i < widget.snapshot.data[widget.index].musicList.length; i++)
    {
      for(int j = 0; j < Custom.musicData.length; j++)
      {
        if(Custom.musicData[j].id == widget.snapshot.data[widget.index].musicList[i])
        {
          MusicItemsModel musicItemsModel = MusicItemsModel(isPlay: false);
          musicItemsModel.id = Custom.musicData[j]['id'];
          musicItemsModel.image  = Custom.musicData[j]['image'];
          musicItemsModel.path  = Custom.musicData[j]['path'];
          musicItemsModel.title = Custom.musicData[j]['title'];
          musicItemsModel.name = Custom.musicData[j]['name'];
          musicItemsModel.length = Custom.musicData[j]['length'];
          musicItemsModel.isPlay = false;

          //매칭완료된 곡정보까지 들어간 선택곡 정보리스트
          playlistItems.add(musicItemsModel);
        }
      }
    }
    return playlistItems;
  }

  //get x 사용을 위해 불러오는 작업
  PlaypopupController playpopupController = Get.find();

  @override


  Widget build(BuildContext context) {
    MyPlayLIstState? parent = context.findAncestorStateOfType<MyPlayLIstState>();
    return Column(
      children: [
        InkWell(
          child: Container(
            width: 430, height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 80, height: 80, 
                  child: Image.asset('assets/bom.png'), //플레이리스트 기본 표지
                ),
                Container(
                  width: 270, height: 100, padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100, height: 100, padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                          child: Text(widget.snapshot.data[widget.index].title, style: TextStyle(fontSize: 15),)), //플레이리스트 이름


                      //여기에 플레이, 스탑 버튼 들어가야함
                      Obx(()=> playpopupController.isPlay.value?
                          IconButton(onPressed: (){
                            playpopupController.updatePlaybool(false);
                            playpopupController.isPlay.refresh();
                            assetsAudioPlayer.pause();

                          }, icon: Icon(Icons.pause))
                      :
                      IconButton(
                          onPressed: () async{
                            List<MusicItemsModel> playlistItemsPath = playlistItems();
                            playpopupController.updatePlaybool(true);

                            assetsAudioPlayer.open(
                                Playlist(
                                    audios: [
                                      for(int i =0;i<playlistItemsPath.length;i++)
                                        Audio('$playlistItemsPath[i].path'),
                                    ]
                                ),
                                loopMode: LoopMode.playlist //loop the full playlist
                            );

                            //assetsAudioPlayer.playlistPlayAtIndex(i);

                            playpopupController.isPlay.refresh();
                          },
                          icon: Icon(Icons.play_arrow),
                        ),
                      ),



                      //플레이리스트 좋아요 눌러져있나? 아닌가?
                      Obx(() => playListController.playList.value![widget.index].isFav?

                      //눌러져 있음
                      IconButton(onPressed: (){
                        //데이터베이스에서 데이터 수정 후 데이터담은 리스트에서 수정하고 이 아이콘만 새로고침?
                        custom.updatePlayListFav(widget.snapshot.data[widget.index].playListKey, false).then((value) => {
                          playListController.updateFavPlayModel(widget.index, false),
                          playListController.playList.refresh(),});
                      }, icon: Icon(Icons.favorite, color: Colors.red,))
                          : IconButton(onPressed: () {
                            custom.updatePlayListFav(widget.snapshot.data[widget.index].playListKey, true).then((value) => {
                              playListController.updateFavPlayModel(widget.index, true), 
                              playListController.playList.refresh(),});
                            }, icon: Icon(Icons.favorite_border, color: Colors.grey,),)),

                      //더보기 아이콘 (숨기기, 제목 수정하기, 삭제하기, 취소)
                      IconButton(onPressed: (){
                        showDialog(
                          barrierDismissible: true, //외부터치시 팝업 사라짐
                          context: context,
                          builder: (BuildContext context) {
                            //맞춤사이즈
                            double width = MediaQuery.of(context).size.width;
                            double height = MediaQuery.of(context).size.height;
                            return AlertDialog(
                                backgroundColor: Colors.transparent, //주변 화면 어둡게
                                contentPadding: EdgeInsets.zero,
                                elevation: 0.0,
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.end, //밑에서부터 정렬
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10.0))),
                                      child: Column(
                                        children: [
                                          //숨기기 버튼
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop(); //뒤로가기
                                            custom.updateDocHide(widget.snapshot.data[widget.index].playListKey, true); //데이터베이스에 업데이트
                                            tempId?.add(widget.snapshot.data[widget.index].playListKey); //다시 불러오기 위한 id저장
                                            parent?.setState(() {
                                              playList = getPlayListModel(); //플리데이터와 플리리스트 동기화
                                            });
                                          }, child: Text('숨기기', style: TextStyle(fontSize: 20),)),

                                          Divider(), //구분선

                                          //플리 이름 수정
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop(); //뒤로가기
                                            showDialog(context: context,
                                                barrierDismissible: true,//화면 빈공간 누르면 취소
                                                builder: (BuildContext context){
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,

                                                    title: Text('플레이리스트 이름을 입력하세요'),
                                                    content: Container(
                                                      width: 200, height: 70, padding: EdgeInsets.all(10),
                                                      child: TextField(
                                                        controller: inputText,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(onPressed: (){
                                                        setTitle = inputText.text;

                                                        //이름빈칸예외처리
                                                        if(setTitle == '') { }
                                                        else
                                                        {
                                                          //정한 이름 데이터베이스에 넣고 초기화
                                                          Custom().updateDocTitle(widget.snapshot.data[widget.index].playListKey, '$setTitle');
                                                          inputText.text = '';
                                                          parent?.setState(() {
                                                            playList = getPlayListModel();
                                                          });
                                                          Navigator.of(context).pop();
                                                        }
                                                      }, child: Text('확인'))
                                                    ],
                                                  );
                                                });
                                          }, child: Text('수정하기', style: TextStyle(fontSize: 20))),

                                          Divider(),

                                          //플리 삭제하기
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop(); //뒤로가기

                                            //데이터베이스에서 삭제후 리스트 동기화
                                            Custom().deleteDoc(widget.snapshot.data[widget.index].playListKey).then((value) =>
                                            {
                                            parent?.setState(() {
                                            playList = getPlayListModel();
                                            })
                                            });

                                          },
                                              child: Text('삭제하기', style: TextStyle(color: Colors.red, fontSize: 20),)),
                                        ],
                                      ),
                                    ),

                                    SizedBox( //빈공간 띄우기
                                      height: 10,
                                    ),

                                    //취소
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10.0))),
                                      child: Center(child: TextButton(onPressed: (){Navigator.of(context).pop();}, //뒤로가기
                                          child: Text('취소', style: TextStyle(fontSize: 20))),),
                                    )
                                  ],
                                ));
                          },
                        );
                      }, icon: Icon(Icons.more_horiz, color: Colors.grey))
                    ],
                  ),
                ),
              ],
            ),
          ),

          onTap: () async{
            pLkey = widget.snapshot.data[widget.index].playListKey;
            Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
                Music( pLkey: pLkey!)),
             );
          },
        ),
        Divider(
          color: Colors.black.withOpacity(0.2),
          thickness: 1.0,
        )
      ],
    );
  }

}



