import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/blocs/login/login_bloc.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:newsee/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:newsee/feature/auth/domain/repository/auth_repository.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';

class LoginBlocProvide extends StatelessWidget {
  final bool? createPIN;
  const LoginBlocProvide(this.createPIN, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create:
            (_) => AuthBloc(
              authRepository: AuthRepositoryImpl(
                authRemoteDatasource: AuthRemoteDatasource(
                  dio: ApiClient().getDio(),
                ),
              ),
            ),
        child: LoginpageWithAC(createPIN),
      ),
    );
  }
}
