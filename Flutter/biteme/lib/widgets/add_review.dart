import 'package:biteme/models/review.dart';
import 'package:biteme/utilities/firebase_functions.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//Bottom modal sheet widget
class AddReview extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String productId;

  AddReview({this.scaffoldKey, this.productId});

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int selectedStars = 3;
  List<Widget> stars = [];

  _AddReviewState() {
    for (int i = 1; i <= 5; i++) {
      if (i <= selectedStars)
        stars.add(IconButton(
          icon: Icon(Icons.star),
          onPressed: () => selectRating(i),
          color: Colors.amber,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ));
      else
        stars.add(
          IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () => selectRating(i),
            color: Colors.amber,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        );
    }
  }

  void addData() async {
    final String enteredTitle = titleController.text;
    final String enteredDescription = descriptionController.text;

    if (enteredTitle == '' || enteredDescription == '') {
      Navigator.of(context).pop();
      _displaySnackbar(context, 'Neither can be empty!');
      return;
    }

    if (enteredTitle.length > 15) {
      Navigator.of(context).pop();
      _displaySnackbar(context, "Title can't exceed 15 characters");
      return;
    }

    if (enteredTitle.length > 500) {
      Navigator.of(context).pop();
      _displaySnackbar(context, "Description can't exceed 500 characters");
      return;
    }

    FirebaseUser user;
    user = await FirebaseAuth.instance.currentUser();

    bool alreadyReviewed = false;
    DatabaseReference ref = FirebaseFunctions.getTraversedChild(['users', user.uid, 'history', 'reviewedProducts']);
    ref.once().then((snapshot) {
      //Binary search to find least element greater than the key
      List<dynamic> productsReviewedList;
      if(snapshot.value == null)
        productsReviewedList = [];
      else
        productsReviewedList = new List<String>.from(snapshot.value);
      int lb = 0;
      int ub = productsReviewedList.length;
      while(lb < ub) {
        int mid = ((lb + ub)/2).floor();
        if(productsReviewedList[mid].compareTo(widget.productId) <= 0)
          lb = mid + 1;
        else
          ub = mid;
      }

      //Insert in the list if the productId does not already exist in it
      if(lb == 0)
        productsReviewedList.insert(0, widget.productId);
      else if(productsReviewedList[lb - 1] == widget.productId) {
        alreadyReviewed = true;
        return;
      }
      else {
        productsReviewedList.insert(lb, widget.productId);
      }


      /*ServerFunctions.postRequest([
          'gradeReview'
        ], [
          ['user', user.uid],
          ['product', widget.productId],
          ['review', enteredDescription]
        ]).then((value){DatabaseReference ref = FirebaseFunctions.getTraversedChild(['users', user.uid, 'credits']);
      ref.once().then((credits) =>
        ref.set(int.parse(value) + credits.value)
      );*/
      Review review = Review(
          title: enteredTitle,
          description: enteredDescription,
          likes: [],
          rating: selectedStars,
          authorName: user.displayName,
          authorId: user.uid);
          DatabaseReference reviewsRef = FirebaseFunctions.getTraversedChild(
              ['products', widget.productId, 'reviews']);
          DatabaseReference newRef = reviewsRef.push();
          newRef.set(review.toJson());
      //});
      ref.set(productsReviewedList);
    });

    if(alreadyReviewed) {
      print("ALREADY Done!");
      _displaySnackbar(context, 'Already reviewed!');
    }
    Navigator.of(context).pop();
  }

  void selectRating(int rating) {
    if (rating == selectedStars) return;
    selectedStars = rating;
    stars.clear();
    setState(() {
      for (int i = 1; i <= 5; i++) {
        if (i <= selectedStars)
          stars.add(IconButton(
            icon: Icon(Icons.star),
            onPressed: () => selectRating(i),
            color: Colors.amber,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ));
        else
          stars.add(IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () => selectRating(i),
            color: Colors.amber,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'New Review',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => addData,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Description'),
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSubmitted: (_) => addData,
            ),
            Row(
              children: stars,
            ),
            Container(
                alignment: Alignment.topRight,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Theme.of(context).textSelectionColor,
                  child:
                      Text('Add review', style: TextStyle(color: Colors.white)),
                  onPressed: addData,
                ))
          ],
        ),
      ),
    );
  }

  void _displaySnackbar(BuildContext context, String text) {
    final snackbar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Theme.of(context).cardColor,
      behavior: SnackBarBehavior.floating,
    );
    widget.scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
