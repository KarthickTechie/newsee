import 'package:newsee/feature/auth/domain/model/user/auth_response_model.dart';

class Globalconfig {
  static final bool isInitialRoute = false;

  //A global map used to store the latest version of each master data
  //recieved from the server during login activity.

  static Map<String, dynamic> masterVersionMapper = {};
}

/* 

call masterVersionService() => { 'version' : ''}

 */
