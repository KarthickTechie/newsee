/* 
@author     : karthick.d
@desc       : 
 */
import 'package:dio/dio.dart';
import 'package:newsee/core/api/http_connection_failure.dart';

class DioHttpExceptionParser {
  final DioException exception;

  DioHttpExceptionParser({required this.exception});

  HttpConnectionFailure parse() {
    switch (exception.type) {
      case DioExceptionType.connectionError:
        return HttpConnectionFailure(
          message: 'Connection Error Occured , Pls Try Again in sometimes',
        );

      case DioExceptionType.badResponse:
        return HttpConnectionFailure(
          message: 'Technical Error Occured...BAD RESPONSE',
        );

      case DioExceptionType.badCertificate:
        return HttpConnectionFailure(message: 'SSL Certificate Exception');

      case DioExceptionType.connectionTimeout:
        return HttpConnectionFailure(message: 'Connection Timeout');

      case DioExceptionType.sendTimeout:
        return HttpConnectionFailure(message: 'Server Not Reachable');

      case DioExceptionType.cancel:
        return HttpConnectionFailure(
          message: 'Exception Occured When Request is canceled',
        );

      case DioExceptionType.unknown:
        if (exception.error =='NoInternetException') {
          return HttpConnectionFailure(
            message: exception.message.toString()
          );
        } 

        return HttpConnectionFailure(
          message: 'Some Error Occured , Pls Try Again in sometimes',
        );

      case DioExceptionType.receiveTimeout:
        return HttpConnectionFailure(message: 'Response Receive Timeout');
    }
  }
}
