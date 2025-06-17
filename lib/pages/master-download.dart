import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/blocs/progress/progress_bloc.dart';
import 'package:newsee/widgets/download_progress_widget.dart';
import 'package:newsee/widgets/skeleton.dart';
import '../widgets/progress_bar.dart';

/*
@author : Gayathri.b    19/05/2025
@description : Displays a download screen UI with a progress bar and skeleton loaders,
             simulating content loading for "Download Master".





 */

class MasterDownload extends StatelessWidget {
  //customaized with and height

  @override
  Widget build(BuildContext context) {
    final double scrwidth = MediaQuery.of(context).size.width;
    final double scrheight = MediaQuery.of(context).size.height;

    return BlocProvider<ProgressBloc>(
      create: (context) => ProgressBloc()..add(ProgressInit()),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: BlocListener<ProgressBloc, ProgressState>(
          listener: (context, state) {
            print('current progress => ${state.downloadProgress}');
            context.read<ProgressBloc>().add(Progressing());
          },
          child: BlocBuilder<ProgressBloc, ProgressState>(
            builder: (context, state) {
              return DownloadProgressWidget(
                downloadProgress: state.downloadProgress,
              );
            },
          ),
        ),
      ),
    );
  }
}
