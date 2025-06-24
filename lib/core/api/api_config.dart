class ApiConfig {
  static const String BASE_URL = "http://192.168.0.19:19084/lendperfect/";
  //static const String BASE_URL = "http://192.168.7.79:9088/lendperfect/";
  static const String AUTH_TOKEN =
      'U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3';
  static const String DEVICE_ID =
      'U2FsdGVkX180H+UTzJxvLfDRxLNCZeZK0gzxeLDg9Azi7YqYqp0KqhJkMb7DiIns';

  static const String MASTERS_API_ENDPOINT = 'MasterDetails/getMasterDetails';
  static const String AADHAAR_API_ENDPOINT = 'MobileService/getAadhaarDetails';

  static const String CIF_API_ENDPOINT = 'MobileService/CIFSearch';

  static const String DEDUPE_API_ENDPOINT = "MobileService/getDedupeSearch";
  static const String GETCITY_API_ENDPOINT = "MasterDetails/getCityCode";
  static const String GETDISCTRICT_API_ENDPOINT =
      "MasterDetails/getDistrictCode";

  static const String API_RESPONSE_SUCCESS_KEY = 'Success';

  static const String API_RESPONSE_RESPONSE_KEY = 'responseData';

  static const String LEAD_INBOX_API_ENDPOINT =
      'MobileService/getLeadGroupDetails';

  static const String LEAD_SUBMIT_API_ENDPOINT =
      'MobileService/saveLeadDetails';
}
