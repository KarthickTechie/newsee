import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
import 'package:newsee/Utils/app_theme_utils.dart';
import 'package:newsee/Utils/convert_mpin.dart';
import 'package:newsee/Utils/masterversioncheck.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/pages/home_page.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SysmoMpin extends StatefulWidget {
  AsyncResponseHandler? masterVersionCheckResponseHandler;
  final BuildContext pageContext;
  SysmoMpin({
    required this.masterVersionCheckResponseHandler,
    required this.pageContext,
  });

  @override
  State<StatefulWidget> createState() => _SysmoMpinState();
}

class _SysmoMpinState extends State<SysmoMpin> {
  String pin = '';
  bool isloading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return SizedBox(
      height: screenHeight * 0.7,
      child: Column(
        children: [
          Align(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Title(
                color: Colors.black,
                child: Text(
                  'Enter the MPIN',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.start,
                ),
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
            onCompleted: (v) {},
            onChanged: (value) {
              setState(() {
                pin = value;
                print('pin => $pin');
              });
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
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
              /**
                   * login with mpin , if pin validation is success 
                   * check masterversionchecker api 
                   * based on the response redirect to master page or home page
                   * */
              try {
                if (pin.length != 4) {
                  showDialog(
                    context: context,
                    builder:
                        (_) => SysmoAlert.info(
                          message: 'Invalid MPIN',
                          onButtonPressed: () => Navigator.of(context).pop(),
                        ),
                  );

                  return;
                }
                setState(() {
                  isloading = true;
                });
                await Future.delayed(Duration(seconds: 2));
                final encPinValue = encryptMPIN(pin, ApiConfig.encKey);
                print('enc pin => ${encPinValue.encryptedText}');
                UserDetails? userDetails = await loadUser();

                final response = await ApiClient().getDio().post(
                  ApiConfig.mpinValidateEndPoint,
                  data: {
                    "Loginuser": userDetails!.LPuserID,
                    "Module": ApiConfig.module,
                    "mpin": encPinValue.encryptedText,
                    "userid": userDetails.LPuserID,
                    "vertical": ApiConfig.VERTICAL,
                    "token": ApiConfig.AUTH_TOKEN,
                  },
                );

                if (response.data[ApiConstants.api_response_success]) {
                  showDialog(
                    context: context,
                    builder:
                        (_) => SysmoAlert.success(
                          message: AppConstants.mpinLoginSuccess,
                          onButtonPressed: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // context.pop();
                            // master version check
                            widget.masterVersionCheckResponseHandler ??=
                                await compareVersions(
                                  Globalconfig.masterVersionMapper,
                                );
                            if (widget.masterVersionCheckResponseHandler!
                                .isLeft()) {
                              context.goNamed('masters');
                            } else if (widget.masterVersionCheckResponseHandler!
                                .isRight()) {
                              if (widget
                                  .masterVersionCheckResponseHandler!
                                  .right
                                  .isNotEmpty) {
                                Globalconfig.diffListOfMaster =
                                    widget
                                        .masterVersionCheckResponseHandler!
                                        .right;
                                print(
                                  "Globalconfig.diffListOfMaster ${Globalconfig.diffListOfMaster}",
                                );
                                context.goNamed('masters');
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => HomePage()),
                                );
                              }
                            }
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
                            setState(() {
                              isloading = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                  );
                }
              } catch (e) {
                print(
                  'Exception occured : mpin login failed : stacktrace : $e',
                );
                showDialog(
                  context: context,
                  builder:
                      (_) => SysmoAlert.failure(
                        message:
                            DioHttpExceptionParser(
                              exception: e as DioException,
                            ).parse().message,
                        onButtonPressed: () {
                          setState(() {
                            isloading = false;
                          });
                          Navigator.pop(context);
                        },
                      ),
                );
              }
            },

            child:
                isloading == false
                    ? Text("Login")
                    : CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
          ),
          SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {
                loginActionSheet(context, createMPIN: true);
              },
              child: Text('Create Your MPIN Here.'),
            ),
          ),
        ],
      ),
    );
  }
}
