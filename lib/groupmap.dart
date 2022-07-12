import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:fireauth/services/globals.dart' as global;
import 'package:rxdart/rxdart.dart';

class Groupmap extends StatefulWidget {
  String groupid;
  double latitude;
  double longitude;
  Groupmap(
      {required this.groupid, required this.latitude, required this.longitude});

  @override
  State<Groupmap> createState() => _GroupmapState();
}

class _GroupmapState extends State<Groupmap> {
  double _value = 5.0;
  String _label = "adjust radius";
  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()}kms';
      markers.clear();
    });
    radius.add(value);
  }

  List<Marker> markers = [];
  BehaviorSubject<double> radius = BehaviorSubject();
  late Stream<List<DocumentSnapshot>> stream;
  late String groupid;
  @override
  void initState() {
    groupid = widget.groupid;
    final lat = widget.latitude;
    final long = widget.longitude;

    GeoFirePoint center =
        Geoflutterfire().point(latitude: lat, longitude: long);
    stream = radius.switchMap((rad) {
      return Geoflutterfire()
          .collection(
              collectionRef: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupid)
                  .collection('locations'))
          .within(
              center: center, radius: rad, field: 'position', strictMode: true);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.42796133580664, -122.085749655962),
            zoom: 14.4746,
          ),
          onMapCreated: _onmapcreated,
          markers: markers.toSet(),
        ),
        Column(children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.8),
          Slider(
              min: 1,
              max: 1000,
              divisions: 200,
              value: _value,
              label: _label,
              activeColor: Colors.blue,
              inactiveColor: Colors.blue.withOpacity(0.2),
              onChanged: (double value) => changed(value)),
        ])
      ],
    ));
  }

  void _onmapcreated(GoogleMapController controller) async {
    final location = Location.instance;

    location.onLocationChanged.listen((l) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15)));
      GeoFirePoint mylocation = Geoflutterfire()
          .point(latitude: l.latitude!, longitude: l.longitude!);
      dbadd(mylocation);
    });
    stream.listen((List<DocumentSnapshot> documentList) {
      _updateMarkers(documentList);
    });
  }

  void dbadd(GeoFirePoint mylocation) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupid)
        .collection('locations')
        .doc(global.ID)
        .set({'name': global.name, 'position': mylocation.data});
  }

  void _updateMarkers(List<DocumentSnapshot<Object?>> documentList) {
    markers.clear();
    documentList.forEach((document) {
      final GeoPoint point = document['position']['geopoint'];
      _addmarker(point.latitude, point.longitude, document['name']);
    });
    setState(() {});
  }

  void _addmarker(double latitude, double longitude, String document) {
    print("kokokoko${markers}");
    markers.add(Marker(
        position: LatLng(latitude, longitude),
        markerId: MarkerId(document),
        infoWindow: InfoWindow(title: document)));
  }
}
