import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireauth/Start.dart';
import 'package:fireauth/edit_profile.dart';
import 'package:fireauth/maps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:authentification/Start.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fireauth/services/globals.dart' as global;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

BorderRadiusGeometry radius = BorderRadius.only(
  topLeft: Radius.circular(24.0),
  topRight: Radius.circular(24.0),
);
PanelController panelContrl = PanelController();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;
  double latitude = 37.42796133580664;
  double longitude = -122.085749655962;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser!;
    await firebaseUser.reload();
    firebaseUser = _auth.currentUser!;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
    global.name = "";
    global.email = "";
    global.ID = "";
    global.profilepic = "";
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
    _CurrentLocation;
  }

  Future<int> _CurrentLocation() async {
    print("here");
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    print("homo homo");
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print("hey i am latitude ${position.latitude}");
    latitude = position.latitude;
    longitude = position.longitude;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                map(longitude: longitude, latitude: latitude)));
    return 1;
    // ).then((Position position) {
    //   setState(() {
    //     _currentPosition = position;
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    File? image =
        (global.profilepic != "default") ? File(global.profilepic) : null;
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          leading: Spacer(),
          title: Text('X Locations',
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: signOut, icon: Icon(Icons.exit_to_app_outlined))
          ],
        ),
        body: Column(
          // children: [
          //   Container(
          //     child: Column(
          children: <Widget>[
            // SizedBox(height: 40.0),
            Card(
              color: Colors.black,
              elevation: 5,
              child: ListTile(
                leading: SizedBox(width: 60),
                title: Text(
                  'Welcome To X Locations ${(global.name!).toUpperCase()}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
                width: width / 2,
                height: height / 3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: (global.profilepic == "default")
                        ? AssetImage("assets/default.jpg")
                        : FileImage(image!) as ImageProvider,
                  ),
                )),
            // Container(
            //   height: height / 3.5,
            //   width: width,
            //   child: CircleAvatar(
            //     radius: height * 0.06,
            //     backgroundImage: (global.profilepic == null)
            //         ? AssetImage("assets/default.jpg")
            //         : FileImage(image!) as ImageProvider,
            //   ),
            // ),
            // Container(
            //   height: 300,
            //   child: Image(
            //     image: AssetImage("images/welcome.png"),
            //     fit: BoxFit.contain,
            //   ),
            // ),
            // Container(
            //   height: 100,
            //   child: FutureBuilder<QuerySnapshot>(
            //     builder: (context, snapshot) {
            //       return (snapshot.hasData)
            //           ? (snapshot.data!.docs.length != 0)
            //               ? Column(
            //                   children: [
            //                     Row(
            //                       children: [
            //                         Container(
            //                             padding: EdgeInsets.all(8),
            //                             height: 50,
            //                             child: Text(
            //                               'USERNAME:',
            //                             )),
            //                         Container(
            //                             padding: EdgeInsets.all(8),
            //                             height: 50,
            //                             child: Text(
            //                               snapshot.data!.docs[0]['username'],
            //                             )),
            //                       ],
            //                     ),
            //                     Row(
            //                       children: [
            //                         Container(
            //                             padding: EdgeInsets.all(8),
            //                             height: 50,
            //                             child: Text(
            //                               'EMAIL:',
            //                             )),
            //                         Container(
            //                             padding: EdgeInsets.all(8),
            //                             height: 50,
            //                             child: Text(
            //                               snapshot.data!.docs[0]['email'],
            //                             )),
            //                       ],
            //                     )
            //                   ],
            //                 )
            //               : CircularProgressIndicator()
            //           // Container(
            //           //           padding: EdgeInsets.all(10),
            //           //           height: 100,
            //           //           child: Text(
            //           //             "Hello ${snapshot.data!.docs[0]['username']} you are Logged in as ${snapshot.data!.docs[0]['email']}",
            //           //             style: TextStyle(
            //           //                 fontSize: 20.0,
            //           //                 fontWeight: FontWeight.bold),
            //           //           ))
            //           //       : Container(
            //           //           padding: EdgeInsets.all(10),
            //           //           height: 100,
            //           //           child: Text(
            //           //             "Hello ${global.name} you are Logged in as ${global.email}",
            //           //             style: TextStyle(
            //           //                 fontSize: 20.0,
            //           //                 fontWeight: FontWeight.bold),
            //           //           ))
            //           : Container();
            //     },
            //     future: FirebaseFirestore.instance
            //         .collection('users')
            //         .where('id', isEqualTo: global.ID)
            //         .get(),
            //   ),
            // ),

            Container(
                height: height * 0.25,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/maps.jpg"),
                        fit: BoxFit.cover)),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                    // widthFactor: ,
                    child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  child: Text('GET MY LOCATION',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    print("hola");
                    await _CurrentLocation();
                    setState(() {
                      print("callong set state");
                    });
                  },
                ))),

            // IconButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => map(
            //                   longitude: longitude, latitude: latitude)));
            //     },
            //     icon: Icon(Icons.map)),
            // Spacer()

            // Container(
            //     height: 50,
            //     child: TextButton(
            //       child: Text('Current Location',
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 10.0,
            //               fontWeight: FontWeight.bold)),
            //       onPressed: () async {
            //         print("hola");
            //         await _CurrentLocation();
            //         setState(() {
            //           print("callong set state");
            //         });
            //       },
            //     )),
            // child: ElevatedButton(
            //   style: ButtonStyle(
            //     padding: MaterialStateProperty.all(
            //         EdgeInsets.fromLTRB(70, 10, 70, 10)),
            //     shape:
            //         MaterialStateProperty.all(RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20.0),
            //     )),
            //     foregroundColor:
            //         MaterialStateProperty.all(Colors.green),
            //     backgroundColor:
            //         MaterialStateProperty.all(Colors.green),
            //   ),
            //   child: ,
            //   onPressed: _CurrentLocation,
            // )),
            SizedBox(
              height: 50,
            ),
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: Text('Edit Your Profile!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()));
                  },
                )),

            // decoration: BoxDecoration(
            //   color: Colors.green,
            //   borderRadius: BorderRadius.circular(20.0),
            // ))
            // RaisedButton(

            //   onPressed: signOut,
            //   child: Text('Signout',
            //       style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 20.0,
            //           fontWeight: FontWeight.bold)),
            //   color: Colors.green,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(20.0),
            // ),
            // )
          ],
        )
        /*SlidingUpPanel(
          borderRadius: radius,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          controller: panelContrl,
          body: !isloggedin
              ? CircularProgressIndicator()
              : ,
          // panelBuilder: (controller) {
          panel: map(latitude: latitude, longitude: longitude)
          // },
          // panel: (_currentPosition != null)
          //     ? map(
          //         latitude: _currentPosition!.latitude,
          //         longitude: _currentPosition!.longitude)
          //     : map(),
          ),*/
        );
  }
}

 



// class PanelWidget extends StatelessWidget {
//   final ScrollController controller;

//   const PanelWidget({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) => Container();
//         },
//       ),;
// }

