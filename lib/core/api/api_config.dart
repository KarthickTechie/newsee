class ApiConfig {
  static const String BASE_URL = "http://192.168.0.19:19085/lendmobility/"; //qa

  static const String BASE_URL_AWS =
      "http://10.100.0.247:19085/lendmobility/"; //aws qa url
  static const String BASE_URL_UAT =
      "https://103.98.54.19:443/lendmobility/"; //uat
  // static const String BASE_URL_QUERY =
  //     "http://192.168.7.193:9001/lendmobility/";
  // static const String BASE_URL_QUERY =
  //     "http://10.100.0.247:19085/lendmobility/";
  // static const String BASE_URL_Query = "http://172.30.0.1:9001/lendmobility/";

  static const bool isUAT = false; // for uat set true
  static const bool isAWS = true; // for aws set true
  static const String UPLOAD_VIDEO = "MobileService/getVideoUpload";
  static const String AUTH_TOKEN =
      'U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3'; //uat
  // 'U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3'; //local
  static const String DEVICE_ID =
      'U2FsdGVkX180H+UTzJxvLfDRxLNCZeZK0gzxeLDg9Azi7YqYqp0KqhJkMb7DiIns'; // uat
  // 'U2FsdGVkX180H+UTzJxvLfDRxLNCZeZK0gzxeLDg9Azi7YqYqp0KqhJkMb7DiIns';

  static const String VERTICAL = '7';

  static const String MASTERS_API_ENDPOINT = 'MasterDetails/getMasterDetails';
  static const String AADHAAR_API_ENDPOINT = 'MobileService/getAadhaarDetails';

  static const String CIF_API_ENDPOINT = 'MobileService/CIFSearch';
  // static const String CIF_API_ENDPOINT = 'UAIBController/callUAIB';
  static const String CIBIL_API_ENDPOINT = 'MobileService/getCibilConsumer';
  // static const String CIBIL_API_ENDPOINT = 'UAIBController/callUAIB';

  static const String DEDUPE_API_ENDPOINT = "MobileService/getDedupeSearch";
  static const String GETCITY_API_ENDPOINT = "MasterDetails/getCityCode";
  static const String GETDISCTRICT_API_ENDPOINT =
      "MasterDetails/getDistrictCode";

  static const String API_RESPONSE_SUCCESS_KEY = 'Success';
  static const String API_RESPONSE_ErrorFlag_KEY = 'ErrorFlag';
  static const String API_RESPONSE_ERRORMESSAGE_KEY = 'ErrorMessage';

  static const String API_RESPONSE_RESPONSE_KEY = 'responseData';
  static const String API_RESPONSE_KEY = 'RESPONSE';

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
  static const String CROP_DELETE_API_ENDPOINT =
      'MobileService/deleteProposedCrops';

  static const String CREATE_PROPOSAL = 'MobileService/getProposalCreation';

  static const String PROPOSAL_INBOX_API_ENDPOINT =
      '/MobileService/getProposalInboxDetails';

  static const String PD_INBOX_API_ENDPOINT = 'MobileService/getPDGroupInbox';

  static const String PD_SCORECARD_ENDPOINT = 'MobileService/savePDScoreCard';

  static const String PD_COMMENTS_SAVE = 'MobileService/savePDdetail';

  static const String PD_RECEIVED_APPLICATION =
      'MobileService/getPDReceivedApplication';

  static const String GET_MASTERS_VERSION_API_ENDPOINT =
      'MobileService/getMastersVersions';
  static const String GET_DOCUMENTS = 'MobileService/getDocumentDetails';
  static const String UPLOAD_DOCUMENT = 'MobileService/getDocumentUpload';
  static const String FETCH_UPLOAD_DOCUMENT = 'MobileService/getUploadDocument';
  static const String DELETE_UPLOAD_DOCUMENT = 'MobileService/deleteUploadFile';
  static const String GET_LAND_CROP_STATUS =
      'MobileService/getLandAndCropStatus';
  static const String mpinRegisterEndpoint = 'MobileService/registerMPIN';
  static const String mpinValidateEndPoint = 'MobileService/validateMPINLogin';
  static const String module = 'AGRI';
  static const String encKey = 'sysarc@1234INFO@';
  static const String GET_LEAD_DETAILS = 'MobileService/getLeadDetails';
  static const String sslCertPath = 'assets/certificates/';
  // Query Module APIs
  static const String GET_QUERY_INBOX_LIST = 'MobileService/queryinbox';
  static const String GET_QUERY_DETAILS_TEXT = 'MobileService/queryrequest';
  static const String SEND_TEXTMSG_RESPONSE = 'MobileService/queryresponse';
  static const String SEND_IMAGE_RESPONSE = 'MobileService/uploadQueryDoc';
  static const String GET_QUERYDETAILS_IMG =
      'MobileService/getQueryDocumDetList';
  static const String GET_SINGLEDOCUMENT_IMAGE =
      'MobileService/getQueryDocument';
}
