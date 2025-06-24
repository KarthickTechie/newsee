import 'package:get_it/get_it.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/Utils/local_biometric.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/blocs/camera/camera_bloc.dart';
import 'package:newsee/blocs/login/login_bloc.dart';
import 'package:newsee/feature/saveprofilepicture/profilepicturebloc/saveprofilepicture_bloc.dart';

final getIt = GetIt.instance;

void dependencyInjection() {
  getIt.registerSingleton(MediaService());
  getIt.registerSingleton(BioMetricLogin());
  getIt.registerFactory<CameraBloc>(() => CameraBloc());
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(loginRequest: LoginRequest(username: '', password: '')),
  );
  getIt.registerSingleton<SaveProfilePictureBloc>(
    SaveProfilePictureBloc(
      ProfilPictureState(status: null, profilepicturedetails: null),
    ),
  );
}
