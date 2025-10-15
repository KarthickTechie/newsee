abstract class PayslipEvent {}

class LoadPayslipEvent extends PayslipEvent {
  final Map<String, dynamic> payslipdata;

  LoadPayslipEvent({required this.payslipdata});
}