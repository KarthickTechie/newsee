import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';

class ProposalInboxRemoteDatasource {
  final Dio dio;
  ProposalInboxRemoteDatasource({required this.dio});

  Future<Response> searchProposalInbox(Map<String, dynamic> payload, String endpoint) async {
    return await dio.post(
      endpoint,
      data: payload,
      options: Options(
        headers: {
          'token': ApiConfig.AUTH_TOKEN,
          'deviceId': ApiConfig.DEVICE_ID,
          'userid': '4321',
        },
      ),
    );
  }
}
