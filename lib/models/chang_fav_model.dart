class ChangFavModel {
  bool? status;
  String? message;

  ChangFavModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

}

