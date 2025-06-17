import 'package:flutter/material.dart';

/*
@author : Gayathri.b       27/05/2025
@description : Displays a circular progress indicator with a percentage value in the center.
         When the progress reaches 100%, a green checkmark icon is shown instead of the percentage.

 */

class ProgressBarExample extends StatelessWidget {
  // define the progressValue
  // total
  // Math.round(state.total / state.current)
  /*
  class DownloadProgressState{

    double? downloadedPercentage;


  }
*/
  final double progressValue;
  ProgressBarExample({required this.progressValue});
  // downloadedPercentage

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Displays a circular progress indicator
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                  strokeWidth: 15,
                ),
              ),

              //  When the progress reaches 100%, a green checkmark icon is shown instead of the percentage.
              progressValue == 1.0
                  ? Icon(Icons.check_circle, size: 50, color: Colors.green)
                  :
                  // a percentage value in the center
                  Text(
                    "${(progressValue * 100).toInt()}%",

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
