import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_file_sourece_selector.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_image_viewer.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';

class DocumentList extends StatelessWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        final bloc = context.read<DocumentBloc>();

        // if (state.borrowerDocs.isEmpty) {
        //   return const Center(child: Text("No documents added yet."));
        // }

        if (state.borrowerDocs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.insert_drive_file, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  "No documents added yet.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                // Text("Document"),
                // Text("Add"),
                // Text("View"),
                // Text("Size"),
                // Text("Action"),
                Expanded(flex: 4, child: Text("Document")),
                Expanded(flex: 1, child: Text("Add")),
                Expanded(flex: 1, child: Text("View")),
                Expanded(flex: 1, child: Text("Size")),
                Expanded(flex: 1, child: Text("Action")),
              ],
            ),
            const Divider(),
            ...state.borrowerDocs.map((doc) {
              final index = state.borrowerDocs.indexOf(doc);

              return Row(
                children: [
                  Expanded(flex: 4, child: Text(doc.prdDocDesc)),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed:
                        bloc.disableBtn
                            ? null
                            : () => showFileSourceSelector(
                              context,
                              doc.imgs.length,
                              doc.prdDocDesc,
                            ),
                    // : () => bloc.add(AttachFileEvent(index)),
                  ),
                  Row(
                    children: [
                      Text('${doc.imgs.length}'),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed:
                            // () => bloc.add(ViewImageEvent(index, doc.imgs)),
                            () => showFileViewerDialog(context, doc.imgs),
                      ),
                    ],
                  ),
                  Text(doc.imgs.isNotEmpty ? '${doc.imgs[0].size} MB' : '0 MB'),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed:
                        bloc.disableBtn
                            ? null
                            : () => bloc.add(DeleteDocEvent(index, doc)),
                  ),
                ],
              );
            }).toList(),

            const SizedBox(height: 24),

            if (state.uploadBtn)
              ElevatedButton(
                onPressed: () => bloc.add(UploadDocumentsEvent()),
                child: const Text("Upload"),
              ),
          ],
        );
      },
    );
  }
}
