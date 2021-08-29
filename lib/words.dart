import 'package:flutter/material.dart';

import './sizeConfig.dart';
import './favouriteWords.dart';
import './trash.dart';

import 'dart:async';
import 'package:english_words/english_words.dart';

class Words extends StatefulWidget {
  @override
  _WordsState createState() => _WordsState();
}

class _WordsState extends State<Words> {
  List<String> words = [];

  List<String> favWords = [];

  List<String> deletedWords = [];

  Widget popupMenuButton() {
    return PopupMenuButton<String>(
      child: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "random",
          child: Text("add random word"),
        ),
        PopupMenuItem<String>(
          value: "no random",
          child: Text("add word"),
        ),
      ],
      onSelected: (retVal) {
        if (retVal == "random")
          _addRandomWord();
        else
          _alert();
      },
    );
  }

  void _alert() {
    String word;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Insert word'),
        content: TextField(
          onChanged: (text) => {word = text},
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter a word to add',
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              _addWord(word);
              Navigator.of(context).pop();
            },
            child: Text("add"),
          )
        ],
      ),
    );
  }

  void _addRandomWord() {
    setState(() {
      var word = generateWordPairs().first.asPascalCase;
      if (!words.contains(word)) words.add(word);
    });
  }

  void _addWord(String word) {
    setState(() {
      if (!words.contains(word)) words.add(word);
    });
  }

  bool alreadyFav(String word) {
    return favWords.contains(word);
  }

  void _removeWord(String word) {
    setState(() {
      deletedWords.add(word);
      words.remove(word);
      favWords.remove(word);
      new Timer.periodic(
        Duration(
          seconds: 10,
        ),
        (_) {
          deletedWords.remove(word);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Words'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeletedWords(
                deletedWords: deletedWords,
                addWord: _addWord,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavouriteWords(
                  favWords: favWords,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: getY(context),
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 5,
            bottom: 30,
          ),
          children: ListTile.divideTiles(
            context: context,
            color: Colors.grey,
            tiles: words.map(
              (word) => ListTile(
                title: Text(word),
                trailing: IconButton(
                  icon: alreadyFav(word)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                        ),
                  onPressed: () {
                    setState(() {
                      if (alreadyFav(word))
                        favWords.remove(word);
                      else
                        favWords.add(word);
                    });
                  },
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(
                        'Are you sure ?',
                        textAlign: TextAlign.center,
                      ),
                      content: Container(
                        height: 90,
                        child: Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'delete  ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: word,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'You will not be able to recover this word after ten seconds',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                          color: Colors.red,
                          onPressed: () {
                            _removeWord(word);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        FlatButton(
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ).toList(),
        ),
      ),
      floatingActionButton: popupMenuButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
