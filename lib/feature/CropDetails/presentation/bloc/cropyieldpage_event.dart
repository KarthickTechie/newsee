part of './cropyieldpage_bloc.dart';

class CropyieldpageEvent {

}

class CropPageInitialEvent extends CropyieldpageEvent {
  
}

class CropFormSaveEvent extends CropyieldpageEvent {
   final CropDetailsModal cropData;
  CropFormSaveEvent({required this.cropData});
}

class CropDetailsSetEvent extends CropyieldpageEvent {
  final CropDetailsModal cropData;
  CropDetailsSetEvent({required this.cropData});
}

class CropDetailsResetEvent extends CropyieldpageEvent{}
