import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
    dio.interceptors.add(ConnectivityInterceptor());

    return dio;
  }
}

// Custom Interceptor for Internet Connectivity Check
class ConnectivityInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    // Check internet connectivity
    final bool isConnected = await InternetConnectionChecker.instance.hasConnection;
    if (isConnected) {
      handler.next(options);
    } else {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'NoInternetException',
          message: 'Please check your internet connection'
        ),
      );
      return;
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
