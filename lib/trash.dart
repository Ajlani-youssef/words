import 'package:flutter/material.dart';
import 'sizeConfig.dart';

class DeletedWords extends StatefulWidget {

  final List<String> deletedWords;

  final Function addWord;

  DeletedWords({
    this.deletedWords,
    this.addWord,
  });

  @override
  _DeletedWordsState createState() => _DeletedWordsState();
}

class _DeletedWordsState extends State<DeletedWords> {
  void _alert() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('the word is completely deleted'),
        content: Icon(
          Icons.dangerous,
          size: 50,
          color: Colors.red,
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("ok"),
          )
        ],
      ),
    );
  }

  void _recoverWord(String word) {
    setState(() {
      if (widget.deletedWords.contains(word)) {
        widget.deletedWords.remove(word);
        widget.addWord(word);
      } else {
        _alert();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trash Can"),
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
            tiles: widget.deletedWords.map(
              (word) => ListTile(
                title: Text(word),
                leading: IconButton(
                  onPressed: () => _recoverWord(word),
                  icon: Icon(
                    Icons.undo,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}
