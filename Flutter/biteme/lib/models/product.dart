import 'package:biteme/models/review.dart';
import 'package:biteme/utilities/firebase_functions.dart';
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

  getBookmarkStatus(List<String> bookmarks, String productId) {
    String pid = productId;
    //Binary search to find the product id
    int lb = 0;
    int ub = bookmarks.length - 1;
    while (lb <= ub) {
      int mid = ((lb + ub) / 2).floor();
      if (bookmarks[mid] == pid)
        return true;
      else if (bookmarks[mid].compareTo(pid) > 0)
        ub = mid - 1;
      else
        lb = mid + 1;
    }
    return false;
  }

  bookmark(List<String> bookmarks, String userId, String pid) {
    FirebaseFunctions.getTraversedChild(['users', userId, 'bookmarks'])
        .once()
        .then((snapshot) {
      bookmarks =
      snapshot.value == null ? [] : new List<String>.from(snapshot.value);
      //Binary search to find the least element greater than the pid
      int lb = 0;
      int ub = bookmarks.length;
      while (lb < ub) {
        int mid = ((lb + ub) / 2).floor();
        if (bookmarks[mid].compareTo(pid) <= 0)
          lb = mid + 1;
        else
          ub = mid;
      }
      bookmarks.insert(lb, pid);
      FirebaseFunctions.getTraversedChild(['users', userId, 'bookmarks'])
          .set(bookmarks);
    });
  }

  unBookmark(List<String> bookmarks, String userId, String pid) {
    FirebaseFunctions.getTraversedChild(['users', userId, 'bookmarks'])
        .once()
        .then((snapshot) {
      bookmarks =
      snapshot.value == null ? [] : new List<String>.from(snapshot.value);
      //Binary search to find pid
      int lb = 0;
      int ub = bookmarks.length;
      while (lb <= ub) {
        int mid = ((lb + ub) / 2).floor();
        if (bookmarks[mid] == pid) {
          bookmarks.removeAt(mid);
          FirebaseFunctions.getTraversedChild(['users', userId, 'bookmarks'])
              .set(bookmarks);
          return;
        } else if (bookmarks[mid].compareTo(pid) < 0)
          lb = mid + 1;
        else
          ub = mid - 1;
      }
      bookmarks.insert(lb, pid);
      FirebaseFunctions.getTraversedChild(['users', userId, 'bookmarks'])
          .set(bookmarks);
    });
  }


  Product.fromJson(Map<String, dynamic> json) :
        id = json['key'],
        title = json['value']["name"],
        description = json['value']['description'],
        imageUrl = json['value']["image"];

}
