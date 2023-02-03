class MusicItemsModel {

  String? id;
  String? image;
  String? path;
  String? name;
  String? title;
  String? length;


  MusicItemsModel(
      {
        this.id,
        this.image,
        this.path,
        this.name,
        this.title,
        this.length,
      }
      );

  MusicItemsModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        path = json['path'],
        name = json['image'],
        title = json['image'],
        length = json['image'];


  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'path' : path,
    'name' : name,
    'title' : title,
    'length' : length,

  };

}
