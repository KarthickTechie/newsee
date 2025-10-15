import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/feature/salary_slip/bloc/payslip_event.dart';
import 'package:newsee/feature/salary_slip/bloc/payslip_state.dart';

class PayslipBloc  extends Bloc<PayslipEvent,PayslipState>{
  PayslipBloc() : super(PayslipState.initial()) {
    on<LoadPayslipEvent>(_onLoadPayslipEvent);
  }

  Future<void> _onLoadPayslipEvent(LoadPayslipEvent event, Emitter<PayslipState> emit) async {
    emit(state.copyWith(payslipData: event.payslipdata, saveStatus: SaveStatus.success));
  }
}