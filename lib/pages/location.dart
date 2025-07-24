import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/widgets/latlongbutton.dart';

class Location extends StatefulWidget {
  @override
  State<Location> createState() => LocationState();
}

class LocationState extends State<Location> {
  Position? position;
  bool? isloading;
  @override
  Widget build(BuildContext context) {
    return LatLongButtonWidget(
      latitude: position?.latitude,
      longitude: position?.longitude,
      isloading: isloading,
      onpressed: () async {
        setState(() {
          isloading = true;
        });
        final curposition = await MediaService().getLocation(context);
        setState(() {
          isloading = false;
          position = curposition.position;
        });
      },
    );
  }
}
