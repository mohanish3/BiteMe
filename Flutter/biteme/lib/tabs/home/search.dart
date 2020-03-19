import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/widgets/searches_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biteme/routes/search_page.dart';

class SearchTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  SearchTab({this.scaffoldKey});

  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<String> searches;
  final TextEditingController searchController = TextEditingController();
  SharedPreferences sharedPreferences;

  _SearchTabState() {
    searches = [];
    initPreferences();
  }

  void initPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (!mounted) return; //Fix for any memory leaks due to setState called after dispose()
    setState(() {
      searches = sharedPreferences.getStringList('searches');
      if (searches == null) {
        searches = [];
        sharedPreferences.setStringList('searches', searches);
      }
    });
  }

  void getPreviouslySearched(int index) {
    String selected = searches[index];

    if (!mounted) return; //Fix for any memory leaks due to setState called after dispose()
    setState(() {
      searches.removeAt(index);
      searches.insert(0, selected);
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchQueryPage(searchQuery: selected),));
  }

  void searchItem() {
    String searchQuery = searchController.text;
    searchController.clear();

    if (!mounted) return; //Fix for any memory leaks due to setState called after dispose()
    setState(() {
      searches.insert(0, searchQuery);
    });
    sharedPreferences.setStringList('searches', searches);

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchQueryPage(searchQuery: searchQuery),));
  }

  void deleteSearch(int index) {
    if (!mounted) return; //Fix for any memory leaks due to setState called after dispose()
    setState(() {
      searches.removeAt(index);
    });
    sharedPreferences.setStringList('searches', searches);
    _displaySnackbar(context, 'Deleted search!');
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(15),
        alignment: Alignment.topCenter,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: searchController,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products...",
                    hintStyle: TextStyle(fontSize: 20),
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                  ),
                ),
              ),
            ),
            CustomIconButton(
              icon: Icons.search,
              onPressed: () => searchItem(),
            )
          ],
        ),
      ),
      SearchesList(
        searches: searches,
        getPreviouslySearched: getPreviouslySearched,
        deleteSearch: deleteSearch
      ),
    ])));
  }

  void _displaySnackbar(BuildContext context, String text) {
    final snackbar = SnackBar(content: Text(text, style: TextStyle(color: Colors.black87),),
      backgroundColor: Theme.of(context).cardColor,);
    widget.scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
