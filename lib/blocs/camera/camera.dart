import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/camera_view.dart';
import 'package:newsee/blocs/camera/camera_bloc.dart';
import 'package:newsee/blocs/camera/camera_event.dart';

class Camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // create: (_) => CameraBloc(),
      create: (_) => GetIt.instance.get<CameraBloc>()..add(CameraOpen()),
      child: CameraView(),
    );
  }
}
