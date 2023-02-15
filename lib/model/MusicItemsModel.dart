class MusicItemsModel {

  String? id;
  String? image;
  String? path;
  String? name;
  String? title;
  String? length;
  bool isPlay = false;


  MusicItemsModel(
      {
        this.id,
        this.image,
        this.path,
        this.name,
        this.title,
        this.length,
        required this.isPlay
      }
      );

  MusicItemsModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        path = json['path'],
        name = json['image'],
        title = json['image'],
        length = json['image'],
        isPlay = json['isPlay'];


  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'path' : path,
    'name' : name,
    'title' : title,
    'length' : length,
    'isPlay' : isPlay,

  };

}
