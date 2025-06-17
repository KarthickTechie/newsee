import 'package:flutter/material.dart';
import 'package:newsee/widgets/progress_bar.dart';
import 'package:newsee/widgets/skeleton.dart';

class DownloadProgressWidget extends StatelessWidget {
  const DownloadProgressWidget({super.key, required this.downloadProgress});

  final double downloadProgress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.9,
                  maxHeight: constraints.maxHeight,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ProgressBarExample(
                        progressValue: downloadProgress,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLoader(height: 20),
                          const SizedBox(height: 8),
                          SkeletonLoader(height: 15, width: 80),
                          const SizedBox(height: 8),
                          SkeletonLoader(height: 15, width: 100),
                          const SizedBox(height: 8),
                          SkeletonLoader(height: 15),
                          const SizedBox(height: 8),
                          SkeletonLoader(height: 10, width: 110),
                          const SizedBox(height: 12),
                          Text(
                            downloadProgress == 1
                                ? 'Master Download Success'
                                : 'Downloading Master...',
                            style: const TextStyle(
                              color: Color.fromRGBO(214, 24, 24, 1),
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
