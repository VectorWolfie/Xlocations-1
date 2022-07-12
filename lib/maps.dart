import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class map extends StatefulWidget {
  double latitude;
  double longitude;
  map({required this.latitude, required this.longitude});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  // GoogleMapController? _cntlr;
  CameraPosition cp = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  Set<Marker> markerlist = {};
  // @override
  // void dispose() {
  //   if (_cntlr != null) {
  //     _cntlr!.dispose();
  //   }
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  void initState() {
    // TODO: implement initState

    if (widget.latitude != null && widget.longitude != null) {
      print("monkey monkey");
      markerlist.add(Marker(
          markerId: MarkerId('1'),
          position: LatLng(widget.latitude, widget.longitude)));

      setState(() {
        cp = CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.4746,
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              initialCameraPosition: cp,
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              markers: markerlist,
            )));
    // body: GoogleMap(markers: markerlist.toSet() , initialCameraPosition: _kGooglePlex,),
  }
}
