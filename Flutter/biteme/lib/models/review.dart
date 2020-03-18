import 'package:flutter/material.dart';

class Review {
  final String id;
  final String title;
  final int rating;
  final String description;
  final String reviewer;
  final int likes;

  Review({this.id, this.title, this.rating, this.description, this.reviewer, this.likes});

  String get getId {
    return id;
  }

  String get getTitle {
    return title;
  }

  int get getRating {
    return rating;
  }

  //Converts Product to Json format
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'rating': rating,
    'description': description,
    'reviewer': reviewer,
    'likes': likes
  };

  //Converts to Product from Json format
  Review.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        rating = json['rating'],
        reviewer = json['reviewer'],
        likes = json['likes'];

}
