import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireauth/groupmap.dart';
import 'package:fireauth/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fireauth/services/globals.dart' as global;
import 'package:location/location.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("YOUR GROUPS"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where('userlist', arrayContains: global.name)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Card(
                    elevation: 5,
                    child: ListTile(
                        onTap: () async {
                          final location = Location.instance;
                          final loc = await location.getLocation();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Groupmap(
                                        groupid: snapshot.data!.docs[index].id,
                                        latitude: loc.latitude!,
                                        longitude: loc.longitude!,
                                      )));
                        },
                        title: Text(
                            '${snapshot.data!.docs[index]['groupname']}')));
              },
            );
          } else {
            return Container(
              child: CircularProgressIndicator(),
              height: MediaQuery.of(context).size.height * 0.1,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showSearch(context: context, delegate: datasearch());
          }),
    );
  }
}
