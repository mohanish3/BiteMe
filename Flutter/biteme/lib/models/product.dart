import 'package:biteme/models/review.dart';
import 'package:firebase_database/firebase_database.dart';

//Model for each Product
class Product {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  List<Review> reviewList;

  Product(
      {this.id, this.title, this.imageUrl, this.description});

  String get getId {
    return id;
  }

  String get getTitle {
    return title;
  }

  String get getImageUrl {
    return imageUrl;
  }

  //Converts Product to Json format
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
  };

  Product.fromJson(Map<String, dynamic> json) :
        id = json['key'],
        title = json['value']["name"],
        description = json['value']['description'],
        imageUrl = json['value']["image"];

}
