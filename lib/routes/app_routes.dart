import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_route_constants.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/camera_view.dart';

import 'package:newsee/AppSamples/ReactiveForms/view/loginpage_view.dart';
import 'package:newsee/Utils/media_service.dart';
import 'package:newsee/blocs/camera/camera_bloc.dart';
import 'package:newsee/blocs/camera/camera_event.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/feature/CropDetails/presentation/page/cropdetailspage.dart';
import 'package:newsee/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:newsee/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/pages/document_page.dart';
import 'package:newsee/feature/documentupload/presentation/widget/image_view.dart';
import 'package:newsee/feature/landholding/presentation/page/land_holding_page.dart';
import 'package:newsee/feature/leadInbox/domain/modal/get_lead_response.dart';
import 'package:newsee/feature/masters/data/repository/master_repo_impl.dart';
import 'package:newsee/feature/masters/domain/modal/master_version.dart';
import 'package:newsee/feature/masters/domain/repository/master_repo.dart';
import 'package:newsee/feature/masters/presentation/bloc/masters_bloc.dart';
import 'package:newsee/feature/masters/presentation/page/masters_page.dart';
import 'package:newsee/feature/cic_check/cic_check_page.dart';
import 'package:newsee/feature/speech_text/bloc/speech.bloc.dart';
import 'package:newsee/pages/field_inspection_page.dart';
import 'package:newsee/pages/home_page.dart';
import 'package:newsee/pages/newlead_page.dart';
import 'package:newsee/pages/not_found_error.page.dart';
import 'package:newsee/pages/profile_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../feature/documentupload/presentation/bloc/document_event.dart';

final AuthRemoteDatasource _authRemoteDatasource = AuthRemoteDatasource(
  dio: ApiClient().getDio(),
);
final AuthRepository = AuthRepositoryImpl(
  authRemoteDatasource: _authRemoteDatasource,
);

