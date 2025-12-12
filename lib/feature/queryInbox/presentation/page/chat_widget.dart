import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flyer_chat_text_message/flyer_chat_text_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_cache/cross_cache.dart';
import 'package:flyer_chat_image_message/flyer_chat_image_message.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/queryInbox/presentation/page/pdf_viewer.dart';
import 'package:newsee/feature/queryInbox/presentation/page/bubble_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:shimmer/shimmer.dart';

class ChatWidget extends StatefulWidget {
  final String userName;
  final String queryType;
  final String queryId;
  final num proposalNo;
  final String status;
  const ChatWidget({
    super.key,
    required this.userName,
    required this.queryType,
    required this.queryId,
    required this.proposalNo,
    required this.status,
  });

  @override
  ChatWidgetState createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatWidget> {
  final _chatController = InMemoryChatController();
  final _crossCache = CrossCache();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> storedMessages = [];
  bool isLoadStaffMsg = true;

  @override
  void initState() {
    super.initState();
    // loadMessagesFromPrefs();
    // loadTextMessageFromAPI();
    // loadImagesFromAPI();
    loadEssentials();
  }

  String? globalLoadingBubbleId;
  loadEssentials() async {
    await loadTextMessageFromAPINew2();
    await loadImagesFromAPINew();

    // ---------------------------------------------
    // Rebuild UI safely AFTER all data is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          refreshChatList();
        });
      }
    });
  }

  Message? findMessageById(String id) {
    return _chatController.messages.firstWhere((m) => m.id == id);
  }

  Future<void> saveMessagesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> jsonMessages =
        storedMessages.map((msg) {
          final message = Map<String, dynamic>.from(msg);
          message["createdAt"] =
              (msg["createdAt"] as DateTime).toIso8601String();
          return jsonEncode(message);
        }).toList();

    await prefs.setStringList("chat${widget.queryId}", jsonMessages);
  }

  Future<void> loadMessagesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? jsonMessages = prefs.getStringList("chat${widget.queryId}");

    if (jsonMessages == null || jsonMessages.isEmpty) {
      // First time — Loading our predefined messages
      // storedMessages = initialMessages();
    } else {
      storedMessages =
          jsonMessages.map((jsonStr) {
            Map<String, dynamic> msg = jsonDecode(jsonStr);
            msg["createdAt"] = DateTime.parse(msg["createdAt"]);
            return msg;
          }).toList();
    }

    for (var msg in storedMessages) {
      if (msg["type"] == "text") {
        _chatController.insertMessage(
          TextMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            text: msg["text"],
          ),
        );
      } else if (msg["type"] == "image" &&
          msg["source"] != null &&
          msg["source"] != "") {
        _chatController.insertMessage(
          ImageMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            source: msg["source"],
            size: msg["size"],
          ),
        );
      }
    }

    setState(() {});
  }

  Future<File> compressImage(File file) async {
    final targetPath = "${file.path}_compressed.jpg";

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 70,
      format: CompressFormat.jpeg,
    );

    final compressedFile = File(targetPath)..writeAsBytesSync(compressedBytes!);

    print("Original: ${file.lengthSync() / 1024 / 1024} MB");
    print("Compressed: ${compressedFile.lengthSync() / 1024 / 1024} MB");

    return compressedFile;
  }

  bool _isMounted = true;

  @override
  void dispose() {
    _isMounted = false;
    _chatController.dispose();
    _scrollController.dispose();
    _crossCache.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.queryId), centerTitle: true),
      body: ChangeNotifierProvider.value(
        value: _scrollController,
        child: Chat(
          builders: Builders(
            composerBuilder: (context) {
              return widget.status == "Closed"
                  ? buildDisabledComposer()
                  : const Composer();
            },
            chatAnimatedListBuilder: (context, itemBuilder) {
              return ChatAnimatedList(
                scrollController: _scrollController,
                itemBuilder: itemBuilder,
                shouldScrollToEndWhenAtBottom: false,
              );
            },

            textMessageBuilder: (
              context,
              message,
              index, {
              required bool isSentByMe,
              MessageGroupStatus? groupStatus,
            }) {
              final isLoading = message.metadata?["loading"] == true;

              if (isLoading) {
                return Align(
                  alignment:
                      isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      padding: const EdgeInsets.all(14),
                      width: 140,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              }
              final meta = message.metadata;
              if (meta != null && meta["fileType"] != null) {
                final fileType = meta["fileType"];

                if (fileType == "image") {
                  return buildImageFileBubble(
                    message,
                    onTap: () {
                      print('here...tapped');
                      onFileTap(message);
                    },
                  );
                }
                if (fileType == "pdf") {
                  return buildPdfBubble(
                    message,
                    onTap: () {
                      onFileTap(message);
                      print('here...tapped');
                    },
                  );
                }
                if (fileType == "doc") {
                  return buildDocBubble(
                    message,
                    onTap: () {
                      onFileTap(message);
                      print('here...tapped');
                    },
                  );
                }
              }
              return Column(
                crossAxisAlignment:
                    isSentByMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  FlyerChatTextMessage(
                    message: message,
                    index: index,
                    showTime: false,
                    showStatus: true,
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "${message.createdAt.toString().split(' ')[0]} ${message.createdAt.toString().split(' ')[1].substring(0, 5)}",
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ],
              );
            },
            imageMessageBuilder:
                (
                  context,
                  message,
                  index, {
                  required bool isSentByMe,
                  MessageGroupStatus? groupStatus,
                }) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          child: InstaImageViewer(
                            child: Image.file(
                              File(message.source),
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: FlyerChatImageMessage(
                    message: message,
                    index: index,
                    showTime: true,
                    showStatus: true,
                  ),
                ),
          ),

          chatController: _chatController,
          currentUserId: 'user1',

          onMessageSend:
          // widget.status == "Closed"
          //     ? null
          //     :
          (text) {
            sendTextMessageToAPI(textMsg: text);
          },
          onAttachmentTap:
              // widget.status == "Closed"
              //     ? null
              //     :
              () => showAttachmentSheet(),

          resolveUser: (UserID id) async {
            if (id == 'user1') {
              return User(id: id, name: widget.userName);
            }
            return null;
          },
        ),
      ),
    );
  }

  // To load a text from API
  loadTextMessageFromAPI() async {
    try {
      print('came here');
      Dio dio = Dio();
      // dio.options.baseUrl = ApiConfig.BASE_URL_QUERY;
      dio.options
        ..baseUrl = ApiConfig.BASE_URL_QUERY
        ..connectTimeout = Duration(seconds: 20)
        ..receiveTimeout = Duration(seconds: 20);

      dio.options.headers = {
        'token': ApiConfig.AUTH_TOKEN,
        'deviceId': ApiConfig.DEVICE_ID,
        'userid': 'IOB3',
      };

      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );

      final endPoint = ApiConfig.GET_QUERY_DETAILS_TEXT;
      // for shimmer effect while loading
      final loadingId = "loading_${Random().nextInt(999999)}";
      _chatController.insertMessage(
        TextMessage(
          id: loadingId,
          authorId: "user2",
          createdAt: DateTime.now(),
          text: "",
          metadata: {"loading": true},
        ),
      );
      final response = await dio.post(
        endPoint,
        data: {
          "queryId": widget.queryId,
          "propNo": widget.proposalNo,
          "recipient": "IOB3",
          "TOCc": "To",
        },
      );
      final responseData = response.data;
      final isSuccess = responseData['success'] == true;

      if (isSuccess) {
        print('here...response..$responseData');
        Map<String, dynamic> textData = {
          "id": '${Random().nextInt(100000)}',
          "authorId": 'user2',
          "createdAt": DateTime.fromMillisecondsSinceEpoch(
            responseData['requestTime'],
          ),
          "text": responseData['QueryDescription'],
          "type": "text",
          "source": "",
          "size": "",
        };
        final msg = findMessageById(loadingId);
        if (msg != null) {
          _chatController.removeMessage(msg);
        }

        setState(() {
          storedMessages.add(textData);
          final textMessage = TextMessage(
            id: textData['id'],
            authorId: textData['authorId'],
            createdAt: textData['createdAt'],
            text: textData['text'],
          );
          _chatController.insertMessage(textMessage);
          // saveMessagesToPrefs();
        });
        refreshChatList();

        print('success bro');
      } else {
        final errorMessage = responseData['ErrorMessage'] ?? "Unknown error";
        print('Error: $errorMessage');
        safeShowSnack('Technical Issue occurred, please try again later.');
      }
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      print('here..${failure.message}');
    } catch (error, st) {
      print(" QueryResponseHandler Exception: $error\n$st");
    }
  }

  sendTextMessageToAPI({required String textMsg}) async {
    try {
      print('came here');
      Dio dio = Dio();
      dio.options
        ..baseUrl = ApiConfig.BASE_URL_QUERY
        ..connectTimeout = Duration(seconds: 20)
        ..receiveTimeout = Duration(seconds: 20);

      dio.options.headers = {
        'token': ApiConfig.AUTH_TOKEN,
        'deviceId': ApiConfig.DEVICE_ID,
        'userid': 'IOB3',
      };

      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );

      final endPoint = ApiConfig.SEND_TEXTMSG_RESPONSE;
      // for shimmer effect while loading
      final loadingId = "loading_${Random().nextInt(999999)}";

      _chatController.insertMessage(
        TextMessage(
          id: loadingId,
          authorId: "user1",
          createdAt: DateTime.now(),
          text: "",
          metadata: {"loading": true},
        ),
      );
      final response = await dio.post(
        endPoint,
        data: {
          "queryId": widget.queryId,
          "propNo": widget.proposalNo,
          "recipient": "IOB3",
          "response": textMsg,
        },
      );

      print('here..$response');
      final responseData = response.data;
      final isSuccess = responseData['success'] == true;
      print('here...$isSuccess');
      if (isSuccess) {
        Map<String, dynamic> textData = {
          "id": '${Random().nextInt(100000)}',
          "authorId": 'user1',
          "createdAt": DateTime.now().toUtc(),
          "text": textMsg,
          "type": "text",
          "source": "",
          "size": "",
        };
        // final result = QueryResponseModal.fromJson(responseData);
        final msg = findMessageById(loadingId);
        if (msg != null) {
          _chatController.removeMessage(msg);
        }
        setState(() {
          storedMessages.add(textData);
          final textMessage = TextMessage(
            id: textData['id'],
            authorId: textData['authorId'],
            createdAt: textData['createdAt'],
            text: textData['text'],
          );
          _chatController.insertMessage(textMessage);
          saveMessagesToPrefs();
        });

        print('success bro');
      } else {
        final errorMessage = responseData['ErrorMessage'] ?? "Unknown error";
        print('Error: $errorMessage');
        safeShowSnack('Technical Issue occurred, please try again later.');
      }
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      print('here..${failure.message}');
    } catch (error, st) {
      print(" QueryResponseHandler Exception: $error\n$st");
    }
  }

  sendDocumentsToAPI({
    required File file,
    required String imgPath,
    required int size,
  }) async {
    try {
      print('came here');
      final ext = file.path.split('.').last.toLowerCase();
      final fileType = getFileType(ext); // image/pdf/doc
      Dio dio = Dio();
      // dio.options.baseUrl = ApiConfig.BASE_URL_QUERY;
      dio.options
        ..baseUrl = ApiConfig.BASE_URL_QUERY
        ..connectTimeout = Duration(seconds: 50)
        ..receiveTimeout = Duration(seconds: 50);

      dio.options.headers = {
        "Content-Type": "multipart/form-data",
        'token': ApiConfig.AUTH_TOKEN,
        'deviceId': ApiConfig.DEVICE_ID,
        'userid': 'IOB3',
      };

      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
      final originalName = file.path.split('/').last;
      final safeName = getSafeFileName(originalName);
      FormData formData = FormData.fromMap({
        "userid": "IOB3",
        "timestamp": DateTime.now().toIso8601String(),
        "token": ApiConfig.AUTH_TOKEN,
        "queryId": widget.queryId,
        "propNo": widget.proposalNo,
        "deviceId": ApiConfig.DEVICE_ID,

        "file": await MultipartFile.fromFile(file.path, filename: safeName),
      });

      // for shimmer effect while loading
      final loadingId = "loading_${Random().nextInt(999999)}";

      _chatController.insertMessage(
        TextMessage(
          id: loadingId,
          authorId: "user1",
          createdAt: DateTime.now(),
          text: "",
          metadata: {"loading": true},
        ),
      );

      final endPoint = ApiConfig.SEND_IMAGE_RESPONSE;

      final response = await dio.post(
        endPoint,
        data: formData,
        onSendProgress: (sent, total) {
          if (!mounted) return;
          if (total != -1) {
            int progress = ((sent / total) * 100).toInt();
            print("Progress: ${(sent / total * 100).toStringAsFixed(0)}%");
            safeShowSnack(
              fileType == "image"
                  ? "Uploading image.... $progress%"
                  : "Uploading file... $progress%",
            );
          }
        },
      );
      hideSnackBar();

      print('here..$response');
      final responseData = response.data;
      final isSuccess = responseData['Success'] == true;
      print('here...$isSuccess');
      if (isSuccess) {
        final msg = findMessageById(loadingId);
        if (msg != null) {
          _chatController.removeMessage(msg);
        }

        final newId = '${Random().nextInt(100000)}';
        final now = DateTime.now();

        if (fileType == "image") {
          Map<String, dynamic> imageData = {
            "id": newId,
            "authorId": "user1",
            "createdAt": now,
            "text": "",
            "type": "image",
            "source": imgPath,
            "size": size,
          };

          storedMessages.add(imageData);

          _chatController.insertMessage(
            ImageMessage(
              id: newId,
              authorId: "user1",
              createdAt: now,
              source: imgPath,
              size: size,
            ),
          );
        } else {
          final fileName = file.path.split("/").last;

          Map<String, dynamic> fileData = {
            "id": newId,
            "authorId": "user1",
            "createdAt": now,
            "text": fileName,
            "type": "file",
            "metadata": {
              "fileType": fileType,
              "fileName": fileName,
              "rowId": responseData["responseData"]["rowId"],
              "createdBy": "IOB3",
            },
          };

          storedMessages.add(fileData);

          _chatController.insertMessage(
            TextMessage(
              id: newId,
              authorId: "user1",
              createdAt: now,
              text: fileName,
              metadata: fileData["metadata"],
            ),
          );
        }

        safeShowSnack("Attachments Uploaded");
        Future.delayed(Duration(seconds: 1), () => hideSnackBar());

        saveMessagesToPrefs();
        print('success bro');
      } else {
        final errorMessage = responseData['ErrorMessage'] ?? "Unknown error";
        print('Error: $errorMessage');
        safeShowSnack('Technical Issue occurred, please try again later.');
        final msg = findMessageById(loadingId);
        if (msg != null) {
          _chatController.removeMessage(msg);
        }
      }
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      print('here..${failure.message}');
    } catch (error, st) {
      print(" Image Uploading Exception: $error\n$st");
    }
  }

  void hideSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  loadImagesFromAPI() async {
    try {
      print('came here');
      Dio dio = Dio();

      dio.options
        ..baseUrl = ApiConfig.BASE_URL_QUERY
        ..connectTimeout = Duration(seconds: 50)
        ..receiveTimeout = Duration(seconds: 50);

      dio.options.headers = {
        'token': ApiConfig.AUTH_TOKEN,
        'deviceId': ApiConfig.DEVICE_ID,
        'userid': 'IOB3',
      };

      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );

      final endPoint = ApiConfig.GET_QUERYDETAILS_IMG;

      final response = await dio.post(
        endPoint,
        data: {"queryId": widget.queryId, "propNo": widget.proposalNo},
      );

      final responseData = response.data;
      final isSuccess = responseData['Success'] == true;

      if (!isSuccess) {
        print("Error: ${responseData['ErrorMessage']}");

        safeShowSnack('Technical Issue occurred, please try again later.');
        return;
      }

      print("success bro");

      List docs = responseData["responseData"]["uploadedDocuments"] ?? [];

      for (var doc in docs) {
        String fileName = doc["fileName"] ?? "";
        String createdBy = doc["createdBy"] ?? "";
        String createdOn = doc["createdOn"] ?? "";

        DateTime createdAt = DateTime.parse(createdOn.replaceAll(".0", ""));

        String authorId = (createdBy == "IOB3") ? "user1" : "user2";

        String type = getFileType(fileName);

        Map<String, dynamic> msgData = {
          "id": '${Random().nextInt(100000)}',
          "authorId": authorId,
          // "createdAt": createdAt,
          "createdAt": DateTime.fromMillisecondsSinceEpoch(doc["timeStamp"]),
          "text": fileName,
          "type": "file",
          "metadata": {
            "fileType": type,
            "fileName": fileName,
            "rowId": doc["rowId"],
            "createdBy": createdBy,
          },
        };

        storedMessages.add(msgData);
        File? cachedFile = await getCachedFile(doc["rowId"], fileName);

        if (cachedFile != null && type == "image") {
          _chatController.insertMessage(
            ImageMessage(
              id: msgData["id"],
              authorId: msgData["authorId"],
              createdAt: msgData["createdAt"],
              source: cachedFile.path,
              size: await cachedFile.length(),
            ),
          );

          // Update storedMessages so it doesn't show bubble again later
          msgData["type"] = "image";
          msgData["source"] = cachedFile.path;
          msgData["size"] = await cachedFile.length();
        } else {
          _chatController.insertMessage(
            TextMessage(
              id: msgData["id"],
              authorId: msgData["authorId"],
              createdAt: msgData["createdAt"],
              text: msgData["text"],
              metadata: msgData["metadata"],
            ),
          );
        }
      }

      // await saveMessagesToPrefs();
      refreshChatList();
    } catch (error, st) {
      print("Query Document details Exception: $error\n$st");
    }
  }

  String getFileType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();

    if (["jpg", "jpeg", "png", "webp"].contains(ext)) return "image";
    if (["pdf"].contains(ext)) return "pdf";
    if (["doc", "docx"].contains(ext)) return "doc";

    return "file";
  }

  // Future<void> onFileTap(TextMessage message) async {
  //   print('came here...${message.metadata!['fileName']}');

  //   final fileName = message.metadata!["fileName"];
  //   final rowId = message.metadata!["rowId"];
  //   final fileType = message.metadata!["fileType"];

  //   final cacheDir = await getTemporaryDirectory();
  //   final localFile = File("${cacheDir.path}/$rowId-$fileName");
  //   print('here...1');
  //   if (await localFile.exists()) {
  //     print("Loading from cache...");
  //     openFileViewer(localFile, fileType);
  //     return;
  //   }
  //   print('here...12');
  //   // Not cached → Fetch from API
  //   safeShowSnack("Fetching attachment...");
  //   print('here...13');
  //   try {
  //     Dio dio = Dio();
  //     dio.options.baseUrl = ApiConfig.BASE_URL_QUERY;
  //     dio.options
  //       ..connectTimeout = Duration(seconds: 20)
  //       ..receiveTimeout = Duration(seconds: 20);
  //     dio.options.headers = {
  //       'token': ApiConfig.AUTH_TOKEN,
  //       'deviceId': ApiConfig.DEVICE_ID,
  //       'userid': 'IOB3',
  //     };
  //     print('here...14');
  //     final response = await dio.post(
  //       ApiConfig.GET_SINGLEDOCUMENT_IMAGE,
  //       data: {"rowId": rowId, "propNo": widget.proposalNo},
  //     );
  //     print('here...15');

  //     if (!(response.data["Success"] ?? false)) {
  //       safeShowSnack("Error: Cannot fetch file");
  //       return;
  //     }

  //     final base64String = response.data["responseData"]["file"];
  //     final bytes = base64Decode(base64String);

  //     await localFile.writeAsBytes(bytes);
  //     print("Saved in cache: ${localFile.path}");

  //     _chatController.removeMessage(message);

  //     if (fileType == "image") {
  //       final imgMsg = ImageMessage(
  //         id: message.id,
  //         authorId: message.authorId,
  //         createdAt: message.createdAt,
  //         source: localFile.path,
  //         size: await localFile.length(),
  //       );
  //       setState(() {
  //         _chatController.insertMessage(imgMsg);
  //       });
  //     }

  //     for (var m in storedMessages) {
  //       if (m["id"] == message.id) {
  //         m["type"] = "image";
  //         m["source"] = localFile.path;
  //         m["size"] = await localFile.length();
  //       }
  //     }
  //     hideSnackBar();
  //     // await saveMessagesToPrefs();
  //     // refreshChatList();
  //     openFileViewer(localFile, fileType);
  //   } catch (e) {
  //     hideSnackBar();
  //     safeShowSnack("Failed to load file");
  //     print("File fetch error: $e");
  //   }
  // }
  Future<void> onFileTap(TextMessage message) async {
    final fileName = message.metadata!["fileName"];
    final rowId = message.metadata!["rowId"];
    final fileType = message.metadata!["fileType"];

    final cacheDir = await getTemporaryDirectory();
    final localFile = File("${cacheDir.path}/$rowId-$fileName");

    if (await localFile.exists()) {
      openFileViewer(localFile, fileType);
      return;
    }

    safeShowSnack("Fetching attachment...");

    try {
      Dio dio = Dio();
      dio.options.baseUrl = ApiConfig.BASE_URL_QUERY;
      dio.options.headers = {
        'token': ApiConfig.AUTH_TOKEN,
        'deviceId': ApiConfig.DEVICE_ID,
        'userid': 'IOB3',
      };

      final response = await dio.post(
        ApiConfig.GET_SINGLEDOCUMENT_IMAGE,
        data: {"rowId": rowId, "propNo": widget.proposalNo},
      );

      if (!(response.data["Success"] ?? false)) {
        safeShowSnack("Error fetching file");
        return;
      }

      final base64String = response.data["responseData"]["file"];
      final bytes = base64Decode(base64String);

      await localFile.writeAsBytes(bytes);

      final newMessage = ImageMessage(
        id: message.id,
        authorId: message.authorId,
        createdAt: message.createdAt,
        source: localFile.path,
        size: bytes.length,
      );

      await _chatController.updateMessage(message, newMessage);

      for (var m in storedMessages) {
        if (m["id"] == message.id) {
          m["type"] = "image";
          m["source"] = localFile.path;
          m["size"] = bytes.length;
        }
      }

      hideSnackBar();
      openFileViewer(localFile, fileType);
    } catch (e) {
      hideSnackBar();
      safeShowSnack("Failed to load file");
    }
  }

  void openFileViewer(File file, String fileType) {
    if (fileType == "image") {
      showDialog(
        context: context,
        builder:
            (_) => Dialog(
              backgroundColor: Colors.black87,
              insetPadding: EdgeInsets.zero,
              child: InstaImageViewer(
                child: Image.file(file, fit: BoxFit.contain),
              ),
            ),
      );
      return;
    }

    if (fileType == "pdf") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PdfViewerScreen(file)),
      );
      return;
    }

    if (fileType == "doc") {
      safeShowSnack("DOC preview not supported yet");
      return;
    }
  }

  void refreshChatList() {
    storedMessages.sort((a, b) {
      DateTime t1 = a["createdAt"];
      DateTime t2 = b["createdAt"];
      return t1.compareTo(t2);
    });

    clearChatController();

    for (var msg in storedMessages) {
      if (msg["type"] == "text") {
        _chatController.insertMessage(
          TextMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            text: msg["text"],
          ),
        );
      } else if (msg["type"] == "image") {
        _chatController.insertMessage(
          ImageMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            source: msg["source"],
            size: msg["size"],
          ),
        );
      } else if (msg["type"] == "file" ||
          msg["type"] == "pdf" ||
          msg["type"] == "doc") {
        _chatController.insertMessage(
          TextMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            text: msg["text"],
            metadata: msg["metadata"],
          ),
        );
      }
    }
  }

  void clearChatController() {
    final List<Message> current = List.from(_chatController.messages);
    for (var msg in current) {
      _chatController.removeMessage(msg);
    }
  }

  Future<File?> getCachedFile(String rowId, String fileName) async {
    final cacheDir = await getTemporaryDirectory();
    final file = File("${cacheDir.path}/$rowId-$fileName");

    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Widget buildDisabledComposer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.all(10),
        color: Colors.grey.shade300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Text(
              "This query is closed by ${widget.userName}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // void safeShowSnack(String msg) {
  //   if (!mounted) return;

  //   // Delay 1 frame to ensure context is valid
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context)
  //       ..removeCurrentSnackBar()
  //       ..showSnackBar(SnackBar(content: Text(msg)));
  //   });
  // }
  Future<void> safeShowSnack(String msg) async {
    if (!mounted) return;

    await Future.delayed(Duration(milliseconds: 50));

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(duration: Duration(seconds: 10), content: Text(msg)),
      );
  }

  // void safeShowSnack(String message) {
  //   if (!_isMounted) return;
  //   ScaffoldMessenger.of(context)
  //     ..removeCurrentSnackBar()
  //     ..showSnackBar(
  //       SnackBar(duration: const Duration(minutes: 10), content: Text(message)),
  //     );
  // }

  loadImagesFromAPINew() async {
    try {
      print('came here');
      Dio dio = Dio();

      dio.options
        ..baseUrl = ApiConfig.BASE_URL_QUERY
        ..connectTimeout = Duration(seconds: 50)
        ..receiveTimeout = Duration(seconds: 50);

      dio.options.headers = {
        'token': ApiConfig.AUTH_TOKEN,
        'deviceId': ApiConfig.DEVICE_ID,
        'userid': 'IOB3',
      };

      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );

      final endPoint = ApiConfig.GET_QUERYDETAILS_IMG;

      final response = await dio.post(
        endPoint,
        data: {"queryId": widget.queryId, "propNo": widget.proposalNo},
      );

      final responseData = response.data;
      final isSuccess = responseData['Success'] == true;

      if (!isSuccess) {
        print("Error: ${responseData['ErrorMessage']}");
        // safeShowSnack('Technical Issue occurred, please try again later.');
        return;
      }

      print("success bro");

      List docs = responseData["responseData"]["uploadedDocuments"] ?? [];

      for (var doc in docs) {
        String fileName = doc["fileName"] ?? "";
        String createdBy = doc["createdBy"] ?? "";
        String type = getFileType(fileName);

        Map<String, dynamic> msgData = {
          "id": '${Random().nextInt(100000)}',
          "authorId": (createdBy == "IOB3") ? "user1" : "user2",
          "createdAt": DateTime.fromMillisecondsSinceEpoch(doc["timeStamp"]),
          "text": fileName,
          "type": "file",
          "metadata": {
            "fileType": type,
            "fileName": fileName,
            "rowId": doc["rowId"],
            "createdBy": createdBy,
          },
        };
        if (globalLoadingBubbleId != null) {
          final loadingMsg = findMessageById(globalLoadingBubbleId!);
          if (loadingMsg != null) _chatController.removeMessage(loadingMsg);
          globalLoadingBubbleId = null;
        }

        // First add raw file bubble to messages list
        storedMessages.add(msgData);

        // Try loading from cache
        File? cachedFile = await getCachedFile(doc["rowId"], fileName);

        if (cachedFile != null && type == "image") {
          msgData["type"] = "image";
          msgData["source"] = cachedFile.path;
          msgData["size"] = await cachedFile.length();
        }
      }
    } catch (error, st) {
      print("Query Document details Exception: $error\n$st");
    }
  }

  void refreshChatListNew() {
    // Sort stored messages
    storedMessages.sort((a, b) {
      DateTime t1 = a["createdAt"];
      DateTime t2 = b["createdAt"];
      return t1.compareTo(t2);
    });

    // SAFELY clear controller
    clearChatController();

    // Insert all messages fresh
    for (var msg in storedMessages) {
      if (msg["type"] == "text") {
        _chatController.insertMessage(
          TextMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            text: msg["text"],
          ),
        );
      } else if (msg["type"] == "image") {
        _chatController.insertMessage(
          ImageMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            source: msg["source"],
            size: msg["size"],
          ),
        );
      } else if (msg["type"] == "file") {
        _chatController.insertMessage(
          TextMessage(
            id: msg["id"],
            authorId: msg["authorId"],
            createdAt: msg["createdAt"],
            text: msg["text"],
            metadata: msg["metadata"],
          ),
        );
      }
    }
  }

  // To load a text from API
  loadTextMessageFromAPINew2() async {
    try {
      print('came here');
      Dio dio = Dio();

      dio.options
        ..baseUrl = ApiConfig.BASE_URL_QUERY
        ..connectTimeout = Duration(seconds: 20)
        ..receiveTimeout = Duration(seconds: 20);

      dio.options.headers = {
        'token': ApiConfig.AUTH_TOKEN,
        'deviceId': ApiConfig.DEVICE_ID,
        'userid': 'IOB3',
      };

      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );

      final endPoint = ApiConfig.GET_QUERY_DETAILS_TEXT;

      // Show loading bubble only once
      globalLoadingBubbleId = "loading_${Random().nextInt(999999)}";
      _chatController.insertMessage(
        TextMessage(
          id: globalLoadingBubbleId!,
          authorId: "user2",
          createdAt: DateTime.now(),
          text: "",
          metadata: {"loading": true},
        ),
      );

      final response = await dio.post(
        endPoint,
        data: {
          "queryId": widget.queryId,
          "propNo": widget.proposalNo,
          "recipient": "IOB3",
          "TOCc": "To",
        },
      );

      final responseData = response.data;
      final isSuccess = responseData['success'] == true;

      if (!isSuccess) {
        print('Error: ${responseData['ErrorMessage']}');
        safeShowSnack("Technical issue occurred. Try again later.");
        return;
      }

      print('here...response..$responseData');

      // Extracting values
      String desc = responseData['QueryDescription']?.toString() ?? "";
      String resp = responseData['QueryResponse']?.toString() ?? "";

      int timeStamp =
          responseData['responseTime'] ?? responseData['requestTime'];
      if (desc.trim().isNotEmpty) {
        storedMessages.add({
          "id": '${Random().nextInt(100000)}',
          "authorId": 'user2',
          "createdAt": DateTime.fromMillisecondsSinceEpoch(
            responseData['requestTime'],
          ),
          "text": desc,
          "type": "text",
        });
      }

      if (resp.trim().isNotEmpty) {
        storedMessages.add({
          "id": '${Random().nextInt(100000)}',
          "authorId": 'user1',
          "createdAt": DateTime.fromMillisecondsSinceEpoch(
            responseData['responseTime'],
          ),
          "text": resp,
          "type": "text",
        });
      }

      print('success bro');
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      print('here..${failure.message}');
    } catch (error, st) {
      print(" QueryResponseHandler Exception: $error\n$st");
    }
  }

  void showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.blue),
                  title: Text("Take Photo"),
                  onTap: () async {
                    Navigator.pop(context);
                    await pickFromCamera();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo, color: Colors.green),
                  title: Text("Pick from Gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    await pickFromGallery();
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.attach_file, color: Colors.purple),
                //   title: Text("Pick Document"),
                //   onTap: () async {
                //     Navigator.pop(context);
                //     await pickDocument();
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> pickFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo == null) return;

    final file = File(photo.path);
    final compressed = await compressImage(file);

    sendDocumentsToAPI(
      file: compressed,
      imgPath: compressed.path,
      size: await compressed.length(),
    );
  }

  Future<void> pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final file = File(image.path);
    final compressed = await compressImage(file);

    sendDocumentsToAPI(
      file: compressed,
      imgPath: compressed.path,
      size: await compressed.length(),
    );
  }

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result == null) return;

    final path = result.files.single.path!;
    final file = File(path);
    final ext = result.files.single.extension!.toLowerCase();

    if (["jpg", "jpeg", "png"].contains(ext)) {
      final compressed = await compressImage(file);
      sendDocumentsToAPI(
        file: compressed,
        imgPath: compressed.path,
        size: await compressed.length(),
      );
    } else {
      sendDocumentsToAPI(
        file: file,
        imgPath: file.path,
        size: await file.length(),
      );
    }
  }

  String getSafeFileName(String originalName) {
    final ext = originalName.split('.').last;
    String base = originalName.replaceAll('.$ext', '');

    if (base.length > 40) {
      base = base.substring(0, 40);
    }

    final newName = "$base.$ext";
    return newName;
  }

  //without camera file only:
  // onAttachmentTap:
  //           // widget.status == "Closed"
  //           //     ? null
  //           //     :
  //           () async {
  //             FilePickerResult? result = await FilePicker.platform.pickFiles(
  //               allowMultiple: false,
  //               type: FileType.custom,
  //               allowedExtensions: [
  //                 'jpg',
  //                 'jpeg',
  //                 'png',
  //                 'webp',
  //                 'pdf',
  //                 'doc',
  //                 'docx',
  //               ],
  //             );

  //             if (result == null) return;

  //             final path = result.files.single.path!;
  //             final name = result.files.single.name;

  //             final file = File(path);

  //             final ext = name.split('.').last.toLowerCase();
  //             final fileType = getFileType(ext);

  //             if (fileType == "image") {
  //               final compressed = await compressImage(file);
  //               sendDocumentsToAPI(
  //                 file: compressed,
  //                 imgPath: compressed.path,
  //                 size: await compressed.length(),
  //               );
  //               print(
  //                 'here.. original..${await file.length()}....${await compressed.length()}',
  //               );
  //               return;
  //             }
  //             sendDocumentsToAPI(
  //               file: file,
  //               imgPath: file.path,
  //               size: await file.length(),
  //             );
  //           },
}
