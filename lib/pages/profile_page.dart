import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Model/image_capture_dialog.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/Utils/pdf_viewer.dart';
import 'package:newsee/feature/saveprofilepicture/profilepicturebloc/saveprofilepicture_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Uint8List? profilebytes;
  Position? geoPosition;

  final getit = GetIt.instance<MediaService>();

  /* 
  @author         :   ganeshkumar.b   12/05/2025
  @description    :   this function navigate camera page and return the data
  @props          :   BuildContext
  return value    :   it retun the bytes(Unit8List) data
  */
  Future<Uint8List?> onCameraTap(BuildContext context) async {
    final curposition = await getit.getLocation(context);
    setState(() {
      geoPosition = curposition;
    });
    print("curposition: $curposition");
    final getprofileData = await context.pushNamed<Uint8List>("camera");
    if (getprofileData != null) {
      return getprofileData;
    } else {
      return null;
    }
  }

  /* 
  @author         :   ganeshkumar.b   12/05/2025
  @description    :   this function call image picker plugin and access gallery and return the image data
  @props          :   BuildContext
  return value    :   it retun the bytes(Unit8List) data
  */
  Future<Uint8List?> onGalleryTap(BuildContext context) async {
    // final galleyImageBytes = await pickimagefromgallery(context);
    final galleyImageBytes = await getit.pickimagefromgallery(context);
    return galleyImageBytes!;
  }

  onFileTap(BuildContext context) async {
    // final fileBytes = await filePicker();
    final fileBytes = await getit.filePicker();
    print("fileBytes: $fileBytes");
    if (fileBytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerFromBytes(filedata: fileBytes),
        ),
      );
    }
  }

  cancel(BuildContext context) {
    return "cancel string";
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = GetIt.instance<SaveProfilePictureBloc>();

    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return BlocProvider.value(
      value: profileBloc,
      child: Scaffold(
        appBar: AppBar(
          // actionsPadding: EdgeInsets.fromLTRB(0, 0, (screenwidth * 0.1), 0),
          // actions:
          //   <Widget>[
          //     Container(
          //       height: 40,
          //       width: 40,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10)
          //       ),
          //       child: Center(
          //         child: Ink(
          //           decoration: ShapeDecoration(
          //             color: Colors.lightBlue,
          //             shape: CircleBorder()
          //           ),
          //           child:  IconButton(
          //             icon: const Icon(Icons.cancel),
          //             onPressed: () => {
          //               // context.read<SaveProfilePictureBloc>().add(
          //               //   ProilePictureSaveEvent(
          //               //     profilebytes!
          //               //   )
          //               // ),
          //               context.pop()
          //               // context.goNamed('newlead')
          //             },
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          title: Text('Profile Picture', style: TextStyle(color: Colors.white)),
        ),
        body: BlocBuilder<SaveProfilePictureBloc, ProfilPictureState>(
          builder: (context, state) {
            final image = state.profilepicturedetails?.imageData;
            if (image != null) {
              profilebytes = image;
            }
            return SizedBox(
              child: Column(
                children: [
                  Center(
                    child:
                        profilebytes != null
                            ? Image.memory(
                              profilebytes!,
                              width: screenwidth * 0.8,
                              height: screenheight * 0.6,
                            )
                            : Container(
                              width: screenwidth * 0.8,
                              height: screenheight * 0.6,
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 50),
                            ),
                  ),
                  Listener(
                    child:
                        (geoPosition != null && profilebytes != null)
                            ? Container(
                              padding: EdgeInsets.fromLTRB(
                                screenwidth * 0.1,
                                5,
                                screenwidth * 0.1,
                                5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.amber,
                                    ),
                                    child: Row(
                                      children: [
                                        Text("lat: "),
                                        Text(
                                          (geoPosition?.latitude).toString(),
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.amber,
                                    ),
                                    child: Row(
                                      children: [
                                        Text("long: "),
                                        Text(
                                          (geoPosition?.longitude).toString(),
                                          style: TextStyle(
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: (screenheight * 0.2),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final List<FilePickingOptionList> actions = [
                            FilePickingOptionList(
                              title: "CAMERA",
                              icon: Icons.linked_camera,
                            ),
                            FilePickingOptionList(
                              title: "GALLERY",
                              icon: Icons.satellite_rounded,
                            ),
                            FilePickingOptionList(
                              title: "FILE",
                              icon: Icons.file_open,
                            ),
                            FilePickingOptionList(
                              title: "CANCEL",
                              icon: Icons.cancel,
                            ),
                          ];
                          final result = await showMediaPickerActionSheet(
                            context: context,
                            actions: actions,
                          );
                          if (result != null && context.mounted) {
                            if (result == "CAMERA") {
                              final getimage = await onCameraTap(context);
                              // if (getimage != null) {
                              context.read<SaveProfilePictureBloc>().add(
                                ProilePictureSaveEvent(getimage!),
                              );
                              // }
                            } else if (result == "GALLERY") {
                              final getimage = await onGalleryTap(context);
                              context.read<SaveProfilePictureBloc>().add(
                                ProilePictureSaveEvent(getimage!),
                              );
                            } else if (result == "FILE") {
                              await onFileTap(context);
                            }
                          }
                        },
                        child: Text("Captrue Image"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
