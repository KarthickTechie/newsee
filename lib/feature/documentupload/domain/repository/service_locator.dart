import 'package:get_it/get_it.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerFactory(() => DocumentBloc());
}
