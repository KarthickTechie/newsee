import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LatLongButtonWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final bool? isloading;
  final VoidCallback onpressed;

  const LatLongButtonWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onpressed,
    required this.isloading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // 60% for lat/long
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latitude: $latitude', style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text('Longitude: $longitude', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          // 40% for button
          Expanded(
            flex: 2,
            child: Center(
              child: ElevatedButton(
                onPressed: () {},
                child:
                    isloading == true
                        ? CircularProgressIndicator()
                        : Text('Fetch Location'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
