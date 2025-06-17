import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_state.dart';
import 'package:newsee/routes/app_routes.dart';
import 'package:newsee/widgets/custom_loading.dart';

class RouterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalLoadingBloc(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: BlocBuilder<GlobalLoadingBloc, GlobalLoadingState>(
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center, // Non-directional alignment
              children: [
                MaterialApp.router(
                  routerConfig: routes,
                  debugShowCheckedModeBanner: false,
                ),
                if (state.isLoading)
                  Center(child: CustomLoading(message: state.message)),
              ],
            );
          },
        ),
      ),
    );
  }
}
