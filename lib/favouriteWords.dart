import 'package:flutter/material.dart';
import 'sizeConfig.dart';

class FavouriteWords extends StatelessWidget {
  final List<String> favWords;

  FavouriteWords({
    this.favWords,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Words"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: getX(context),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5),
          children: ListTile.divideTiles(
            context: context,
            color: Colors.grey,
            tiles: favWords.map(
              (word) => ListTile(
                title: Text(word),
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}
