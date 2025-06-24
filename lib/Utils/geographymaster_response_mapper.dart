import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/landholding/presentation/bloc/land_holding_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';

class GeographymasterResponseMapper<S> {
  final S? state;
  GeographymasterResponseMapper(this.state);

  factory GeographymasterResponseMapper.initial() =>
      GeographymasterResponseMapper(null);
  GeographymasterResponseMapper mapResponse(AsyncResponseHandler response) {
    List<GeographyMaster>? cityMaster = [];
    List<GeographyMaster>? districtMaster = [];
    GeographymasterResponseMapper responseMapper =
        GeographymasterResponseMapper.initial();
    Map<String, dynamic> _resp = response.right as Map<String, dynamic>;
    // map for LandHoldingState
    if (state is LandHoldingState) {
      cityMaster =
          _resp['cityMaster'] != null && _resp['cityMaster'].isNotEmpty
              ? _resp['cityMaster'] as List<GeographyMaster>
              : (state as LandHoldingState).cityMaster;
      districtMaster =
          _resp['districtMaster'] != null && _resp['districtMaster'].isNotEmpty
              ? _resp['districtMaster'] as List<GeographyMaster>
              : (state as LandHoldingState).districtMaster;
      responseMapper = GeographymasterResponseMapper(
        LandHoldingState(
          status: SaveStatus.mastersucess,
          cityMaster: cityMaster,
          districtMaster: districtMaster,
          lovlist: (state as LandHoldingState).lovlist,
          landData: (state as LandHoldingState).landData,
          selectedLandData: (state as LandHoldingState).selectedLandData,
          errorMessage: (state as LandHoldingState).errorMessage,
          stateCityMaster: (state as LandHoldingState).stateCityMaster,
        ),
      );
    } else if (state is AddressDetailsState) {
      // map for AddressDetailsState
      Map<String, dynamic> _resp = response.right as Map<String, dynamic>;

      List<GeographyMaster>? cityMaster =
          _resp['cityMaster'] != null && _resp['cityMaster'].isNotEmpty
              ? _resp['cityMaster'] as List<GeographyMaster>
              : (state as AddressDetailsState).cityMaster;
      List<GeographyMaster>? districtMaster =
          _resp['districtMaster'] != null && _resp['districtMaster'].isNotEmpty
              ? _resp['districtMaster'] as List<GeographyMaster>
              : (state as AddressDetailsState).districtMaster;
      // map
      responseMapper = GeographymasterResponseMapper(
        AddressDetailsState(
          status: SaveStatus.mastersucess,
          cityMaster: cityMaster,
          districtMaster: districtMaster,
          stateCityMaster: (state as AddressDetailsState).stateCityMaster,
          addressData: (state as AddressDetailsState).addressData,
          lovList: (state as AddressDetailsState).lovList,
        ),
      );
    } else if (state is CoappDetailsState) {
      Map<String, dynamic> _resp = response.right as Map<String, dynamic>;

      List<GeographyMaster>? cityMaster =
          _resp['cityMaster'] != null && _resp['cityMaster'].isNotEmpty
              ? _resp['cityMaster'] as List<GeographyMaster>
              : (state as CoappDetailsState).cityMaster;
      List<GeographyMaster>? districtMaster =
          _resp['districtMaster'] != null && _resp['districtMaster'].isNotEmpty
              ? _resp['districtMaster'] as List<GeographyMaster>
              : (state as CoappDetailsState).districtMaster;
      // map
      responseMapper = GeographymasterResponseMapper(
        CoappDetailsState(
          status: SaveStatus.mastersucess,
          cityMaster: cityMaster,
          districtMaster: districtMaster,
          stateCityMaster: (state as CoappDetailsState).stateCityMaster,
          lovList: (state as CoappDetailsState).lovList,
          coAppList: (state as CoappDetailsState).coAppList,
          selectedCoApp: (state as CoappDetailsState).selectedCoApp,
        ),
      );
    }
    return responseMapper;
  }
}
