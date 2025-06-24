import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';

void showFileSourceSelector(BuildContext context, int index, String docName) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                context.read<DocumentBloc>().add(
                  AttachFileEvent(index, docName, source: FileSource.camera),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                context.read<DocumentBloc>().add(
                  AttachFileEvent(index, docName, source: FileSource.gallery),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Pick PDF File'),
              onTap: () {
                Navigator.pop(context);
                context.read<DocumentBloc>().add(
                  AttachFileEvent(index, docName, source: FileSource.pdf),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
