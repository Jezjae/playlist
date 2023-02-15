import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../model/MusicItemsModel.dart';
import '../service/PlaypopupController.dart';
import 'Custom.dart';



class Music extends StatefulWidget {
  final String pLkey; //데이터 수정을 위한 플리 키값
  const Music({super.key, required this.pLkey});

  @override
  State<Music> createState() => MusicState();
}

late Future<List<dynamic>> playList; //파이어베이스 속 선택한 플리 정보 담을 리스트 선언 (음악아이디만 담길 예정)
List songList = []; //추가할 음악을 담을 리스트
MusicState? parent; //음원리스트 페이지
late AssetsAudioPlayer assetsAudioPlayer; //음악플레이를 위한 선언
PlaypopupController musicController = Get.find(); //get x 사용을 위해 불러오는 작업

//파이어베이스에 속 선택한 플레이 리스트 안에 들어가 있는 음악리스트 가져오기
Future<List> getMyMusic(String pLkey) async{

  // var jsonResponse = json.decode(await rootBundle.loadString('assets/music/music.json'));
  final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
  DocumentReference documentReference = playListCollRef.doc('$pLkey');

  DocumentSnapshot documentSnapshot = await documentReference.get();
  //tempList = documentSnapshot.get("MusicList");
  List list = await documentSnapshot.get("MusicList");
  return list;
}

class MusicState extends State<Music> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    playList = getMyMusic(widget.pLkey); //리스트에 데이터 담아주기 (음악 아이디만 담김)
    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      //앱 상단부
      appBar: AppBar(
        backgroundColor: Colors.white,

        //앱 왼쪽 상단
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.black87,),), //뒤로가기

        //앱 오른쪽 상단
        actions: [IconButton(onPressed: ()async{
          //Get.to(() => musicItems(pLkey: widget.pLkey));
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => musicItems(pLkey: widget.pLkey)), //음악추가 체크박스 페이지로 이동
          );
        }, icon: Icon(Icons.add, color: Colors.black87,))],

        //앱 중간 타이틀
        title: Center(
            child: Text('음원리스트', style: TextStyle(color: Colors.black87, fontSize: 15))
        ),
      ),


      //앱 중단부
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: playList,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      ));
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      ));
                    default:

                      songList = snapshot.data; //이미있는곡정보 담기

                      //선택한 플리속 음원리스트 곡정보 하나씩 리스트에 담아줌
                      List<MusicItemsModel> musicList = [];
                      for(int i = 0; i < snapshot.data.length; i++) //저장한 아이디
                        {
                          for(int j = 0; j < Custom.musicData.length; j++) //전체 곡정보
                            {
                              if(snapshot.data[i] == Custom.musicData[j]['id']) //저장한 아이디와 전체곡정보속 같은 아이디만 찾아 리스트에 담음
                                    {
                                      MusicItemsModel musicItemsModel = MusicItemsModel(isPlay: false);
                                      musicItemsModel.id = Custom.musicData[j]['id'];
                                      musicItemsModel.image  = Custom.musicData[j]['image'];
                                      musicItemsModel.path  = Custom.musicData[j]['path'];
                                      musicItemsModel.title = Custom.musicData[j]['title'];
                                      musicItemsModel.name = Custom.musicData[j]['name'];
                                      musicItemsModel.length = Custom.musicData[j]['length'];
                                      musicItemsModel.isPlay = false;
                                      musicList.add(musicItemsModel); //매칭완료된 곡정보까지 들어간 선택곡 정보리스트
                                    }
                            }
                        }

                      return
                        musicList.length == 0? //선택된 곡 정보 리스트의 유무
                        SizedBox.shrink() //없을때 빈 화면
                            :
                        Container( //있을때 리스트뷰 출력
                          width: 450,
                          height: 675,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                              itemCount: musicList.length, //리스트의 길이만큼
                              itemBuilder: (BuildContext context, int index) {
                                return buildItems(musicList: musicList, index: index, pLkey: widget.pLkey);
                              }),
                        )
                      ;
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}


//담긴 곡 리스뷰로 담을 디자인
class buildItems extends StatefulWidget {
  final String pLkey;
  final List musicList;
  final int index;
  const buildItems({super.key, required this.musicList, required this.index, required this.pLkey});

  @override
  State<buildItems> createState() => _buildItemsState();

}

class _buildItemsState extends State<buildItems> {

  int? tempIndex;
  final inputText = TextEditingController();
  String? setTitle;

  @override

