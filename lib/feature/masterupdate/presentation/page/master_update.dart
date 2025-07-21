import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masterupdate/presentation/bloc/master_update_bloc.dart';

class MasterUpdate extends StatelessWidget{
  final bool diffMaster = true;

  updateMaster(context, MasterUpdateState state) async {
    try {
      Globalconfig.diffListOfMaster =  state.listOfMaster!;
      Globalconfig.masterUpdate = true;
      GoRouter.of(context).goNamed('masters');
    } catch (error) {
      print("updateMaster $error");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final globalLoadingBloc = context.read<GlobalLoadingBloc>();
    
    return BlocProvider(
      create: (context) => MasterUpdateBloc()..add(MasterVersionCheck()),
      child: BlocConsumer<MasterUpdateBloc, MasterUpdateState>(
        listener: (context, state) {
          if (state.status == SaveStatus.loading) {
            globalLoadingBloc.add(
              ShowLoading(message: "Fetching Masters Version..."),
            );
          } else {
            globalLoadingBloc.add(
              HideLoading(),
            );
          }
        },
        builder: (context, state) {
          return Card(
            child: state.masterDifferent? 
              Center(
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Current Master Version in not Upto date. Please Update your Master',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          updateMaster(context, state);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                ),
              ) 
              : 
              Center(
                child: Container(
                  width: 300,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text("Current Master version upto date"),
                )
              ),
          );
        }
      ),
    );
  }

}