import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsCard extends StatefulWidget {
  final LatLng location;

  const GoogleMapsCard({super.key, required this.location});

  @override
  State<GoogleMapsCard> createState() => _GoogleMapsCardState();
}

class _GoogleMapsCardState extends State<GoogleMapsCard> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () async {
      final controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: widget.location, zoom: 18),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Use 80% of screen width and height, adjust as needed
    final cardWidth = screenWidth * 0.85;
    final cardHeight = screenHeight * 0.55;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Location of Farm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.cancel_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),
                ),

                // Google Map
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: widget.location,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('dynamic_marker'),
                          position: widget.location,
                          infoWindow: InfoWindow(
                            title: 'Current Location',
                            snippet:
                                'You are here.${widget.location.latitude},${widget.location.longitude}',
                          ),
                        ),
                      },
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: false,
                      liteModeEnabled: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