  Widget build(BuildContext context) {
    parent = context.findAncestorStateOfType<MusicState>();

    return Column(
      children: [
        InkWell(
          child: Container(
            width: 450, height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  //앨범표지
                  width: 80, height: 80,
                  child: Image.network(widget.musicList[widget.index].image, width: 100, height: 100, fit: BoxFit.contain,),
                ),
                Container(
                  width: 280, height: 100, padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 115, height: 150, padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              //노래제목
                              padding: const EdgeInsets.all(5.0),
                              child: Text(widget.musicList[widget.index].title),
                            ),
                            Padding(
                              //가수이름
                              padding: const EdgeInsets.all(5.0),
                              child: Text(widget.musicList[widget.index].name),
                            ),
                          ],
                        ),
                      ),


                      //더보기 버튼
                      IconButton(onPressed: (){
                        showDialog(
                          barrierDismissible: true, //빈화면 누르면 취소
                          context: context,
                          builder: (BuildContext context) {
                            //맞춤사이즈
                            double width = MediaQuery.of(context).size.width;
                            double height = MediaQuery.of(context).size.height;
                            return AlertDialog(
                                backgroundColor: Colors.transparent, //뒷배경 어두운 불투명
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
                                          //삭제하기
                                          TextButton(onPressed: (){
                                            tempIndex = widget.index; //삭제할 곡 인덱스

                                            //곡 리스트에서 삭제
                                            for(int i = 0; i < songList.length; i++)
                                              {
                                                if(i == tempIndex)
                                                  {
                                                    songList.removeAt(i);
                                                  }
                                              }

                                            //데이터베이스 수정
                                            Custom().songUpdateDoc(widget.pLkey, songList).then((value) => {
                                              parent?.setState(() {
                                                playList = getMyMusic(widget.pLkey);
                                              }),
                                            Navigator.of(context).pop(),//뒤로가기
                                            });
                                          },
                                              child: Text('플레이리스트에서 삭제하기', style: TextStyle(color: Colors.red, fontSize: 20),)),

                                          Divider(),

                                          TextButton(onPressed: (){Navigator.of(context).pop();}, //뒤로가기
                                              child: Text('취소', style: TextStyle(fontSize: 20)))
                                        ],
                                      ),
                                    ),
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
          onTap: ()async => {
            assetsAudioPlayer.open(
          Audio(widget.musicList[widget.index].path),
          showNotification: true,
              notificationSettings: NotificationSettings(
                customStopIcon: AndroidResDrawable(name: "ic_stop_custom"),
                customPauseIcon: AndroidResDrawable(name:"ic_pause_custom"),
                customPlayIcon: AndroidResDrawable(name:"ic_play_custom"),
                customPrevIcon: AndroidResDrawable(name:"ic_prev_custom"),
                customNextIcon: AndroidResDrawable(name:"ic_next_custom"),
              ),

          autoStart: true)}
        ),
        Divider(
          color: Colors.black.withOpacity(0.2),
          thickness: 1.0,
        )
      ],
    );
  }
}



//음원추가 페이지
class musicItems extends StatefulWidget {
  final String pLkey;
  const musicItems({super.key, required this.pLkey});

  @override
  State<musicItems> createState() => musicItemsState();
}

class musicItemsState extends State<musicItems> {


  @override
  Widget build(BuildContext context) {
    // MusicState? parent = context.findAncestorStateOfType<MusicState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.black87,),),
        title: Center(
            child: Text('음원 추가', style: TextStyle(color: Colors.black87, fontSize: 15))
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: Custom().getMusicJSONData(), //전체 곡정보 불러오기기
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                 switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      ));
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                      ));
                    default:
                      return
                      //스냅샷 길이 유무
                        snapshot.data.length == 0?
                        SizedBox.shrink() //없으면 빈화면
                            :
                        Column( //있으면 리스트뷰 만들기
                          children: [
                            Container(
                              width: 450,
                              height: 700,
                              padding: const EdgeInsets.all(20),
                              child: buildItemList(snapshot: snapshot),
                      ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextButton(onPressed: (){
                                //데이터 업데이트 후 뒤로가기
                                Custom().songUpdateDoc(widget.pLkey, songList).then((value) => {
                                  parent?.setState(() {
                                  playList = getMyMusic(widget.pLkey);
                                  Navigator.of(context).pop();
                                  }),
                                });
                              }, child: Text('플레이리스트에 추가하기')),
                            )
                          ],
                        );
                      ;
                  }
                }
            ),
          ],
        ),
      ),
    );
  }


  //전체음원리스트 아이템 하나씩 넣기
  ListView buildItemList({required AsyncSnapshot<dynamic> snapshot}) {
    return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              makeMusicList(snapshot: snapshot, index: index),
            ],
          );
        });
  }
}



//음원 체크박스 하나하나 디자인
class makeMusicList extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;
  const makeMusicList({super.key, required this.snapshot, required this.index});

  @override
  State<makeMusicList> createState() => _makeMusicListState();
}

class _makeMusicListState extends State<makeMusicList> {
  @override

  bool isChecked = false;

  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Container(
            width: 450, height: 150,
            child: Row(
              children: [
                //앨범 표지
                Image.network(widget.snapshot.data[widget.index]["image"], width: 100, height: 100, fit: BoxFit.contain,),
                Container(
                  width: 190, height: 150, padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        //노래 제목
                        padding: const EdgeInsets.all(5.0),
                        child: Text(widget.snapshot.data[widget.index]["title"]),
                      ),
                      Padding(
                        //가수 이름
                        padding: const EdgeInsets.all(5.0),
                        child: Text(widget.snapshot.data[widget.index]["name"]),
                      ),
                    ],
                  ),
                ),

                //체크박스
                Checkbox(
                    value: isChecked,
                    onChanged: (value){
                      if(value == true){
                        //음악추가
                        dynamic addMusic = widget.snapshot.data[widget.index]["id"];
                        songList.add(addMusic);
                      }
                      else
                        {
                          //음악 삭제
                          dynamic addMusic = widget.snapshot.data[widget.index]["id"];
                          songList.remove(addMusic);
                        }
                  setState(() {
                    isChecked = value!;
                  });
                })
              ],
            ),
          ),
          onTap: (){
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => DetailedImagePage (snapshot: widget.snapshot, index: widget.index)),
            // );
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
