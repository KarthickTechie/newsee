import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login_mpin.dart';
import 'package:newsee/Utils/aes_utils.dart';
import 'package:newsee/Utils/app_theme_utils.dart';
import 'package:newsee/Utils/convert_mpin.dart';
import 'package:newsee/Utils/mpin_encrypt.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

createMpin(BuildContext context, AsyncResponseHandler? asyncResponseHandler) {
  // show the custom modal bottom sheet
  String pin = '';
  String confirmPin = '';

  showModalBottomSheet<void>(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    context: context,
    builder: (BuildContext context) {
      ValueNotifier<bool> isloading = ValueNotifier<bool>(false);
      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final screenHeight = size.height;
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: screenHeight * 0.82,
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Title(
                    color: Colors.black,
                    child: Text(
                      'Create  MPIN',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set  MPIN',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  PinCodeTextField(
                    enablePinAutofill: false,
                    autoFocus: true,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    appContext: context,
                    length: 4,
                    obscureText: true,
                    blinkDuration: Duration(seconds: 1),
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: getPinTheme(),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.white12,
                    enableActiveFill: true,
                    onCompleted: (v) {
                      pin = v;
                      print("Set MPIN Completed => $pin");
                    },
                    onChanged: (value) {
                      print(value);
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Confirm  MPIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  PinCodeTextField(
                    enablePinAutofill: false,
                    autoFocus: true,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    appContext: context,
                    length: 4,
                    obscureText: true,
                    blinkDuration: Duration(seconds: 1),
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: getPinTheme(),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.white12,
                    enableActiveFill: true,
                    onCompleted: (v) {
                      if (pin == v) {
                        confirmPin = v;
                      }
                      print("Completed");
                    },
                    onChanged: (value) {
                      print(pin);
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ],
              ),

              SizedBox(height: 50),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    Color.fromARGB(255, 2, 59, 105),
                  ),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  minimumSize: WidgetStatePropertyAll(Size(230, 40)),
                ),
                onPressed: () async {
                  try {
                    if (confirmPin.length != 4) {
                      showDialog(
                        context: context,
                        builder:
                            (_) => SysmoAlert.info(
                              message: 'Invalid MPIN',
                              onButtonPressed:
                                  () => Navigator.of(context).pop(),
                            ),
                      );

                      return;
                    }

                    isloading.value = true;
                    await Future.delayed(Duration(seconds: 2));
                    final encPinValue = encryptMPIN(
                      confirmPin,
                      ApiConfig.encKey,
                    );
                    print('enc pin => ${encPinValue.encryptedText}');
                    UserDetails? userDetails = await loadUser();

                    final response = await ApiClient().getDio().post(
                      ApiConfig.mpinRegisterEndpoint,
                      data: {
                        "mpin": encPinValue.encryptedText,
                        "userid": userDetails?.LPuserID,
                        "vertical": ApiConfig.VERTICAL,
                        "token": ApiConfig.AUTH_TOKEN,
                      },
                    );

                    if (response.data[ApiConstants.api_response_success]) {
                      showDialog(
                        context: context,
                        builder:
                            (_) => SysmoAlert.success(
                              message: AppConstants.mpinRegistrationSuccess,
                              onButtonPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                mpin(context, asyncResponseHandler);
                              },
                            ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder:
                            (_) => SysmoAlert.failure(
                              message:
                                  response.data[ApiConstants
                                      .api_response_errorMessage],
                              onButtonPressed: () {
                                isloading.value = false;
                                Navigator.pop(context);
                              },
                            ),
                      );
                    }
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder:
                          (_) => SysmoAlert.failure(
                            message: 'MPIN Registration Failed : $e',
                            onButtonPressed: () {
                              isloading.value = false;
                              Navigator.pop(context);
                            },
                          ),
                    );
                  }
                },

                child: ValueListenableBuilder(
                  valueListenable: isloading,
                  builder: (context, value, _) {
                    return value == false
                        ? Text("Register MPIN")
                        : CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
