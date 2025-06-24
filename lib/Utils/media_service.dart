import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsee/Model/loader.dart';
import 'package:image_cropper/image_cropper.dart';

class MediaService {
  /* 
@author         :   ganeshkumar.b    14/05/2025
@description    :   getLocation function use GeoLocator Plugin to capture current coordinates
@props          :   BuildContext
@return data     :   Current Cooridnate like latitude and longitude value returned
 */

  Future<Position> getLocation(BuildContext context) async {
    try {
      LocationPermission permissionstatus;
      Position gelocationdata;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const LoaderView(),
      );

      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permissionstatus = await Geolocator.checkPermission();
      print("Geolocator.checkPermission(): $permissionstatus");
      if (permissionstatus == LocationPermission.denied) {
        permissionstatus = await Geolocator.requestPermission();
        if (permissionstatus == LocationPermission.denied) {
          throw Exception('Location services are disabled.');
        }
      }

      if (permissionstatus == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }

      gelocationdata = await Geolocator.getCurrentPosition();
      print("gelocationdata: $gelocationdata");

      return gelocationdata;
    } catch (error) {
      rethrow;
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss the loader
      }
    }
  }

  /* 
  @author         :   ganeshkumar.b    13/05/2025
  @description    :   Picking image from device and crop the image file and return the bytes data
  @props          :   BuildContext
  @return data     :   bytes(Unit8List) data return;
  */

  Future<Uint8List?> pickimagefromgallery(context) async {
    try {
      final imagepicker = ImagePicker();
      final pickedFile = await imagepicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null && context.mounted) {
        final cropperdata = await cropper(context, pickedFile.path);
        print("croppedFileData: $cropperdata");
        final Uint8List croppedFileData = cropperdata!;
        return croppedFileData;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Picking From Gallery is failed")));
      return null;
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
      return null;
    }
  }

  /* 
  @author         :   ganeshkumar.b    14/05/2025
  @description    :   File Picking Plugin used pick the file like pdf, jpg, png, etc., file extensions and return the result.
  @return data     :   return FilePickerResult object data
  */
  Future<FilePickerResult?> filePicker() async {
    FilePickerResult? pdfBytes = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pdfBytes != null) {
      return pdfBytes;
    }
    return null;
  }

  /* 
  @author         :   ganeshkumar.b    14/05/2025
  @description    :   Cropper function used to crop the image pick from camera or gallery.
  @props          :   BuildContext, XFile path
  @return data    :   return Unit8List byte data
  */
  Future<Uint8List?> cropper(context, filepath) async {
    try {
      Uint8List? croppedImage;
      double screenwidth = MediaQuery.of(context).size.width;
      double screenheight = MediaQuery.of(context).size.height;

      final intwidth = (screenwidth * 0.5).round();
      final intheight = (screenheight * 0.5).round();
      print("cropper function called is here");
      final cropdata = await ImageCropper().cropImage(
        sourcePath: filepath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: const Color.fromRGBO(255, 255, 255, 1),
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPresetCustom(),
            ],
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: CropperSize(width: intwidth, height: intheight),
          ),
        ],
      );
      croppedImage = await cropdata?.readAsBytes();
      print("cropdata-imageBytes $croppedImage");
      return (croppedImage != null) ? croppedImage : null;
    } catch (error) {
      print("cropper error paster is here: $error");
      return null;
    }
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
