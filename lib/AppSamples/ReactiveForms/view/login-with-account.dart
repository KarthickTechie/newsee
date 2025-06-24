import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/config/appconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/loginwithblocprovider.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/Utils/masterversioncheck.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/master_version.dart';
import 'package:reactive_forms/reactive_forms.dart';

/*

@author : Gayathri.b    12/05/2025
@description :  This function displays a Cupertino-style modal bottom sheet containing 
                a login form implemented using the `ReactiveForms` package and Bloc pattern.
                It uses a gradient background and dynamically adapts its size based on 
                screen width and height.

@props      :
  - BuildContext context : The context in which the bottom sheet is presented.
 */

void loginActionSheet(BuildContext context) {
  //dynamically adapts its size based on  screen width and height.

  final double screenwidth = MediaQuery.of(context).size.width;
  final double screenheight = MediaQuery.of(context).size.height;

  showCupertinoModalPopup(
    context: context,

    builder:
        (BuildContext context) => SingleChildScrollView(
          child: Container(
            //It uses a gradient background
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(126, 1, 1, 129),
                  const Color.fromARGB(64, 1, 1, 129),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(10),
            width: screenwidth * 1.0,
            height: screenheight * 0.75,
            child: LoginBlocProvide(),
          ),
        ),
  );
}

class LoginpageWithAC extends StatelessWidget {
  const LoginpageWithAC({super.key});

  @override
  Widget build(BuildContext context) {
    final loginFormgroup = AppConfig().loginFormgroup;

    login(AuthState state) {
      if (loginFormgroup.valid) {
        context.read<AuthBloc>().add(
          LoginWithAccount(
            loginRequest: LoginRequest(
              username: loginFormgroup.value['username'] as String,
              password: loginFormgroup.value['password'] as String,
            ),
          ),
        );
        print(state.toString());

        //context.goNamed('home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
      }
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        switch (state.authStatus) {
          case AuthStatus.success:
            print('LoginStatus.success... ${state.authResponseModel}');
            AsyncResponseHandler<bool, List<MasterVersion>>
            masterVersionCheckResponseHandler = await compareVersions(
              Globalconfig.masterVersionMapper,
            );
            print(
              'masterVersionCheckResponseHandler.isLeft => ${masterVersionCheckResponseHandler.isLeft()}',
            );

            print(
              'masterVersionCheckResponseHandler.isRight => ${masterVersionCheckResponseHandler.isRight()}',
            );
            /* 
              important : masterversion check based masterdownload happeing here
                          Asynresponsehandler response eigther return List<MasterVersion>
                          if masterupdate is required and list of mastertype that haev updated
                          master version will be returned
                          otherwise null will be returned in left

             */
            if (masterVersionCheckResponseHandler.isLeft()) {
              context.goNamed('masters');
            } else if (masterVersionCheckResponseHandler.isRight()) {
              if (masterVersionCheckResponseHandler.right.isNotEmpty) {
                context.goNamed('masters');
              } else {
                context.goNamed('home');
              }
            }
          case AuthStatus.loading:
            print('LoginStatus.loading...');

          case AuthStatus.init:
            print('LoginStatus.init...');

          case AuthStatus.failure:
            context.goNamed('home');
            print('LoginStatus.error...');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login Failed...')),
            );
        }
        ;
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state.authStatus == AuthStatus.loading;
          print('state.authStatus => ${state.authStatus}');
          final isPasswordHidden = state.isPasswordHidden;
          print(
            'in build function isPasswordHidden=> ${state.isPasswordHidden}',
          );
          return Container(
            // login form implemented using the `ReactiveForms` package and Bloc pattern
            child: SingleChildScrollView(
              child: Container(
                child: ReactiveForm(
                  formGroup: loginFormgroup,
                  child: Center(
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Login Account",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          ReactiveTextField(
                            formControlName: 'username',
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              suffixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validationMessages: {
                              ValidationMessage.required:
                                  (error) => 'UserName is Required',
                              ValidationMessage.contains:
                                  (error) => error as String,
                            },
                          ),
                          SizedBox(height: 10.0),

                          ReactiveTextField(
                            formControlName: 'password',
                            obscureText: state.isPasswordHidden,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    PasswordSecure(),
                                  );
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validationMessages: {
                              ValidationMessage.required:
                                  (error) => 'Password is Required',
                              ValidationMessage.contains:
                                  (error) => error as String,
                            },
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                Color.fromARGB(255, 2, 59, 105),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              minimumSize: WidgetStatePropertyAll(
                                Size(230, 40),
                              ),
                            ),
                            onPressed:
                                isLoading
                                    ? null
                                    : () {
                                      login(state);
                                    },
                            child:
                                isLoading
                                    ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                    : const Text("Login"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
