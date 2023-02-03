import 'package:flutter/material.dart';

class LikePlayList extends StatefulWidget {
  const LikePlayList({Key? key}) : super(key: key);

  @override
  State<LikePlayList> createState() => _LikePlayListState();
}

class _LikePlayListState extends State<LikePlayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text('관심목록', style: TextStyle(color: Colors.black87, fontSize: 15))
        ),
      ),
    );
  }
}
