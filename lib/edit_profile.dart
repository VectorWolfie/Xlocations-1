import 'dart:io';

import 'package:fireauth/HomePage.dart';
import 'package:fireauth/bottomnavigationbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fireauth/services/globals.dart' as global;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final username = TextEditingController(text: global.name);
  final email = TextEditingController(text: global.email);
  File? image =
      (global.profilepic != "default") ? File(global.profilepic) : null;
  final password = TextEditingController();
  save() async {
    await FirebaseFirestore.instance.collection('users').doc(global.ID).update({
      "username": username.text,
      "email": email.text,
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Bottomnavigationbar()));
    // Navigator.pop(context);
  }

  changephoto() {
    var height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            height: height / 8,
            child: ListView(children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('camera'),
                onTap: () {
                  Navigator.pop(context);
                  getimage(1);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('gallery'),
                onTap: () {
                  Navigator.pop(context);
                  getimage(2);
                },
              ),
            ])));
  }

  getimage(int choice) async {
    final newimage;
    try {
      if (choice == 1) {
        newimage = await ImagePicker().pickImage(source: ImageSource.camera);
      } else {
        newimage = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      if (newimage == null) {
        return;
      } else {
        //final temp = File(newimage!.path);
        final imagepermanent = await saveimagepermanently(newimage.path);
        setState(() {
          image = imagepermanent;
        });
      }
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  Future<File> saveimagepermanently(String imagepath) async {
    final Directory = await getApplicationDocumentsDirectory();
    final name = Path.basename(imagepath);
    final storedimage = File('${Directory.path}/$name');
    global.profilepic = storedimage.path;
    print("kakakaka ${storedimage.path}");
    FirebaseFirestore.instance
        .collection('users')
        .doc(global.ID)
        .update({"profilepic": global.profilepic});
    File(imagepath).copy(storedimage.path);
    return File(storedimage.path);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
              onPressed: () {
                save();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: (global.profilepic == "default")
                        ? AssetImage("assets/default.jpg")
                        : FileImage(image!) as ImageProvider,
                  ),
                )),
            onTap: () {
              changephoto();
            },
          ),
          // Container(
          //   height: height / 6,
          //   width: width,
          //   child: CircleAvatar(
          //     radius: height * 0.06,
          // backgroundImage: (global.profilepic == null)
          //     ? AssetImage("assets/default.jpg")
          //     : FileImage(image!) as ImageProvider,
          //   ),
          // ),
          Container(
            padding: EdgeInsets.all(8),
            height: 50,
            child: TextField(
                controller: username,
                decoration: const InputDecoration(hintText: 'Username')),
          ),
          Container(
            padding: EdgeInsets.all(8),
            height: 50,
            child: TextField(
                controller: email,
                decoration: const InputDecoration(hintText: 'Email')),
          ),
          Container(
            padding: EdgeInsets.all(8),
            height: 50,
            child: TextField(
                controller: password,
                decoration: const InputDecoration(hintText: 'Password')),
          ),
        ],
      ),
    );
  }
}
