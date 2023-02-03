import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/PlayListModel.dart';
import 'Music.dart';

class MyPlayLIst extends StatefulWidget {
  const MyPlayLIst({Key? key}) : super(key: key);

  @override
  State<MyPlayLIst> createState() => _MyPlayLIstState();
}

final inputText = TextEditingController();
String? setTitle;

class _MyPlayLIstState extends State<MyPlayLIst> {

  Future<List<PlayListModel>> getPlayListModel() async {
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    List<PlayListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.get();
    //where('Title', isEqualTo: "아이유").get();

    querySnapshot.docs.forEach((element) {
      resultPlayList.add(PlayListModel.fromSnapshot(element));
    });
    return resultPlayList;
  }



  void setPlayList(String title, list) async{
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    DocumentReference documentReference = playListCollRef.doc();

    final json = {
      'Title': title,
      'PlayListKey': documentReference.id,
      'MusicList': list
    };
    await documentReference.set(json);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('플레이리스트', style: TextStyle(color: Colors.black87, fontSize: 15)),

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

                      //정한 이름 데이터베이스에 넣고 초기화
                      setPlayList(setTitle!, null);
                      inputText.text = '';
                      setState(() {});

                      Navigator.of(context).pop();
                    }, child: Text('확인'))
                  ],
                );
              });
        }, icon: Icon(Icons.add, color: Colors.black87,))],
      ),





      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getPlayListModel(),
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

                                        //정한 이름 데이터베이스에 넣고 초기화
                                        setPlayList(setTitle!, null);
                                        inputText.text = '';
                                        setState(() {});

                                        },
                                          child: Text('확인'))
                            ),
                          )

                          ],
                        ),
                            )) :
                        Column(
                          children: [
                            InkWell(
                              child: Container(
                                width: 400, height: 100, padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 80, height: 80, padding: EdgeInsets.all(10), color: Colors.grey,
                                      child: Icon(Icons.add, color: Colors.pinkAccent,),
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

                                        //정한 이름 데이터베이스에 넣고 초기화
                                        setPlayList(setTitle!, null);
                                        inputText.text = '';
                                        setState(() {});

                                        Navigator.of(context).pop();
                                      }, child: Text('확인'))
                                    ],
                                  );
                                    });
                              },
                            ),
                            Divider(
                                color: Colors.black.withOpacity(0.2), thickness: 1.0),
                            Container(
                              width: 450,
                              height: 675,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Items(snapshot: snapshot, index: index);
                                  }),
                            ),
                          ],
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



class Items extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;
  const Items({super.key, required this.snapshot, required this.index});

  @override
  State<Items> createState() => _ItemsState();

}

class _ItemsState extends State<Items> {

  bool isColor = false;

  final inputText = TextEditingController();
  String? setTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Container(
            width: 400, height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  //앨범표지
                  width: 80, height: 80, 
                  child: Image.asset('assets/bom.png'),
                ),
                Container(
                  width: 260, height: 100, padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140, height: 100, padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
                          child: Text(widget.snapshot.data[widget.index].title, style: TextStyle(fontSize: 15),)),
                      isColor?
                      IconButton(onPressed: (){
                        isColor = false;
                        // 관심목록 삭제

                        setState(() {});
                      }, icon: Icon(Icons.favorite, color: Colors.red,))
                          : IconButton(onPressed: (){
                        isColor = true;

                        setState(() {});
                      }, icon: Icon(Icons.favorite_border, color: Colors.grey,)),
                      IconButton(onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            double width = MediaQuery.of(context).size.width;
                            double height = MediaQuery.of(context).size.height;
                            return AlertDialog(
                                backgroundColor: Colors.transparent,
                                contentPadding: EdgeInsets.zero,
                                elevation: 0.0,
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10.0))),
                                      child: Column(
                                        children: [
                                          TextButton(onPressed: (){}, child: Text('숨기기', style: TextStyle(fontSize: 20),)),
                                          Divider(),
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop();
                                            showDialog(context: context,
                                                barrierDismissible: true,
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

                                                        //정한 이름 데이터베이스에 넣고 초기화
                                                        updateDoc(widget.snapshot.data[widget.index].playListKey, '$setTitle');
                                                        inputText.text = '';

                                                        //여기도 다시 초기화가 안됨.. 왜죠?
                                                        setState(() {});

                                                        Navigator.of(context).pop();
                                                      }, child: Text('확인'))
                                                    ],
                                                  );
                                                });
                                          }, child: Text('제목 수정하기', style: TextStyle(fontSize: 20))),
                                          Divider(),
                                          TextButton(onPressed: (){
                                            Navigator.of(context).pop();
                                            print("nkjlsf");
                                            deleteDoc(widget.snapshot.data[widget.index].playListKey).then((value) =>
                                            {
                                            //print("nkjlsf22");
                                            setState(() {})

                                            });

                                            // //시점에 문제가 있는건지 셋스테이트 왜 안되는 거임?
                                          },
                                              child: Text('삭제하기', style: TextStyle(color: Colors.red, fontSize: 20),)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10.0))),
                                      child: Center(child: TextButton(onPressed: (){Navigator.of(context).pop();},
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

          onTap: (){
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => Music()),
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

  Future<void> deleteDoc(String docID) async{
    final CollectionReference playListCollRef = FirebaseFirestore.instance.collection('playlist');
    List<PlayListModel> resultPlayList = [];
    QuerySnapshot querySnapshot = await playListCollRef.where('Title', isEqualTo: "아이유").get();

    await FirebaseFirestore.instance.collection('playlist').doc(docID).delete();
    //return resultPlayList;


    await FirebaseFirestore.instance.collection('playlist').doc(docID).delete();

    //return

  }

  void updateDoc(String docID, String name) {
    FirebaseFirestore.instance.collection('playlist').doc(docID).update({
      'Title': name,
    });
  }

}

