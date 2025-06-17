abstract class GlobalLoadingEvent {}

class ShowLoading extends GlobalLoadingEvent {
  final String? message;
  ShowLoading({required this.message});
}

class HideLoading extends GlobalLoadingEvent {}
