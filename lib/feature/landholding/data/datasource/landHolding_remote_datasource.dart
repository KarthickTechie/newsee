// import 'package:dio/dio.dart';
// import 'package:newsee/core/api/api_config.dart';
// import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';

// class LandHoldingRemoteDatasource {
//   final Dio dio;

//   LandHoldingRemoteDatasource({required this.dio});

//   Future<Response> submitLandHolding(LandHoldingRequest request) async {
//     try {
//       final response = await dio.post(
//         ApiConfig.MASTERS_API_ENDPOINT,
//         data: request.toJson(),
//         options: Options(
//           headers: {
//             'token': ApiConfig.AUTH_TOKEN,
//             'deviceId': ApiConfig.DEVICE_ID,
//             'userid': '4321',
//           },
//         ),
//       );
//       return response;
//     } on DioException catch (e) {
//       throw Exception('API Error: ${e.message}');
//     } catch (e) {
//       throw Exception('Unexpected Error: $e');
//     }
//   }
// }
