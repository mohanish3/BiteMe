import 'package:biteme/utilities/firebase_functions.dart';

class Review {
  final String id;
  final String title;
  final int rating;
  final String description;
  final String authorId;
  final String authorName;
  List<String> likes;

  Review({this.id, this.title, this.rating, this.description, this.authorId, this.likes, this.authorName});

  bool hasUserLiked(String userId) {
    //Binary search through the users list
    int lb = 0;
    int ub = likes.length - 1;
    while(lb <= ub) {
      int mid = ((lb + ub)/2).floor();
      if(userId == likes[mid])
        return true;
      else if(userId.compareTo(likes[mid]) > 0)
        lb = mid + 1;
      else
        ub = mid - 1;
    }
    return false;
  }

  //Assumes user has not liked
  void likeReview(String userId, String productId) {
    for(int i = 0; i < likes.length; i++) {
      if(userId.compareTo(likes[i]) < 0) {
        likes.insert(i, userId);
        FirebaseFunctions.getTraversedChild(['products', productId, 'reviews', id, 'likes']).set(likes);
        return;
      }
    }
    likes.add(userId);
    FirebaseFunctions.getTraversedChild(['products', productId, 'reviews', id, 'likes']).set(likes);
  }

  //Assumes user has liked
  void unlikeReview(String userId, String productId) {
    for(int i = 0; i < likes.length; i++) {
      if(userId.compareTo(likes[i]) == 0) {
        likes.removeAt(i);
        FirebaseFunctions.getTraversedChild(['products', productId, 'reviews', id, 'likes']).set(likes);
        return;
      }
    }
  }

  //Converts Review to Json format
  Map<String, dynamic> toJson() => {
    'title': title,
    'rating': rating,
    'description': description,
    'authorName': authorName,
    'authorId': authorId,
    'likes': likes
  };

  static List<String> getLikes(List<dynamic> likes) {
    if(likes == null)
      return [];
    List<String> likesString = [];
    for(int i = 0; i < likes.length; i++) {
      likesString.add(likes[i]);
    }
    return likesString;
  }

  Review.fromJson(Map<dynamic, dynamic> json)
      : id = json['key'],
        title = json['value']['title'],
        description = json['value']['description'],
        rating = json['value']['rating'],
        authorId = json['value']['authorId'],
        authorName = json['value']['authorName'],
        likes = getLikes(json['value']['likes']);

}
