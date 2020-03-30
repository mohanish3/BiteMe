import 'dart:convert';

import 'package:biteme/models/product.dart';
import 'package:biteme/utilities/server_functions.dart';
import 'package:biteme/widgets/custom_app_bar.dart';
import 'package:biteme/widgets/custom_icon_button.dart';
import 'package:biteme/widgets/search_results_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchQueryPage extends StatelessWidget {
  final String searchQuery;
  final FirebaseUser user;

  SearchQueryPage({this.searchQuery, this.user});

  Future<List<dynamic>> getSearchResults() async {
    dynamic results = await ServerFunctions.getRequest([
      'searchProduct'
    ], [
      ['query', searchQuery]
    ]);
    return jsonDecode(results)['results'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
            child: Container(
                child: Column(children: <Widget>[
          CustomAppBar(
            icons: <Widget>[
              CustomIconButton(
                  icon: Icons.arrow_back_ios,
                  onPressed: () => Navigator.of(context).pop()),
              Text(
                this.searchQuery,
                style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          FutureBuilder(
              future: getSearchResults(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Expanded(
                      child: Center(child: CircularProgressIndicator()));
                else {
                  if(snapshot.data == null)
                    return Container(child:Text('Server down', style: TextStyle(fontSize: 30),));
                  List<Product> _searchResultsList = [];
                  for (var json in snapshot.data) {
                    _searchResultsList.add(Product.fromJson(json));
                  }
                  if(_searchResultsList == null || _searchResultsList.isEmpty)
                    return Container(child:Text('No results found!', style: TextStyle(fontSize: 30),));
                  else
                  return SearchResultsList(
                    searchResultsList: _searchResultsList,
                    user: user,
                  );
                }
              }),
        ]))));
  }
}
