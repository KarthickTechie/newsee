part of './cropyieldpage_bloc.dart';

enum CropPageStatus {init, loading, success, failure, set, reset}

class CropyieldpageState extends Equatable {
   final CropPageStatus? status;
    final List<Lov>? lovlist;
    final List<CropDetailsModal>? cropData;
    final String? errorMessage;
    final CropDetailsModal? selectedCropData;

  const CropyieldpageState({
    this.status,
    this.lovlist,
    this.cropData,
    this.errorMessage,
    this.selectedCropData,
  });

   factory CropyieldpageState.init() => CropyieldpageState(
    status: CropPageStatus.init,
    lovlist: [],
    cropData: null,
    errorMessage: null,
    selectedCropData: null
  );

  CropyieldpageState copyWith({
    CropPageStatus? status,
    List<Lov>? lovlist,
    List<CropDetailsModal>? cropData,
    String? errorMessage,
    CropDetailsModal? selectedCropData,
  }) {
    return CropyieldpageState(
      status: status ?? this.status,
      lovlist: lovlist ?? this.lovlist,
      cropData: cropData ?? this.cropData,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCropData: selectedCropData ?? this.selectedCropData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'lovlist': lovlist?.map((x) => x.toMap()).toList(),
      'cropData': cropData?.map((x) => x.toMap()).toList(),
      'errorMessage': errorMessage,
      'selectedCropData': selectedCropData?.toMap(),
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
    ];
  }

  factory CropyieldpageState.fromMap(Map<String, dynamic> map) {
    return CropyieldpageState(
      status: map['status'],
      lovlist: map['lovlist'] != null ? List<Lov>.from((map['lovlist'] as List<int>).map<Lov?>((x) => Lov.fromMap(x as Map<String,dynamic>),),) : null,
      cropData: map['cropData'] != null ? List<CropDetailsModal>.from((map['cropData'] as List<int>).map<CropDetailsModal?>((x) => CropDetailsModal.fromMap(x as Map<String,dynamic>),),) : null,
      errorMessage: map['errorMessage'] != null ? map['errorMessage'] as String : null,
      selectedCropData: map['selectedCropData'] != null ? CropDetailsModal.fromMap(map['selectedCropData'] as Map<String,dynamic>) : null,
    );
  }

  @override
  bool get stringify => true;
}
