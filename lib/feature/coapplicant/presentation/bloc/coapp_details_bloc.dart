/* 
@autor      : karthick.d  20/06/2025
@desc       : bloc for saving co appdetails 
              more than one co-app can be add to co app list 
              co-applicant is optional and will be sent as part of lead details

 */

import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/aadharvalidation/data/repository/aadhar_validate_impl.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_response.dart';
import 'package:newsee/feature/aadharvalidation/domain/repository/aadharvalidate_repo.dart';
import 'package:newsee/feature/addressdetails/data/repository/citylist_repo_impl.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';
import 'package:newsee/feature/addressdetails/domain/repository/cityrepository.dart';
import 'package:newsee/feature/cif/data/repository/cif_respository_impl.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/cif/domain/repository/cif_repository.dart';
import 'package:newsee/feature/coapplicant/applicants_utility_service.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/draft/draft_service.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part 'coapp_details_event.dart';
part 'coapp_details_state.dart';

final class CoappDetailsBloc
    extends Bloc<CoappDetailsEvent, CoappDetailsState> {
  CoappDetailsBloc() : super(CoappDetailsState.initial()) {
    on<CoAppDetailsInitEvent>(initCoAppDetailsPage);
    on<CoAppDetailsSaveEvent>(saveCoAppDetailsPage);
    on<OnStateCityChangeEvent>(getCityListBasedOnState);
    on<CoAppGurantorSearchCifEvent>(onSearchCif);
    on<IsCoAppOrGurantorAdd>(addCoappOrGurantor);
    on<DeleteCoApplicantEvent>(_deleteApplicant);
    on<CoAppDetailsDedupeEvent>(_onDedupeResponse);
    on<CifEditManuallyEvent>((event, emit) {
      emit(state.copyWith(isCifValid: event.cifButton));
    });
    on<AadhaarValidateEvent>(validateAadaar);
    on<ScannerResponseEvent>(onScannerSuccess);
    on<CoApplicantandGurantorFetchEvent>(onCoappandGauDetailsFetch);
  }

  _deleteApplicant(DeleteCoApplicantEvent event, Emitter emit) {
    try {
      final updatedList =
          state.coAppList
              .where(
                (e) =>
                    !(e.primaryMobileNumber ==
                            event.coapplicantData.primaryMobileNumber &&
                        e.applicantType == event.coapplicantData.applicantType),
              )
              .toList();

      emit(state.copyWith(coAppList: updatedList, status: SaveStatus.success));
    } catch (e) {
      print(e);
    }
  }

  addCoappOrGurantor(IsCoAppOrGurantorAdd event, Emitter emit) {
    if (event.onNext == true) {
      emit(
        state.copyWith(
          isApplicantsAdded: event.addapplicants,
          status: SaveStatus.success,
        ),
      );
    } else {
      emit(state.copyWith(isApplicantsAdded: event.addapplicants));
    }
  }

  Future<void> initCoAppDetailsPage(
    CoAppDetailsInitEvent event,
    Emitter emit,
  ) async {
    // fetch lov
    Database _db = await DBConfig().database;
    List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
    List<GeographyMaster> stateCityMaster = await GeographymasterCrudRepo(
      _db,
    ).getByColumnNames(
      columnNames: [
        TableKeysGeographyMaster.stateId,
        TableKeysGeographyMaster.cityId,
      ],
      columnValues: ['0', '0'],
    );

    print('listOfLov => $listOfLov');

    final customerType =
        listOfLov.where((lov) {
          if (lov.Header == 'CustType') {
            return lov.optvalue == '001' || lov.optvalue == '002';
          }
          return true;
        }).toList();

    emit(
      state.copyWith(lovList: customerType, stateCityMaster: stateCityMaster),
    );
  }

  Future<void> saveCoAppDetailsPage(
    CoAppDetailsSaveEvent event,
    Emitter emit,
  ) async {
    try {
      final updatedList = List<CoapplicantData>.from(state.coAppList);

      if (event.index != null && event.index! < updatedList.length) {
        updatedList[event.index!] = event.coapplicantData;
      } else {
        updatedList.add(event.coapplicantData);
      }

      emit(
        state.copyWith(
          coAppList: updatedList,
          status: SaveStatus.success,
          isApplicantsAdded: "Y",
          isCifValid: false,
        ),
      );
      draftSave(updatedList);
    } catch (e) {
      emit(state.copyWith(status: SaveStatus.failure, isCifValid: false));
    }
  }

  draftSave(List<CoapplicantData>? dataList) async {
    final draftService = DraftService();
    final coappList =
        dataList != null
            ? dataList.map((e) => e.toMap()).toList()
            : <Map<String, dynamic>>[];

    await draftService.saveOrUpdateTabData(
      tabKey: 'coapplicant',
      tabData: coappList,
    );
  }

  Future<void> getCityListBasedOnState(
    OnStateCityChangeEvent event,
    Emitter emit,
  ) async {
    /** 
     * @modified    : karthick.d 22/06/2025
     * 
     * @reson       : geograhy master parsing logic should be kept as function 
     *                so it the logic can be reused across various bLoC
     * 
     * @desc        : so geograpgy master fetching logic is reusable 
                      encapsulate geography master datafetching in citylist_repo_impl 
                      the desired statement definition as simple as calling the funtion 
                      and set the state
                      emit(state.copyWith(status:SaveStatus.loading));
                      await cityrepository.fetchCityList(
                              citydistrictrequest,
                          );
    */

    emit(state.copyWith(status: SaveStatus.loading));
    final CityDistrictRequest citydistrictrequest = CityDistrictRequest(
      stateCode: event.stateCode,
      cityCode: event.cityCode,
    );
    Cityrepository cityrepository = CitylistRepoImpl();
    AsyncResponseHandler response = await cityrepository.fetchCityList(
      citydistrictrequest,
    );
    CoappDetailsState coappDetailsState =
        mapGeographyMasterResponseForCoAppPage(state, response);
    emit(coappDetailsState);
  }

  /* 
fetching dedupe for co applicant reusing dedupe page cif search logic here

 */

  Future onSearchCif(CoAppGurantorSearchCifEvent event, Emitter emit) async {
    emit(state.copyWith(status: SaveStatus.loading));
    CifRepository dedupeRepository = CifRepositoryImpl();
    final response = await dedupeRepository.searchCif(event.request);
    if (response.isRight()) {
      CifResponse cifResponse = response.right;
      // map cifresponse to CoapplicantData so we can set data to form()
      CoapplicantData coapplicantDataFromCif = mapCoapplicantDataFromCif(
        cifResponse,
      );
      emit(
        state.copyWith(
          status: SaveStatus.dedupesuccess,
          selectedCoApp: coapplicantDataFromCif,
          isCifValid: true,
        ),
      );
    } else {
      print('cif failure response.left ');
      emit(state.copyWith(status: SaveStatus.dedupefailure, isCifValid: false));
    }
  }

  Future<void> validateAadaar(AadhaarValidateEvent event, Emitter emit) async {
    emit(state.copyWith(status: SaveStatus.loading));
    final AadharvalidateRequest aadharvalidateRequest = event.request;
    AadharvalidateRepo aadharvalidateRepo = AadharValidateImpl();
    var responseHandler = await aadharvalidateRepo.validateAadhar(
      request: aadharvalidateRequest,
    );
    if (responseHandler.isRight()) {
      // emit(
      //   state.copyWith(
      //     status: SaveStatus.init,
      //     aadhaarData: responseHandler.right,
      //   ),
      // );

      final coapplicantDataFromDedupe = mapCoappAndGurantorDataFromDedupe(
        responseHandler.right,
      );

      emit(
        state.copyWith(
          status: SaveStatus.dedupesuccess,
          selectedCoApp: coapplicantDataFromDedupe,
          isCifValid: true,
        ),
      );
    } else {
      emit(state.copyWith(status: SaveStatus.dedupefailure, isCifValid: false));
    }
  }

  Future<void> onScannerSuccess(
    ScannerResponseEvent event,
    Emitter emit,
  ) async {
    String aadhaarId = '';
    if (event.scannerResponse['aadhaarResponse']['@uid'] != null) {
      aadhaarId = event.scannerResponse['aadhaarResponse']['@uid'];
    } else {
      aadhaarId = event.scannerResponse['aadhaarResponse'];
    }
    final coapplicantDataFromDedupe = mapCoappAndGurantorDataFromDedupe(
      AadharvalidateResponse(referenceId: aadhaarId),
    );

    emit(
      state.copyWith(
        status: SaveStatus.dedupesuccess,
        selectedCoApp: coapplicantDataFromDedupe,
        isCifValid: true,
      ),
    );
  }

  Future<void> _onDedupeResponse(
    CoAppDetailsDedupeEvent event,
    Emitter emit,
  ) async {
    try {
      final coapplicantDataFromDedupe = mapCoappAndGurantorDataFromDedupe(
        event.coapplicantData,
      );

      emit(
        state.copyWith(
          status: SaveStatus.dedupesuccess,
          selectedCoApp: coapplicantDataFromDedupe,
          isCifValid: true,
        ),
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(status: SaveStatus.dedupefailure, isCifValid: false));
    }
  }

  // populate dedupe response to coapplicant form
  CoapplicantData mapCoappAndGurantorDataFromDedupe(dynamic response) {
    print('dedupe response: $response');
    String firstName = '';
    String middleName = '';
    String lastName = '';

    List<String> nameParts = (response?.name ?? '').trim().split(
      RegExp(r'\s+'),
    );

    if (nameParts.length >= 3) {
      firstName = nameParts[0];
      middleName = nameParts[1];
      lastName = nameParts.sublist(2).join(' ');
    } else if (nameParts.length == 2) {
      firstName = nameParts[0];
      lastName = nameParts[1];
    } else if (nameParts.length == 1) {
      firstName = nameParts[0];
    }

    String mobileno = '';
    if (response.mobile.length == 12 && response.mobile.startsWith("91")) {
      mobileno = response.mobile.substring(2);
    }

    final data = CoapplicantData(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      email: response.email ?? '',
      primaryMobileNumber: mobileno,
      // aadharRefNo: response.referenceId ?? '',
      aadharRefNo: response.referenceId ?? '',
      address1:
          (response.careOf?.isNotEmpty ??
                  false || response.street?.isNotEmpty ??
                  false)
              ? '${response.careOf ?? ''} ${response.street ?? ''}'.trim()
              : '',
      address2: response.landmark ?? '',
      pincode: response.pincode ?? '',

      dob: getCorrectDateFormat(response.dateOfBirth),
      state: getStateCode(response.state, state.stateCityMaster),
      cityDistrict: getStateCode(response.district, state.districtMaster),
    );
    return data;
  }

  // Search for the matching GeographyMaster based on stateName
  String getStateCode(String stateName, List<GeographyMaster>? list) {
    if (list == null || list.isEmpty) {
      return '';
    }

    GeographyMaster? geographyMaster = list.firstWhere(
      (val) => val.value.toLowerCase() == stateName.toLowerCase(),
      orElse:
          () => GeographyMaster(
            stateParentId: '',
            cityParentId: '',
            code: '',
            value: '',
          ),
    );

    if (geographyMaster.code.isEmpty) {
      return '';
    } else {
      print('getStateCode $geographyMaster');
      return geographyMaster.code;
    }
  }

  Future<void> onCoappandGauDetailsFetch(
    CoApplicantandGurantorFetchEvent event,
    Emitter emit,
  ) async {
    try {
      print('coapp: ${event.leadDetails}');

      final _db = await DBConfig().database;

      final listOfLov = await LovCrudRepo(_db).getAll();
      final stateCityMaster = await GeographymasterCrudRepo(
        _db,
      ).getByColumnNames(
        columnNames: [
          TableKeysGeographyMaster.stateId,
          TableKeysGeographyMaster.cityId,
        ],
        columnValues: ['0', '0'],
      );

      final List<CoapplicantData> coappandGauList = [];
      final List<GeographyMaster> cityMaster = [];
      final List<GeographyMaster> districtMaster = [];

      String coappAdded = 'N';

      if (event.leadDetails?.isNotEmpty ?? false) {
        final firstItem = event.leadDetails!.first;

        if (firstItem.containsKey('lldCoappfrstname')) {
          coappAdded = firstItem['lldCoappfrstname'] != null ? 'Y' : 'N';
        } else {
          coappAdded = 'Y';
        }
      }

      final List<CoapplicantData> coappData = [];
      final List<CoapplicantData> gaurantorData = [];

      if (coappAdded == 'Y') {
        for (final val in event.leadDetails ?? []) {
          if (val['applicantType'] == 'C' || val.containsKey('lldCoappCbsid')) {
            final mapped = mapCoApplicant(val);
            if (mapped != null) {
              coappData.add(mapped);
              coappandGauList.add(mapped);
            }
          } else {
            final mapped = mapGaurantor(val);
            if (mapped != null) {
              gaurantorData.add(mapped);
              coappandGauList.add(mapped);
            }
          }
        }

        if (coappData.isNotEmpty) {
          final coappCityList = await getCoappandGaurantorCityandDistrictList(
            coappData.first.state,
            null,
          );
          final coappDistrictList =
              await getCoappandGaurantorCityandDistrictList(
                coappData.first.state,
                coappData.first.cityDistrict,
              );

          cityMaster.addAll(coappCityList ?? []);
          districtMaster.addAll(coappDistrictList ?? []);
        }

        if (gaurantorData.isNotEmpty) {
          final gaurantorCityList =
              await getCoappandGaurantorCityandDistrictList(
                gaurantorData.first.state,
                null,
              );
          final gaurantorDistrictList =
              await getCoappandGaurantorCityandDistrictList(
                gaurantorData.first.state,
                gaurantorData.first.cityDistrict,
              );

          cityMaster.addAll(gaurantorCityList ?? []);
          districtMaster.addAll(gaurantorDistrictList ?? []);
        }

        final uniqueCities =
            {
              for (var city in cityMaster) city.cityParentId: city,
            }.values.toList();

        cityMaster
          ..clear()
          ..addAll(uniqueCities);
      }

      print("finally print cityMaster => $cityMaster");

      emit(
        state.copyWith(
          status: SaveStatus.success,
          lovList: listOfLov,
          stateCityMaster: stateCityMaster,
          isApplicantsAdded: coappAdded,
          coAppList: coappandGauList,
          cityMaster: cityMaster,
          districtMaster: districtMaster,
          getLead:
              event.leadDetails?.isNotEmpty == true &&
                      (event.leadDetails!.first.containsKey('lldCoappCbsid') ||
                          event.leadDetails!.first.containsKey('lldGuaCbsid'))
                  ? true
                  : false,
        ),
      );
    } catch (error) {
      print('coapprr: $error');
      emit(state.copyWith(status: SaveStatus.failure));
    }
  }

  CoapplicantData? mapCoApplicant(val) {
    try {
      CoapplicantData? coappData =
          val.containsKey('lldCoappCbsid')
              ? CoapplicantData(
                applicantType: 'C',
                customertype: val['lldCoappCbsid'] != null ? '002' : '001',
                cifNumber: val['lldCoappCbsid'],
                constitution: val['lldCoappConst'],
                title: val['lldCoappTitle'],
                firstName: val['lldCoappfrstname'],
                middleName: val['lldCoappmidname'],
                lastName: val['lldLastnameCoapplican'],
                dob: val['lldCoappdob'].toString(),
                relationshipFirm: val['lldCoappRelationFirm'],
                residentialStatus: val['lldCoappResidentStatus'],
                email: val['lldCoappemailid'],
                primaryMobileNumber: val['lldCoappmobno'],
                secondaryMobileNumber: val['lldCoappSecMobNo'],
                panNumber: val['lldCoapppanno'],
                aadharRefNo: val['lldCoappadharno'],
                address1: val['lldCoappaddress'],
                address2: val['lldCoappaddresslane1'],
                address3: val['lldCoappaddresslane2'],
                state: val['lldCoappstate'],
                cityDistrict: val['lldCoappcity'],
                pincode: val['lldCoapppinno'],
                loanLiabilityCount: val['lpcbscoborrLiabilityCount'],
                loanLiabilityAmount: val['lpcbscoborrLiabilityAmount'],
                depositCount: val['lpcbscoborrdepositCount'],
                depositAmount: val['lpcbscoborrdepositAmount'],
              )
              : val != null
              ? CoapplicantData.fromMap(val)
              : null;
      return coappData;
    } catch (error) {
      print("mapCoApplicant-error => $error");
      return null;
    }
  }

  CoapplicantData? mapGaurantor(val) {
    try {
      CoapplicantData? gaurantorData =
          val.containsKey('lldGuaCbsid')
              ? CoapplicantData(
                applicantType: 'G',
                customertype: val['lldGuaCbsid'] != null ? '002' : '001',
                cifNumber: val['lldGuaCbsid'],
                constitution: val['lleadGuaConst'],
                title: val['lleadGuTitle'],
                firstName: val['lldguafrstname'],
                middleName: val['lldguamidname'],
                lastName: val['lldgualastname'],
                dob: val['lldguadob'].toString(),
                relationshipFirm: val['lldGuaRelationFirm'],
                residentialStatus: val['lldGuaResidentStatus'],
                email: val['lldguaemailid'],
                primaryMobileNumber: val['lldguamobno'],
                secondaryMobileNumber: val['lldGuaSecMobNo'],
                panNumber: val['lldGuapanno'],
                aadharRefNo: val['lldGuaadharno'],
                address1: val['lldGuaaddress'],
                address2: val['lldGuaaddresslane1'],
                address3: val['lldGuaaddresslane2'],
                state: val['lldGuastate'],
                cityDistrict: val['lldGuacity'],
                pincode: val['lldGuapinno'],
                loanLiabilityCount: val['lpcbsgauLiabilityCount'],
                loanLiabilityAmount: val['lpcbsgauLiabilityAmount'],
                depositCount: val['lpcbsgaudepositCount'],
                depositAmount: val['lpcbsgaudepositAmount'],
              )
              : val != null
              ? CoapplicantData.fromMap(val)
              : null;
      ;
      return gaurantorData;
    } catch (error) {
      print("mapGaurantor-error => $error");
      return null;
    }
  }

  Future<List<GeographyMaster>?> getCoappandGaurantorCityandDistrictList(
    stateCode,
    cityCode,
  ) async {
    try {
      final CityDistrictRequest citydistrictrequest = CityDistrictRequest(
        stateCode: stateCode,
        cityCode: cityCode,
      );
      Cityrepository cityrepository = CitylistRepoImpl();
      AsyncResponseHandler response = await cityrepository.fetchCityList(
        citydistrictrequest,
      );

      Map<String, dynamic> _resp = response.right as Map<String, dynamic>;

      List<GeographyMaster> cityMaster =
          _resp['cityMaster'] != null && _resp['cityMaster'].isNotEmpty
              ? _resp['cityMaster'] as List<GeographyMaster>
              : [];
      List<GeographyMaster> districtMaster =
          _resp['districtMaster'] != null && _resp['districtMaster'].isNotEmpty
              ? _resp['districtMaster'] as List<GeographyMaster>
              : [];

      if (cityCode == null) {
        return cityMaster;
      } else {
        return districtMaster;
      }
    } catch (error) {
      print("mapGaurantor-error => $error");
      return null;
    }
  }
}