final routes = GoRouter(
  // initial location changed to test masters feature , to see login page
  // modify the initialLocation
  initialLocation: AppRouteConstants.LOGIN_PAGE['path'],

  routes: <RouteBase>[
    GoRoute(
      path: AppRouteConstants.LOGIN_PAGE['path']!,
      name: AppRouteConstants.LOGIN_PAGE['name'],
      builder:
          (context, state) => PopScope(
            canPop: false,
            onPopInvokedWithResult: (didpop, data) async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Confirm'),
                      content: Text('Do you want to Exit ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes'),
                        ),
                      ],
                    ),
              );
              if (shouldPop ?? false) {
                await SystemNavigator.pop();
                // context.go('/'); // Navigate back using GoRouter
              }
            },
            child: Scaffold(
              body: BlocProvider(
                create: (_) => AuthBloc(authRepository: AuthRepository),
                child: LoginpageView(),
              ),
            ),
          ),
    ),
    GoRoute(
      path: AppRouteConstants.HOME_PAGE['path']!,
      name: AppRouteConstants.HOME_PAGE['name'],
      builder: (context, state) {
        final tabdata = (state.extra as Map<String, dynamic>?)?['tabdata']!;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder:
                  (dialogcontext) => AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogcontext).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogcontext).pop(true),
                        child: Text('Yes'),
                      ),
                    ],
                  ),
            );
            if (shouldPop ?? false) {
              context.push('/login');
              // closes the app
              // context.go('/'); // Navigate back using GoRouter
            }
          },
          child: Scaffold(
            body: BlocProvider(
              create: (_) => AuthBloc(authRepository: AuthRepository),
              child: tabdata == null ? HomePage() : HomePage(tabdata: tabdata),
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRouteConstants.NEWLEAD_PAGE['path']!,
      name: AppRouteConstants.NEWLEAD_PAGE['name'],
      builder: (context, state) {
        final GetLeadResponse? leadData =
            (state.extra as Map<String, dynamic>?)?['leadData']!;
        return NewLeadPage(fullLeadData: leadData);
      },
    ),
    GoRoute(
      path: AppRouteConstants.MASTERS_PAGE['path']!,
      name: AppRouteConstants.MASTERS_PAGE['name'],
      builder: (context, state) => MastersPage(),
    ),
    GoRoute(
      path: AppRouteConstants.PROFILE_PAGE['path']!,
      name: AppRouteConstants.PROFILE_PAGE['name'],
      builder: (context, state) => ProfilePage(),
    ),
    GoRoute(
      path: AppRouteConstants.CIC_CHECK_PAGE['path']!,
      name: AppRouteConstants.CIC_CHECK_PAGE['name'],
      builder: (context, state) => CicCheckPage(),
    ),
    GoRoute(
      path: AppRouteConstants.CAMERA_PAGE['path']!,
      name: AppRouteConstants.CAMERA_PAGE['name'],
      builder:
          (context, state) => Scaffold(
            body: BlocProvider(
              create: (_) => CameraBloc()..add(CameraOpen()),
              lazy: false,
              child: CameraView(),
            ),
          ),
    ),
    GoRoute(
      path: AppRouteConstants.LAND_HOLDING_PAGE['path']!,
      name: AppRouteConstants.LAND_HOLDING_PAGE['name'],
      builder: (context, state) {
        final proposalnumber =
            (state.extra as Map<String, dynamic>?)?['proposalNumber'] as String;
        final applicantname =
            (state.extra as Map<String, dynamic>?)?['applicantName'] as String;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didpop, data) async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Do you want to Exit ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Yes'),
                      ),
                    ],
                  ),
            );
            if (shouldPop ?? false) {
              Navigator.of(context).pop(false);
              // context.go('/'); // Navigate back using GoRouter
            }
          },
          child: LandHoldingPage(
            title: 'Land Holding Details',
            proposalNumber: proposalnumber,
            applicantName: applicantname,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRouteConstants.DOCUMENT_PAGE['path']!,
      name: AppRouteConstants.DOCUMENT_PAGE['name'],

      builder: (context, state) {
        final extra = state.extra as String?;
        final proposalNumber = extra ?? '';
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didpop, data) async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Do you want to Exit ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Yes'),
                      ),
                    ],
                  ),
            );
            if (shouldPop ?? false) {
              Navigator.of(context).pop(false);
            }
          },
          child: BlocProvider(
            create:
                (_) => DocumentBloc(mediaService: MediaService())
                  ..add(FetchDocumentsEvent(proposalNumber: proposalNumber)),
            lazy: false,
            child: DocumentPage(proposalnumber: proposalNumber),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRouteConstants.CROP_DETAILS_PAGE['path']!,
      name: AppRouteConstants.CROP_DETAILS_PAGE['name'],
      builder: (context, state) {
        final proposalNumber = state.extra as String;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didpop, data) async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Do you want to Exit ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Yes'),
                      ),
                    ],
                  ),
            );
            if (shouldPop ?? false) {
              Navigator.of(context).pop(false);
            }
          },
          child: CropDetailsPage(
            title: 'Crop Details',
            proposalnumber: proposalNumber,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRouteConstants.IMAGE_VIEW_PAGE['path']!,
      name: AppRouteConstants.IMAGE_VIEW_PAGE['name'],
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return Scaffold(
          body: BlocProvider(
            create: (_) => DocumentBloc(mediaService: MediaService()),
            lazy: false,
            child: ImageView(
              imageBytes: data['imageBytes'] as Uint8List,
              docIndex: data['docIndex'] as int,
              isUploaded: (data['isUploaded'] as bool?) ?? false,
              imgIndex:
                  data['imgIndex'] != null ? data['imgIndex'] as int : null,
            ),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRouteConstants.FieldInspect_Page['path']!,
      name: AppRouteConstants.FieldInspect_Page['name'],
      builder:
          (context, state) => BlocProvider(
            create: (context) => SpeechBloc(stt.SpeechToText()),
            child: FieldInspectionPage(),
          ),
    ),
  ],
  redirect: (context, state) {
    print(state.fullPath);
    if (state.fullPath == '/') {
      return AppRouteConstants.MASTERS_PAGE['path'];
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => NotFoundErrorPage(),
);
