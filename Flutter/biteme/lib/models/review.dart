import 'package:biteme/utilities/firebase_functions.dart';

class Review {
  final String id;
  final String title;
  final int rating;
  final String description;
  final String authorId;
  final String authorName;
  List<String> likes;

  Review(
      {this.id,
      this.title,
      this.rating,
      this.description,
      this.authorId,
      this.likes,
      this.authorName});

  bool hasUserLiked(String userId) {
    //Binary search through the users list
    int lb = 0;
    int ub = likes.length - 1;
    while (lb <= ub) {
      int mid = ((lb + ub) / 2).floor();
      if (userId == likes[mid])
        return true;
      else if (userId.compareTo(likes[mid]) > 0)
        lb = mid + 1;
      else
        ub = mid - 1;
    }
    return false;
  }

  //Assumes user has not liked
  bool likeReview(String userId, String productId) {
    if(userId == authorId)
      return false;
    FirebaseFunctions.getTraversedChild(
            ['products', productId, 'reviews', id, 'likes'])
        .once()
        .then((snapshot) {
          if(snapshot.value == null)
            likes = [];
          else
            likes = new List<String>.from(snapshot.value);
      //Binary search to find the least element greater than the userId
      int lb = 0;
      int ub = likes.length;
      while (lb < ub) {
        int mid = ((lb + ub) / 2).floor();
        if (likes[mid].compareTo(userId) <= 0)
          lb = mid + 1;
        else
          ub = mid;
      }
      likes.insert(lb, userId);
      FirebaseFunctions.getTraversedChild(
          ['products', productId, 'reviews', id, 'likes']).set(likes);
    });
    return true;
  }

  //Assumes user has liked
  void unlikeReview(String userId, String productId) {
    FirebaseFunctions.getTraversedChild(
            ['products', productId, 'reviews', id, 'likes'])
        .once()
        .then((snapshot) {
      likes = new List<String>.from(snapshot.value);
      //Binary search to find the review to be removed
      int lb = 0;
      int ub = likes.length - 1;
      while (lb <= ub) {
        int mid = ((lb + ub) / 2).floor();
        if (userId.compareTo(likes[mid]) == 0) {
          likes.removeAt(mid);
          FirebaseFunctions.getTraversedChild(
              ['products', productId, 'reviews', id, 'likes']).set(likes);
          return;
        } else if (userId.compareTo(likes[mid]) > 0)
          lb = mid + 1;
        else
          ub = mid - 1;
      }
    });
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
    if (likes == null) return [];
    return new List<String>.from(likes);
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
