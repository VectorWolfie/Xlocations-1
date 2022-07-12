import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fireauth/services/globals.dart' as global;

// TextEditingController _searchquery = TextEditingController();
// String? _username = global.name;
// List<String> _usernames = <String>[];
List<String> _selectedusernames = <String>[];
// Map<String, bool> _selectedusernamesbool = <String, bool>{};

// class Searchpage extends StatefulWidget {
//   const Searchpage({Key? key}) : super(key: key);

//   @override
//   State<Searchpage> createState() => _SearchpageState();
// }

// class _SearchpageState extends State<Searchpage> {
//   Widget _buildSearchField() {
//     return new TextField(
//       controller: _searchquery,
//       autofocus: true,
//       decoration: const InputDecoration(
//           hintText: 'search by username',
//           border: InputBorder.none,
//           hintStyle: const TextStyle(color: Colors.white30)),
//       style: const TextStyle(color: Colors.white, fontSize: 16.0),
//       onChanged: (text) {
//         int i = 0;
//         _usernames.clear();
//         FirebaseFirestore.instance
//             .collection('users')
//             .where('username', isEqualTo: text)
//             .get()
//             .then((snapshot) {
//           setState(() {
//             snapshot.docs.forEach((element) {
//               if (element['username'] != _username) {
//                 if (!_usernames.contains(element['username'])) {
//                   _usernames.insert(i, element['username']);
//                 }
//                 if (_selectedusernames.contains(element['username'])) {
//                   _selectedusernamesbool.update(
//                       element['username'], (value) => true,
//                       ifAbsent: () => true);
//                 } else {
//                   _selectedusernamesbool.update(
//                       element['username'], (value) => false,
//                       ifAbsent: () => false);
//                 }
//               }
//               i++;
//             });
//           });
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(),
//         title: _buildSearchField(),
//       ),
//       body:
//           Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.symmetric(),
//           child: Align(
//             alignment: Alignment.topLeft,
//             child: Wrap(
//               spacing: 6.0,
//               runSpacing: 6.0,
//               children: _selectedusernames
//                   .map((item) => _buildchip(item, Color(0xFFff6666)))
//                   .toList()
//                   .cast<Widget>(),
//             ),
//           ),
//         ),
//         Divider(thickness: 1.0),
//         ListView.builder(
//             itemCount: _usernames.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(
//                   _usernames[index],
//                   style: TextStyle(color: Colors.black),
//                 ),
//               );
//             })
//       ]),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.check),
//         onPressed: () {},
//       ),
//     );
//   }
// }
class datasearch extends SearchDelegate<String> {
  final txt = TextEditingController();
  Widget _buildchip(String label, Color color) {
    return Chip(
      avatar: CircleAvatar(child: Text(label[0].toUpperCase())),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      deleteIcon: Icon(Icons.close),
      onDeleted: () => _deleteselected(label),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  _deleteselected(String label) {
    _selectedusernames.remove(label);
    query = "";
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  String reos = "";
  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, reos);
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    reos = query;
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length == 0 || query.length == 1) {
      return Column(
        children: [
          TextField(
            controller: txt,
            decoration: InputDecoration(labelText: 'enter group name'),
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(),
            child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: _selectedusernames
                    .map((item) => _buildchip(item, Color(0xFFff6666)))
                    .toList()
                    .cast<Widget>(),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  onPressed: () {
                    createit(txt.text);
                    this.close(context, query);
                  },
                  child: Icon(Icons.check)))
        ],
      );
    } else {
      var strSearch = query;
      var strlength = strSearch.length;
      var strFrontCode = strSearch.substring(0, strlength - 1);
      var strEndCode = strSearch.substring(strlength - 1, strSearch.length);

      var startcode = strSearch;
      var endcode =
          strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      // TODO: implement buildSuggestions
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('username', isGreaterThanOrEqualTo: startcode)
              .where('username', isLessThan: endcode)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Column(
                children: [
                  TextField(
                    controller: txt,
                    decoration: InputDecoration(labelText: 'enter group name'),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: _selectedusernames
                            .map((item) => _buildchip(item, Color(0xFFff6666)))
                            .toList()
                            .cast<Widget>(),
                      ),
                    ),
                  ),

                  // Divider(
                  //   thickness: 1.0,
                  // ),
                  Flexible(
                      child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final image = (snapshot.data!.docs[index]['profilepic'] !=
                              "default")
                          ? File(snapshot.data!.docs[index]['profilepic'])
                          : null;
                      return ListTile(
                        leading: Container(
                            width: 130,
                            height: MediaQuery.of(context).size.height / 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: (snapshot.data!.docs[index]
                                            ['profilepic'] ==
                                        "default")
                                    ? AssetImage("assets/default.jpg")
                                    : FileImage(image!) as ImageProvider,
                              ),
                            )),
                        onTap: () {
                          query = "";
                          _selectedusernames
                              .add(snapshot.data!.docs[index]["username"]);
                        },
                        // leading: CircleAvatar(
                        //   backgroundImage: FileImage(
                        //       File(snapshot.data!.docs[index]["profile_pic"])),
                        // ),
                        title: Text(
                          snapshot.data!.docs[index]["username"],
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
                  )),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          onPressed: () {
                            createit(txt.text);
                            this.close(context, query);
                          },
                          child: Icon(Icons.check)))
                ],
              );
            }
          });
    }
  }
}

// creategroup(BuildContext context) {
//   final groupname = TextEditingController();
//   AlertDialog(
//     title: Text("enter group name"),
//     content: TextField(controller: groupname),
//     actions: <Widget>[
//       ElevatedButton(
//         onPressed: () {
//           createit(groupname.text);
//         },
//         child: Text("create group"),
//       ),
//     ],
//   );

//   // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
// }

void createit(String text) {
  _selectedusernames.add(global.name!);
  FirebaseFirestore.instance
      .collection('groups')
      .add({"groupname": text, "userlist": _selectedusernames});
  _selectedusernames.clear();
}
// class Search extends StatefulWidget {
//   const Search({Key? key}) : super(key: key);

//   @override
//   State<Search> createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: datasearch());
//   }
// }
