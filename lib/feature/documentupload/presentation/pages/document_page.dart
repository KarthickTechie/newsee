import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/widget/document_list.dart';
import 'package:newsee/feature/documentupload/presentation/widget/show_document_form_bottom_sheet.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<DocumentBloc>()..add(FetchDocTypesEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Documents Upload')),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(children: [DocumentList()]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDocumentFormBottomSheet(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
