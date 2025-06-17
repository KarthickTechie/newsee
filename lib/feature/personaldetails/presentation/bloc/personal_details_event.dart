part of 'personal_details_bloc.dart';

/* 

@author     : karthick.d  10/06/2025
@desc       : event for init , save , update Personaldetails
              newlead::init         - set the dropdown with datasets - new lead
                                      set the leaddetails form frm cif dedupe response of previous page
              submittedlead::init   - set the leaddata form already saved 

@param      : 
 */
abstract class PersonalDetailsEvent {}

/* 
              newlead::init         - set the dropdown with datasets - new lead
                                      set the leaddetails form frm cif dedupe response of previous page
                                      cif/dedupe
        
 */
class PersonalDetailsInitEvent extends PersonalDetailsEvent {
  // CifResponseModel willbe set by CIF/Deduperesponse which will be
  // autopopulated in PersonalDetails
  final CifResponseModel? cifResponseModel;
  PersonalDetailsInitEvent({required this.cifResponseModel});
}

class PersonalDetailsSaveEvent extends PersonalDetailsEvent {
  final PersonalData? personalData;
  PersonalDetailsSaveEvent({required this.personalData});
}

class AadhaarValidateEvent extends PersonalDetailsEvent {
  final AadharvalidateRequest request;
  AadhaarValidateEvent({required this.request});
}
