class ApiConfig {
  static const String BASE_URL = "http://192.168.0.19:19084/lendperfect/";
  
  static const String AUTH_TOKEN =
      'U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3';
  static const String DEVICE_ID =
      'U2FsdGVkX180H+UTzJxvLfDRxLNCZeZK0gzxeLDg9Azi7YqYqp0KqhJkMb7DiIns';

  static const String VERTICAL = '7';

  static const String MASTERS_API_ENDPOINT = 'MasterDetails/getMasterDetails';
  static const String AADHAAR_API_ENDPOINT = 'MobileService/getAadhaarDetails';

  static const String CIF_API_ENDPOINT = 'MobileService/CIFSearch';

  static const String DEDUPE_API_ENDPOINT = "MobileService/getDedupeSearch";
  static const String GETCITY_API_ENDPOINT = "MasterDetails/getCityCode";
  static const String GETDISCTRICT_API_ENDPOINT =
      "MasterDetails/getDistrictCode";

  static const String API_RESPONSE_SUCCESS_KEY = 'Success';

  static const String API_RESPONSE_ERRORMESSAGE_KEY='ErrorMessage';

  static const String API_RESPONSE_RESPONSE_KEY = 'responseData';

  static const String LEAD_INBOX_API_ENDPOINT =
      'MobileService/getLeadGroupDetails';

  static const String LEAD_SUBMIT_API_ENDPOINT =
      'MobileService/saveLeadDetails';

  static const String LAND_HOLDING_ENDPOINT = 'MobileService/saveLandHold';

  static const String LAND_HOLDING_GET_API_ENDPOINT =
      'MobileService/getLandHoldingDetails';

  static const String LAND_HOLDING_DELETE_API_ENDPOINT =
      'MobileService/deleteLandHoldingDetails';

  static const String CROP_SUBMIT_API_ENDPOINT =
      'MobileService/saveProposedCrops';

  static const String CROP_GET_API_ENDPOINT = 'MobileService/getProposedCrops';

  static const String CROP_DELETE_API_ENDPOINT = 'MobileService/deleteProposedCrops';

  static const String CREATE_PROPOSAL = 'MobileService/getProposalCreation';

  static const String PROPOSAL_INBOX_API_ENDPOINT =
      '/MobileService/getProposalInboxDetails';

  static const String GET_MASTERS_VERSION_API_ENDPOINT = 'MobileService/getMastersVersions';
  static const String GET_DOCUMENTS = 'MobileService/getDocumentDetails';
  static const String UPLOAD_DOCUMENT = 'MobileService/getDocumentUpload';
  static const String FETCH_UPLOAD_DOCUMENT = 'MobileService/getUploadDocument';
  static const String DELETE_UPLOAD_DOCUMENT = 'MobileService/deleteUploadFile';
}
