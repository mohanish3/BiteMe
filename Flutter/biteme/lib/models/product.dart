import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//Model for each Product
class Product {
  String id;
  String title;
  String imageUrl;

  Product(
      {@required this.title, this.imageUrl}) {
    var uuid = Uuid();
    this.id = 'product'+uuid.v4(); // Gets unique ID for each product
  }

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

  //Converts to Product from Json format
  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'];


}
