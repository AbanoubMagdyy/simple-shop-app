class SearchModel {
  bool? status;
  Data? data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<SearchProduct>? data;


  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SearchProduct>[];
      json['data'].forEach((v) {
        data!.add(SearchProduct.fromJson(v));
      });
    }
  }
}

class SearchProduct {
  int? id;
  dynamic price;
  dynamic oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;

  SearchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
