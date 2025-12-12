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
import 'package:newsee/feature/CropDetails/presentation/bloc/cropyieldpage_bloc.dart';
import 'package:newsee/feature/CropDetails/presentation/page/cropdetailspage.dart';
import 'package:newsee/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:newsee/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/bloc/document_bloc.dart';
import 'package:newsee/feature/documentupload/presentation/pages/document_page.dart';
import 'package:newsee/feature/documentupload/presentation/widget/image_view.dart';
import 'package:newsee/feature/landholding/presentation/bloc/land_holding_bloc.dart';
import 'package:newsee/feature/landholding/presentation/page/land_holding_page.dart';
import 'package:newsee/feature/masters/presentation/page/masters_page.dart';
import 'package:newsee/feature/cic_check/presentation/cic_check_page.dart';
import 'package:newsee/feature/queryInbox/presentation/page/chat_widget.dart';
import 'package:newsee/feature/queryInbox/presentation/page/query_inbox.dart';
import 'package:newsee/pages/home_page.dart';
import 'package:newsee/pages/newlead_page.dart';
import 'package:newsee/pages/not_found_error.page.dart';
import 'package:newsee/pages/profile_page.dart';

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
              if (didpop) return;
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
            // child: Scaffold(
            //   body: BlocProvider(
            //     create: (_) => AuthBloc(authRepository: AuthRepository),
            //     child: LoginpageView(),
            //   ),
            // ),
            child: Scaffold(body: LoginpageView()),
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
            if (didPop) return;
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
        // final GetLeadResponse? leadData = (state.extra as Map<String,dynamic>?)?['leadData']!;
        final data = (state.extra as Map<String, dynamic>?) ?? {};

        return NewLeadPage(
          fullLeadData: data['leadData'],
          tabType: data['tabType'] != null ? data['tabType'] as String : null,
        );
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
      path: AppRouteConstants.QUERY_INBOX_PAGE['path']!,
      name: AppRouteConstants.QUERY_INBOX_PAGE['name'],
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        print('here....$data...${state.extra}');
        final title = data?['title'] ?? "No Title";
        final body = data?['body'] ?? "No Body";

        return QueryInbox(title: title, body: body);
      },
    ),
    GoRoute(
      path: AppRouteConstants.ChatWindow['path']!,
      name: AppRouteConstants.ChatWindow['name'],
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        print('here....$data...${state.extra}');
        final title = data?['title'] ?? "No Title";
        final body = data?['body'] ?? "No Body";
        final queryId = data?['queryId'] ?? "";
        final proposalNo = num.tryParse("${data?['proposalNo']}") ?? 0;

        return ChatWidget(
          queryId: queryId,
          status: 'Open',
          proposalNo: proposalNo,
          queryType: body,
          userName: title,
        );
      },
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
        final custId =
            (state.extra as Map<String, dynamic>?)?['custId'] as String;
        final isCompleted =
            (state.extra as Map<String, dynamic>?)?['isCompleted'] as bool;
        return BlocProvider(
          create:
              (_) =>
                  LandHoldingBloc()..add(
                    LandHoldingInitEvent(
                      proposalNumber: proposalnumber,
                      custId: custId,
                    ),
                  ),
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didpop, data) async {
              if (didpop) return;
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
              custId: custId,
              applicantName: applicantname,
              isCompleted: isCompleted,
            ),
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
          onPopInvokedWithResult: (didPop, result) async {
            // Prevent multiple dialogs
            if (didPop) return;

            final shouldPop = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text('Do you want to exit?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
            );

            if (shouldPop ?? false) {
              Navigator.of(context).pop(); // exit the page
            }
          },
          child: BlocProvider(
            create: (_) => DocumentBloc(mediaService: MediaService()),
            child: DocumentPage(proposalnumber: proposalNumber),
          ),
        );
      },
    ),

    GoRoute(
      path: AppRouteConstants.CROP_DETAILS_PAGE['path']!,
      name: AppRouteConstants.CROP_DETAILS_PAGE['name'],
      builder: (context, state) {
        final proposalNumber =
            (state.extra as Map<String, dynamic>?)?['proposal'] as String;
        final isCompleted =
            (state.extra as Map<String, dynamic>?)?['isCompleted'] as bool;
        return BlocProvider(
          create:
              (_) =>
                  CropyieldpageBloc()
                    ..add(CropPageInitialEvent(proposalNumber: proposalNumber)),
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didpop, data) async {
              if (didpop) return;
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
              isCompleted: isCompleted,
            ),
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
