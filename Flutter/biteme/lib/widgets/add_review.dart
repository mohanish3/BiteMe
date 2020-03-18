import 'package:biteme/models/review.dart';
import 'package:flutter/material.dart';

//Bottom modal sheet widget
class AddReview extends StatefulWidget {
  final Function addReview;
  final GlobalKey<ScaffoldState> scaffoldKey;

  AddReview({this.addReview, this.scaffoldKey});

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

  void addData() {
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

    widget.addReview(Review(
        title: enteredTitle,
        description: enteredDescription,
        likes: 0,
        rating: selectedStars,
        reviewer: 'Mohanish Mhatre'));

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
