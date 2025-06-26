import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';

void confirmAndDeleteImage(
  BuildContext context,
  int docIndex, {
  int? imgIndex,
  String? checkFrom,
}) {
  try {
    // final bloc = context.read<DocumentBloc>();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
              imgIndex != null
                  ? 'Are you sure you want to delete this image?'
                  : 'Are you sure you want to delete all images in this document?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (checkFrom != null) {
                    Navigator.of(ctx).pop();
                  } else {
                    Navigator.of(ctx).pop();
                    context.read<DocumentBloc>().add(
                      DeleteDocEvent(docIndex: docIndex, imgIndex: imgIndex),
                    );
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  } catch (e) {
    print("showDeleteAlert: $e");
  }
}
