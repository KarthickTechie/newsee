import 'package:equatable/equatable.dart';
import 'package:newsee/AppData/app_constants.dart';

enum MpinStatus { init, loading, success, failure }

class MpinState extends Equatable {
  final List<String> mpin;
  final List<String> confirmMpin;
  final SaveStatus status;
  final String errorMessage;

  const MpinState({
    this.mpin = const ['', '', '', ''],
    this.confirmMpin = const ['', '', '', ''],
    this.status = SaveStatus.init,
    this.errorMessage = '',
  });

  MpinState copyWith({
    List<String>? mpin,
    List<String>? confirmMpin,
    SaveStatus? status,
    String? errorMessage,
  }) {
    return MpinState(
      mpin: mpin ?? this.mpin,
      confirmMpin: confirmMpin ?? this.confirmMpin,
      status: status ?? this.status,
      errorMessage: errorMessage ?? '',
    );
  }

  @override
  List<Object?> get props => [mpin, confirmMpin, status, errorMessage];
}
