import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/download_util.dart';
import 'package:newsee/feature/pdf_viewer/presentation/pages/pdf_viewer_page.dart';
import 'package:newsee/widgets/loader.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:path_provider/path_provider.dart';

/*
  @author     : akshayaa.p
  @date       : 16/07/2025
  @desc       : Stateless widget for CIC Check screen.
                - Displays Applicant and Co-Applicant CIBIL/CRIF check options.
                - Results toggle between "Check" and "View".
*/

class CicCheckPage extends StatelessWidget {
  const CicCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> applicantCibilCheck = ValueNotifier(false);
    final ValueNotifier<bool> applicantCrifCheck = ValueNotifier(false);
    final ValueNotifier<bool> coApplicantCibilCheck = ValueNotifier(false);
    final ValueNotifier<bool> coApplicantCrifCheck = ValueNotifier(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CIC Check'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person, color: Colors.teal, size: 32),
                        SizedBox(width: 16),
                        Text(
                          AppConstants.appLabelApplicant,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: applicantCibilCheck,
                      builder: (context, cibilChecked, _) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: applicantCrifCheck,
                          builder: (context, crifChecked, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (!cibilChecked) {
                                      presentLoading(
                                        context,
                                        AppConstants.creatingCibil,
                                      );
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );
                                      dismissLoading(context);
                                      applicantCibilCheck.value = true;
                                    } else {
                                      try {
                                        presentLoading(
                                          context,
                                          AppConstants.downloadingCibil,
                                        );
                                        final dir =
                                            await getTemporaryDirectory();
                                        final localPath = dir.path;

                                        await downloadPDF(
                                          remoteFilePath:
                                              AppConstants.remoteUrlCibilReport,
                                          fileName:
                                              AppConstants
                                                  .applicantCibilReportFileName,
                                          dirPath: localPath,
                                          downloadedFilePath: (String path) {
                                            dismissLoading(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => PdfViewerPage(
                                                      path: path,
                                                    ),
                                              ),
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        dismissLoading(context);
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) => SysmoAlert(
                                                message:
                                                    AppConstants
                                                        .FAILED_TO_LOAD_PDF_MESSAGE,
                                                icon: Icons.error_outline,
                                                iconColor: Colors.red,
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                buttonText: AppConstants.OK,
                                                onButtonPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      3,
                                      9,
                                      110,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        cibilChecked
                                            ? Icons.picture_as_pdf
                                            : Icons.check,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cibilChecked
                                            ? 'View CIBIL'
                                            : 'Check CIBIL',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (!crifChecked) {
                                      presentLoading(
                                        context,
                                        AppConstants.creatingCrif,
                                      );
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );
                                      dismissLoading(context);
                                      applicantCrifCheck.value = true;
                                    } else {
                                      try {
                                        presentLoading(
                                          context,
                                          AppConstants.downloadingCrif,
                                        );
                                        final dir =
                                            await getTemporaryDirectory();
                                        final localPath = dir.path;

                                        await downloadPDF(
                                          remoteFilePath:
                                              AppConstants.remoteUrlCrifReport,
                                          fileName:
                                              AppConstants
                                                  .applicantCrifReportFileName,
                                          dirPath: localPath,
                                          downloadedFilePath: (String path) {
                                            dismissLoading(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => PdfViewerPage(
                                                      path: path,
                                                    ),
                                              ),
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        dismissLoading(context);
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) => SysmoAlert(
                                                message:
                                                    AppConstants
                                                        .FAILED_TO_LOAD_PDF_MESSAGE,
                                                icon: Icons.error_outline,
                                                iconColor: Colors.red,
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                buttonText: AppConstants.OK,
                                                onButtonPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                        );
                                      }
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      3,
                                      9,
                                      110,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        crifChecked
                                            ? Icons.picture_as_pdf
                                            : Icons.check,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        crifChecked
                                            ? 'View CRIF'
                                            : 'Check CRIF',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.group, color: Colors.teal, size: 32),
                        SizedBox(width: 16),
                        Text(
                          AppConstants.appLabelCoApplicant,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<bool>(
                      valueListenable: coApplicantCibilCheck,
                      builder: (context, cibilChecked, _) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: coApplicantCrifCheck,
                          builder: (context, crifChecked, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (!cibilChecked) {
                                      presentLoading(
                                        context,
                                        AppConstants.creatingCibil,
                                      );
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );
                                      dismissLoading(context);
                                      coApplicantCibilCheck.value = true;
                                    } else {
                                      try {
                                        presentLoading(
                                          context,
                                          AppConstants.downloadingCibil,
                                        );
                                        final dir =
                                            await getTemporaryDirectory();
                                        final localPath = dir.path;

                                        await downloadPDF(
                                          remoteFilePath:
                                              AppConstants.remoteUrlCibilReport,
                                          fileName:
                                              AppConstants
                                                  .coappCibilReportFileName,
                                          dirPath: localPath,
                                          downloadedFilePath: (String path) {
                                            dismissLoading(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => PdfViewerPage(
                                                      path: path,
                                                    ),
                                              ),
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        dismissLoading(context);
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) => SysmoAlert(
                                                message:
                                                    AppConstants
                                                        .FAILED_TO_LOAD_PDF_MESSAGE,
                                                icon: Icons.error_outline,
                                                iconColor: Colors.red,
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                buttonText: AppConstants.OK,
                                                onButtonPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                        );
                                      }
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      3,
                                      9,
                                      110,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        cibilChecked
                                            ? Icons.picture_as_pdf
                                            : Icons.check,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cibilChecked
                                            ? 'View CIBIL'
                                            : 'Check CIBIL',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (!crifChecked) {
                                      presentLoading(
                                        context,
                                        AppConstants.creatingCrif,
                                      );
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );
                                      dismissLoading(context);
                                      coApplicantCrifCheck.value = true;
                                    } else {
                                      try {
                                        presentLoading(
                                          context,
                                          AppConstants.downloadingCrif,
                                        );
                                        final dir =
                                            await getTemporaryDirectory();
                                        final localPath = dir.path;

                                        await downloadPDF(
                                          remoteFilePath:
                                              AppConstants.remoteUrlCrifReport,
                                          fileName:
                                              AppConstants
                                                  .coappCrifReportFileName,
                                          dirPath: localPath,
                                          downloadedFilePath: (String path) {
                                            dismissLoading(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => PdfViewerPage(
                                                      path: path,
                                                    ),
                                              ),
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        dismissLoading(context);
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) => SysmoAlert(
                                                message:
                                                    AppConstants
                                                        .FAILED_TO_LOAD_PDF_MESSAGE,
                                                icon: Icons.error_outline,
                                                iconColor: Colors.red,
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                buttonText: AppConstants.OK,
                                                onButtonPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                              ),
                                        );
                                      }
                                    }
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      3,
                                      9,
                                      110,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        crifChecked
                                            ? Icons.picture_as_pdf
                                            : Icons.check,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        crifChecked
                                            ? 'View CRIF'
                                            : 'Check CRIF',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
