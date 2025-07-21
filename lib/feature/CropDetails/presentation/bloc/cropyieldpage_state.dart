part of './cropyieldpage_bloc.dart';

enum CropPageStatus {init, loading, save, set, reset, success, failure}

class CropyieldpageState extends Equatable {
  final SaveStatus? status;
  final List<Lov>? lovlist;
  final List<CropDetailsModal>? cropData;
  String? errorMessage;
  final CropDetailsModal? selectedCropData;
  final Map<String,dynamic>? landDetails;
  final List<LandData>? landData;
  final bool showSubmit;

  CropyieldpageState({
    this.status,
    this.lovlist,
    this.cropData,
    this.errorMessage,
    this.selectedCropData,
    this.landDetails,
    this.landData,
    this.showSubmit = false
  });

   factory CropyieldpageState.init() => CropyieldpageState(
    status: SaveStatus.init,
    lovlist: [],
    cropData: null,
    errorMessage: null,
    selectedCropData: null,
    showSubmit: false
  );

  CropyieldpageState copyWith({
    SaveStatus? status,
    List<Lov>? lovlist,
    List<CropDetailsModal>? cropData,
    String? errorMessage,
    CropDetailsModal? selectedCropData,
    Map<String,dynamic>? landDetails,
    List<LandData>? landData,
    bool? showSubmit
  }) {
    return CropyieldpageState(
      status: status ?? this.status,
      lovlist: lovlist ?? this.lovlist,
      cropData: cropData ?? this.cropData,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCropData: selectedCropData ?? this.selectedCropData,
      landDetails: landDetails ?? this.landDetails,
      landData: landData ?? this.landData,
      showSubmit: showSubmit ?? this.showSubmit
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'lovlist': lovlist?.map((x) => x.toMap()).toList(),
      'cropData': cropData?.map((x) => x.toMap()).toList(),
      'errorMessage': errorMessage,
      'selectedCropData': selectedCropData?.toMap(),
      'landDetails': landDetails,
      'landData': landData?.map((x) => x.toMap()).toList(),
      'showSubmit': showSubmit
    };
  }

  @override
  List<Object?> get props {
    return [
      status,
      lovlist,
      cropData,
      errorMessage,
      selectedCropData,
      landDetails,
      landData,
      showSubmit
    ];
  }

  // factory CropyieldpageState.fromMap(Map<String, dynamic> map) {
  //   return CropyieldpageState(
  //     status: map['status'] != null ? CropPageStatus.fromMap(map['status'] as Map<String,dynamic>) : null,
  //     lovlist: map['lovlist'] != null ? List<Lov>.from((map['lovlist'] as List<int>).map<Lov?>((x) => Lov.fromMap(x as Map<String,dynamic>),),) : null,
  //     cropData: map['cropData'] != null ? List<CropDetailsModal>.from((map['cropData'] as List<int>).map<CropDetailsModal?>((x) => CropDetailsModal.fromMap(x as Map<String,dynamic>),),) : null,
  //     errorMessage: map['errorMessage'] != null ? map['errorMessage'] as String : null,
  //     selectedCropData: map['selectedCropData'] != null ? CropDetailsModal.fromMap(map['selectedCropData'] as Map<String,dynamic>) : null,
  //     landDetails: map['landDetails'] != null ? Map<String,dynamic>.from((map['landDetails'] as Map<String,dynamic>)) : null,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory CropyieldpageState.fromJson(String source) => CropyieldpageState.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // bool get stringify => true;

  // factory CropyieldpageState.fromMap(Map<String, dynamic> map) {
  //   return CropyieldpageState(
  //     status: map['status'] != null ? map['status'] as enum : null,
  //     lovlist: map['lovlist'] != null ? List<Lov>.from((map['lovlist'] as List<int>).map<Lov?>((x) => Lov.fromMap(x as Map<String,dynamic>),),) : null,
  //     cropData: map['cropData'] != null ? List<CropDetailsModal>.from((map['cropData'] as List<int>).map<CropDetailsModal?>((x) => CropDetailsModal.fromMap(x as Map<String,dynamic>),),) : null,
  //     errorMessage: map['errorMessage'] != null ? map['errorMessage'] as String : null,
  //     selectedCropData: map['selectedCropData'] != null ? CropDetailsModal.fromMap(map['selectedCropData'] as Map<String,dynamic>) : null,
  //     landDetails: map['landDetails'] != null ? Map<String,dynamic>.from((map['landDetails'] as Map<String,dynamic>) : null,
  //     landData: map['landData'] != null ? List<LandData>.from((map['landData'] as List<int>).map<LandData?>((x) => LandData.fromMap(x as Map<String,dynamic>),),) : null,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory CropyieldpageState.fromJson(String source) => CropyieldpageState.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // bool get stringify => true;
}
