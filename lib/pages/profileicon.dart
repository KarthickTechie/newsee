import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/feature/saveprofilepicture/profilepicturebloc/saveprofilepicture_bloc.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = GetIt.instance<SaveProfilePictureBloc>();
    return BlocProvider.value(
      value: profileBloc,
      child: BlocBuilder<SaveProfilePictureBloc, ProfilPictureState>(
        builder: (context, state) {
          print("Stat.profilpice => ${state.status}");
          final image = state.profilepicturedetails?.imageData;
          return Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child:
                image != null
                    ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero, // Remove default padding
                        shape: const CircleBorder(), // Make button circular
                        minimumSize: const Size(
                          40,
                          40,
                        ), // Set button size to 40x40
                      ),
                      onPressed: () async {
                        await context.pushNamed(
                          'profile',
                          extra: {'imageBytes': image},
                        );
                      },
                      child: ClipOval(
                        child: Image.memory(
                          image,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    : Center(
                      child: Ink(
                        decoration: ShapeDecoration(
                          color: Colors.lightBlue,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.person),
                          onPressed: () async {
                            await context.pushNamed('profile');
                          },
                          color: Colors.white,
                        ),
                      ),
                    ),
          );
        },
      ),
    );
  }
}
