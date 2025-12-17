/*
 @author     : Sheik Mohideen
   @date       : 10/12/2025
   @desc       : Query Inbox page displaying user queries using OptionsSheet widget.
                Shows a list of queries with recipient name, query type, and date.
              Each query item is displayed as an OptionsSheet with action capability.
 */

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/queryInbox/domain/modal/queryInbox_response_modal.dart';
import 'package:newsee/feature/queryInbox/domain/modal/query_response_modal.dart';
import 'package:newsee/feature/queryInbox/local/response.dart';
import 'package:newsee/feature/queryInbox/presentation/page/query_details.dart';
import 'package:newsee/widgets/options_sheet.dart';
import 'package:newsee/widgets/side_navigation.dart';

class QueryInbox extends StatefulWidget {
  int? tabdata;
  final String? title;
  final String? body;

  QueryInbox({super.key, required this.title, required this.body});

  @override
  State<QueryInbox> createState() => QueryInboxState();
}

class QueryInboxState extends State<QueryInbox> {
  late QueryInboxResponseModal queryData;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    getQueryList();
  }

  Future<void> getQueryList() async {
    try {
      print('came here');
      // Dio dio = Dio();
      Dio dio = ApiClient().getDio();
      // dio.options.baseUrl = ApiConfig.BASE_URL_QUERY_QUERY_Query;
      // dio.options
      //   ..baseUrl = ApiConfig.BASE_URL_QUERY
      //   ..connectTimeout = Duration(seconds: 50)
      //   ..receiveTimeout = Duration(seconds: 50);

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

      final endPoint = ApiConfig.GET_QUERY_INBOX_LIST;

      final response = await dio.get(endPoint);
      print('here..$response');
      final responseData = response.data;
      final isSuccess =
          responseData[ApiConfig.API_RESPONSE_SUCCESS_KEY] == true;

      if (isSuccess) {
        setState(() {
          queryData = QueryInboxResponseModal.fromJson(responseData);
          queryData.queryList.sort((a, b) => b.date.compareTo(a.date));
          isLoading = false;
        });
        print('objects: ${queryData}');
      } else {
        final errorMessage = responseData['ErrorMessage'] ?? "Unknown error";
        print('Error: $errorMessage');
      }
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      setState(() {
        queryData = QueryInboxResponseModal.fromJson(QueryInboxResponse);
        isLoading = false;
        print('problem with API... So fetched from Local data');
      });

      print('here..${failure.message}');
    } catch (error, st) {
      print(" QueryResponseHandler Exception: $error\n$st");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: () {
        return getQueryList();
      },
      child: ListView.builder(
        itemCount: queryData.queryList.length,
        itemBuilder: (context, index) {
          final item = queryData.queryList[index];
          return OptionsSheet(
            icon: Icons.message,
            title: item.queryId,
            subtitle: item.subject,
            status: item.status,

            details: [item.senderName, item.date.toString().split(' ')[0]],
            detailsName: ['Sent By', 'Date'],

            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => QueryDetails(
                        userName: item.senderName,
                        queryType: item.subject,
                        queryId: item.queryId,
                        proposalNo: item.proposalNo,
                        status: item.status,
                      ),
                ),
              );
              getQueryList();
            },
          );
        },
      ),
    );
  }
}

class OptionsSheet extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? subtitle;
  final String? status;
  final List<String>? details;
  final List<String>? detailsName;

  const OptionsSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.status,
    this.details,
    this.detailsName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade200, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            // Title, subtitle, and details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  if (details != null &&
                      details!.isNotEmpty &&
                      detailsName != null) ...[
                    const SizedBox(height: 6),
                    ...List.generate(details!.length, (index) {
                      final label =
                          index < detailsName!.length
                              ? detailsName![index]
                              : '';
                      final detail = details![index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: RichText(
                          text: TextSpan(
                            text: label.isNotEmpty ? '$label: ' : '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: detail,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
            // Trailing Status Pill
            if (status != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      status == "Open"
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  status!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        status == "Open"
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
