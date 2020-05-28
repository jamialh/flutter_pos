import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';

class stall_types_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _stall_types_screenState();
  }
}

class _stall_types_screenState extends State<stall_types_screen> {
  Stream<QuerySnapshot> stream;
  List<String> images = new List();
  int count = 0;
  bool loaded = false;

  //query data from firebase current limit is 100
  get_data() {
    CollectionReference collectionReference =
        Firestore.instance.collection('stall_types');
    stream = collectionReference.limit(100).snapshots();
  }

  @override
  void initState() {
    super.initState();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: Text(
            languages.skeleton_language_objects[config.app_language]
                ['store_outlets_type'],
            style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: SpinKitChasingDots(color: Colors.deepPurple),
                );
              count = snapshot.data.documents.length;
              return new ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _stall_types_tile(
                    context, snapshot.data.documents[index], index),
              );
            }));
  }

  //stall type list items
  Widget _stall_types_tile(context, document, index) {
    return ListTile(
      key: ValueKey(document.documentID),
      title: Text(document['stallName'],
          maxLines: 1,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 14)),
      subtitle: Text("Stall is : " + document['stallPublic'],
          maxLines: 2,
          style: new TextStyle(fontFamily: "Roboto", fontSize: 12)),
      trailing: Text(document['stall_typestatus'],
          maxLines: 1,
          style: new TextStyle(
              fontFamily: "Roboto", fontSize: 14, color: Colors.purpleAccent)),
      leading: new CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Image.network(
            document['stallCover'][0]['publicUrl'],
            fit: BoxFit.fill,
          )),
      onTap: () {},
    );
  }
}
