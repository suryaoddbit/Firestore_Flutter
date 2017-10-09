import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'package:firebase_firestore/firebase_firestore.dart';

//import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


import 'dart:math';
import 'dart:io';

//final ref = Firestore.instance.collection('books').document()
//    .setData({ 'title': 'title', 'author': 'author' });
final ref = Firestore.instance;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('chat').snapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return new Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 16.0, left: 10.0),
                    child: new CircleAvatar(
                        child: new Text(getAvatar(document['name']))),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(document['name'],
                          style: Theme.of(context).textTheme.subhead),
                      new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: new Text(document['message']),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String getAvatar(String name) {
    print("name " + name);
    String avatar = "";
    List<String> nama = name.split(" ");
    print("Count" + nama.length.toString());
    if (nama.length <= 1) {
      avatar = name[0];
      print("if");
    } else {
      avatar = nama[0][0] + "" + nama[1][0];
      print("else");
    }
    print("avatar " + avatar);
    return avatar;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _textController = new TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(child: new BookList()),
            new Container(
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String message, String urlImage) {
    ref
        .collection('chat')
        .document()
        .setData({'message': message, 'name': 'Surya Adi'});
    _textController.clear();
  }

  Widget _buildTextComposer() {
    bool _isComposing = false;
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.photo_camera),
                onPressed: () async {
//                  File imageFile = await ImagePicker.pickImage();
//                  int random = new Random().nextInt(100000);
//                  StorageReference ref =
//                  FirebaseStorage.instance.ref().child("image_$random.jpg");
//                  StorageUploadTask uploadTask = ref.put(imageFile);
//                  Uri downloadUrl = (await uploadTask.future).downloadUrl;
//                  //_sendMessage(imageUrl: downloadUrl.toString());
                },
              ),
            ),
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: null,
                onSubmitted: null,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child:  new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _isComposing ?
                    () =>  _handleSubmitted(_textController.text,"") : null,
              ),
            ),
          ]),
        ));
  }
}
