import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_event.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_state.dart';
import 'package:newsee/feature/documentupload/presentation/widget/document_list.dart';

class DocumentPage extends StatefulWidget {
  final String proposalnumber;

  const DocumentPage({super.key, required this.proposalnumber});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  late final DocumentBloc _documentBloc;

  @override
  void initState() {
    super.initState();
    _documentBloc = DocumentBloc(mediaService: MediaService());

    _documentBloc.add(
      FetchDocumentsEvent(proposalNumber: widget.proposalnumber),
    );
  }

  @override
  void dispose() {
    _documentBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DocumentBloc>.value(
      value: _documentBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Documents Upload'),
          backgroundColor: Colors.grey[100],
        ),
        body: BlocListener<DocumentBloc, DocumentState>(
          listenWhen:
              (prev, curr) =>
                  prev.fetchStatus != curr.fetchStatus &&
                  curr.fetchStatus != SubmitStatus.loading,
          listener: (context, state) {
            if (state.uploadMessage.isNotEmpty) {
              final color = Colors.black;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.uploadMessage),
                  backgroundColor: color,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: BlocBuilder<DocumentBloc, DocumentState>(
            builder: (context, state) {
              return SizedBox.expand(
                child: Stack(
                  children: [
                    // _buildBody(state),
                    Positioned.fill(child: _buildBody(state)),
                    // if (state.isUploading)
                    //   const LoadingOverlay(message: "Uploading document..."),
                    if (state.fetchStatus == SubmitStatus.loading)
                      const LoadingOverlay(message: "Please wait..."),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(DocumentState state) {
    return Container(
      color: Colors.grey[100],
      child: const SingleChildScrollView(
        child: Column(children: [DocumentList()]),
      ),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({super.key, this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
