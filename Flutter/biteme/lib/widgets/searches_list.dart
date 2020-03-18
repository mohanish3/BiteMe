import 'package:flutter/material.dart';


class SearchesList extends StatelessWidget {
  List<String> searches;
  final Function getPreviouslySearched;
  final Function deleteSearch;

  SearchesList({this.searches, this.getPreviouslySearched, this.deleteSearch}) {
    if(searches == null)
      searches = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.76,
      child: searches.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No searches yet!',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                ),
              ],
            )
          : ListView.builder(
              itemCount: searches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => getPreviouslySearched(index),
                  onLongPress: () => deleteSearch(index),
                  leading: Text(
                    searches[index],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87),
                    overflow: TextOverflow.fade,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  trailing: Icon(Icons.arrow_forward),
                );
              }),
    );
  }
}
