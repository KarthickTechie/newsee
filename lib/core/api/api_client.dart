import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiClient {
  Dio getDio() {
    Dio dio = Dio();
    dio.options.baseUrl = ApiConfig.BASE_URL;

    dio.options.headers = {
      'token': ApiConfig.AUTH_TOKEN,
      'deviceId': ApiConfig.DEVICE_ID,
      'userid': '4321',
    };

    dio.interceptors.add(
      PrettyDioLogger(
        responseHeader: true,
        responseBody: true,
        requestHeader: true,
        requestBody: true,
        request: true,
        compact: false,
      ),
    );

    // Add this interceptor for internet connection check
    // dio.interceptors.add(ConnectivityInterceptor());

    return dio;
  }
}

// Custom Interceptor for Internet Connectivity Check
class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check internet connectivity
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'NoInternetException',
          message: 'Please check your internet connection',
        ),
      );
      return;
    } else {
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Proceed with the response
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors
    handler.next(err);
  }
}
