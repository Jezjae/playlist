import 'package:flutter/material.dart';
import 'package:playlist/control/LikePlayList.dart';
import 'package:playlist/control/MyPlayList.dart';

class PlayList extends StatefulWidget {
  const PlayList({Key? key}) : super(key: key);

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {

  static List<Widget> pages = <Widget>[
    MyPlayLIst(),
    LikePlayList()
  ];

  int _selecIndex = 0;
  void _onTap(int index) {
    setState(() {
      _selecIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selecIndex],
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
