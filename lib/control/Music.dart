import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playlist/control/PlaylistMain.dart';
import 'package:playlist/model/PlayListModel.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}



class _MusicState extends State<Music> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.black87,),),
        actions: [IconButton(onPressed: ()async{
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => musicItems()),
          );

        }, icon: Icon(Icons.add, color: Colors.black87,))],
        title: Center(
            child: Text('음원리스트', style: TextStyle(color: Colors.black87, fontSize: 15))
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // FutureBuilder(
            //     future: getPlayListModel(),
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       switch (snapshot.connectionState) {
            //         case ConnectionState.none:
            //           return Center(child: CircularProgressIndicator(
            //             valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            //           ));
            //         case ConnectionState.waiting:
            //           return Center(child: CircularProgressIndicator(
            //             valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
            //           ));
            //         default:
            //           return
            //             musicList.length == 0?
            //             SizedBox.shrink():
            //             Container(
            //               width: 450,
            //               height: 675,
            //               padding: const EdgeInsets.only(left: 10, right: 10),
            //               child: ListView.builder(
            //                   itemCount: snapshot.data.length,
            //                   itemBuilder: (BuildContext context, int index) {
            //                     return Items(snapshot: snapshot, index: index);
            //                   }),
            //             )
            //           ;
            //       }
            //     }
            // ),
          ],
        ),
      ),
    );
  }
}

class musicItems extends StatefulWidget {
  const musicItems({Key? key}) : super(key: key);

  @override
  State<musicItems> createState() => _musicItemsState();
}

class _musicItemsState extends State<musicItems> {

  Future<List> getMusicJSONData() async {
    var jsonResponse = json.decode(await rootBundle.loadString('assets/music/music.json'));

    return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
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
                future: getMusicJSONData(),
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
                        snapshot.data.length == 0?
                        SizedBox.shrink():
                        Column(
                          children: [
                            Container(
                              width: 450,
                              height: 700,
                              padding: const EdgeInsets.all(20),
                              child: buildItemList(snapshot: snapshot),
                      ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextButton(onPressed: (){}, child: Text('플레이리스트에 추가하기')),
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
                Image.network(widget.snapshot.data[widget.index]["image"], width: 100, height: 100, fit: BoxFit.contain,),
                Container(
                  width: 190, height: 150, padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(widget.snapshot.data[widget.index]["title"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(widget.snapshot.data[widget.index]["name"]),
                      ),
                    ],
                  ),
                ),


                Checkbox(
                    value: isChecked,
                    onChanged: (value){
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
