import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:newsee/feature/auth/domain/model/user/auth_response_model.dart';
import 'package:newsee/feature/auth/domain/model/user/user_model.dart';
import 'package:newsee/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl({required this.authRemoteDatasource});

  /* 
@author         : karthick.d  14/05/2025
@desc           : overide abstract method loginWithAccount from AuthRepository
                  this method calls authRemoteDatasource.loginWithUserAccount
                  method that perform dio.post to login service
@return         : Future<AsyncResponseHandler<Failure, UserModel>>
 */
  @override
  Future<AsyncResponseHandler<Failure, AuthResponseModel>> loginWithAccount(
    LoginRequest req,
  ) async {
    try {
      Map<String, dynamic> payload = {
        "Loginuser": req.username,
        "Loginpasswd": req.password,
        "IMEI": "42d084ddb553f47d",
        "LLdate": "2025-05-08 14:44:41",
        "Version": "0.0.20.5_lmsinbox_freeze",
        "Brach_code": "",
        "PdTab": "N",
        "Module": "HL",
      };

      print('auth request payload => $payload');
      var response = await authRemoteDatasource.loginWithUserAccount(payload);
      // process api response if it's success
      if (response.data['Success']) {
        var authResponse = AuthResponseModel.fromJson(
          response.data['responseData'],
        );

        final Map<String, dynamic> masterdetail =
            response.data['responseData']['MasterDetails'];
        Globalconfig.masterVersionMapper = masterdetail;

        print('AuthResponseModel.fromJson() => ${authResponse.toString()}');
        print("Auth Response from login: => $response");
        print(
          "masterResponse response from login, => ${Globalconfig.masterVersionMapper}",
        );

        return AsyncResponseHandler.right(authResponse);
      } else {
        // api response success : false , process error message
        var errorMessage = response.data['ErrorMessage'];
        print('on Error request.data["ErrorMessage"] => $errorMessage');
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      // exception handler for server down
      if (e.error is SocketException) {
        return AsyncResponseHandler.left(
          AuthFailure(
            message: "Could not reach Server , Please try again in sometimes.",
          ),
        );
      }
      return AsyncResponseHandler.left(
        AuthFailure(message: "Exception Occured"),
      );
    } on Exception catch (e) {
      return AsyncResponseHandler.left(
        AuthFailure(message: 'Authentication Failure'),
      );
    }
  }
}
