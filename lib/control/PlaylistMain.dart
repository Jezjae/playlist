import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist/control/LikePlayList.dart';
import 'package:playlist/control/MyPlayList.dart';

import '../service/PlaypopupController.dart';

class PlayList extends StatefulWidget {
  const PlayList({Key? key}) : super(key: key);

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {

  //페이지 이동하기 위한 리스트에 위젯으로 페이지 넣어주기
  static List<Widget> pages = <Widget>[
    MyPlayLIst(),
    LikePlayList()
  ];

  //페이지 선택 리스트 인덱스
  int _selecIndex = 0;

  //누르면 셋스테이지 해서 페이지 창 바꾸기
  void _onTap(int index) {
    setState(() {
      _selecIndex = index;
    });
  }

  //get x 사용을 위해 불러오는 작업
  PlaypopupController playpopupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [

          pages[_selecIndex],

            Obx(()=> playpopupController.isPlay.value?


            Positioned(
                  bottom: 10, left: 10, right: 10,
                  child: Container(
                    alignment: Alignment.center,
                    width: 360, height: 80,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.deepPurple[100],),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            //앨범표지
                            width: 70, height: 70, padding: EdgeInsets.all(5),
                            child: Image.asset('assets/bom.png'),
                          ),
                          Container(
                            width: 102, height: 65, padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  //노래제목
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('노래제목', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                ),
                                Padding(
                                  //가수이름
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text('가수이름'),
                                ),
                              ],
                            ),
                          ),
                          IconButton(onPressed: (){}, icon: Icon(Icons.skip_previous, size: 35),padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow, size: 35,),padding: EdgeInsets.fromLTRB(0, 0, 0, 1),),
                          IconButton(onPressed: (){}, icon: Icon(Icons.skip_next, size: 35),padding: EdgeInsets.fromLTRB(0, 0, 0, 0),),
                          IconButton(onPressed: (){}, icon: Icon(Icons.repeat,),padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                        ],
                      ),
                        Container(
                          //재생바
                          width: 350,height: 5, //color: Colors.deepPurple,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.deepPurple,),
                        )
                      ],
                    ),
                  ))
                :
                SizedBox.shrink()
            ),
          ]),
      // 페이지 보드



      //하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selecIndex,
          onTap: _onTap,
          selectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.queue_music, color: Colors.black87,), label: '플레이리스트'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Colors.black87,), label: '관심목록'),
          ]
      ),
    );
  }
}
