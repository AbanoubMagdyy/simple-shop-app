class CategoriesModel {
  bool? status;
  Data? data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  List<DataModel>data =[];

  Data.fromJson(Map<String, dynamic> json) {
      json['data'].forEach((v) {
        data.add(DataModel.fromJson(v));
      });
    }
}

class DataModel {
  int? id;
  late String name;
  late String image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}