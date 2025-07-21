import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/api/api_client.dart';

/*
  @author     : akshayaa.p
  @date       : 17/07/2025
  @desc       : Downloads a PDF file from a remote URL and opens it in the PDF viewer. 
                Shows a loading dialog during the download process. On successful download, 
                navigates to PdfViewerPage with the local file path. On failure, displays an error dialog.
  @params     : {remoteFilePath}: The URL of the PDF to download.
                {fileName}: The desired name for the saved PDF file.
                {dirPath}: This is the directory where the downloded file get saved.
*/

Future<Response> downloadPDF({
  required String remoteFilePath,
  required String fileName,
  required String dirPath,
  void Function(String path)? downloadedFilePath,
}) async {
  try {
    final filePath =
        dirPath.endsWith('/') ? '$dirPath$fileName' : '$dirPath/$fileName';

    final response = await ApiClient().getDio().download(
      remoteFilePath,
      filePath,
      options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}),
      onReceiveProgress: (received, total) {
        if (AppConstants.SHOW_LOG && total > 0) {
          final percent = (received / total * 100).toStringAsFixed(1);
          // CustomLogUtil.print('Download progress: $percent%', AppConstants.SHOW_LOG);
        }
      },
    );
    downloadedFilePath!(filePath);
    return response;
  } catch (e) {
    rethrow;
  }
}
