import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/app_route_constants.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/Utils/proposal_utils.dart';
import 'package:newsee/Utils/shared_preference_handler.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/coapplicant/presentation/bloc/coapp_details_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/dedupe.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_product.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_type.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/proposal_creation_request.dart';
import 'package:newsee/feature/leadsubmit/presentation/bloc/lead_submit_bloc.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
import 'package:newsee/widgets/application_card.dart';
import 'package:newsee/widgets/bottom_sheet.dart';
import 'package:newsee/widgets/productcard.dart';
import 'package:newsee/widgets/success_bottom_sheet.dart';
import 'package:newsee/widgets/sysmo_notification_card.dart';
import 'package:newsee/widgets/sysmo_title.dart';
import 'package:newsee/widgets/sysmo_title1.dart';

class LeadSubmitPage extends StatelessWidget {
  final String title;
  // late final PersonalDetailsState? personalState;
  // late final LoanproductState? loanproductState;
  // late final AddressDetailsState? addressState;
  // late final DedupeState? dedupeState;

  LeadSubmitPage({required this.title, super.key});

  submitLead({
    required BuildContext context,
    required PersonalData personlData,
    required LoanType loanType,
    required LoanProduct loanProduct,
    required Dedupe dedupeData,
    required AddressData addressData,
    required List<CoapplicantData> coAppAndGurantorData,
    required isAddCoappGurantor,
  }) async {
    String? loanAmountFormatted = personlData.loanAmountRequested?.replaceAll(
      ',',
      '',
    );

    UserDetails? userDetails = await loadUser();
    PersonalData updatedPersonalData = personlData.copyWith(
      loanAmountRequested: loanAmountFormatted,
      passportNumber: '431241131',
      sourceid: userDetails?.LPuserID,
      sourcename: userDetails?.UserName,
    );

    LeadSubmitPushEvent leadSubmitPushEvent = LeadSubmitPushEvent(
      loanType: loanType,
      loanProduct: loanProduct,
      dedupe: dedupeData,
      personalData: updatedPersonalData,
      addressData: addressData,
      coAppAndGurantorData: coAppAndGurantorData,
      isAddCoappGurantor: isAddCoappGurantor,
    );
    context.read<LeadSubmitBloc>().add(leadSubmitPushEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false),
      body: BlocConsumer<LeadSubmitBloc, LeadSubmitState>(
        listener: (context, state) {
          if (state.leadSubmitStatus == SubmitStatus.success &&
              state.proposalSubmitStatus == SaveStatus.init) {
            showSuccessBottomSheet(
              context: context,
              headerTxt: ApiConstants.api_response_success,
              lead: "Lead ID : ${state.leadId}",
              message: "Lead details successfully submitted",
              leftButtonLabel: 'Go To Inbox',
              rightButtonLabel: 'Create Proposal',
              status: state.proposalSubmitStatus,
              onPressedLeftButton: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              onPressedRightButton: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }, // OnPressedRightButton,
            );
          } else if (state.leadSubmitStatus == SubmitStatus.failure) {
            showSuccessBottomSheet(
              context: context,
              headerTxt: ApiConstants.api_response_failure,
              lead: "Lead ID Not Generated",
              message: "Lead details submittion failed..!!",
              leftButtonLabel: 'Cancel',
              rightButtonLabel: 'Ok',
              onPressedLeftButton: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              onPressedRightButton: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
            );
          }
          if (state.proposalSubmitStatus == SaveStatus.success) {
            // close the last lead success bottomSheet
            closeBottomSheetIfExists(context);

            showSuccessBottomSheet(
              context: context,
              headerTxt: ApiConstants.api_response_success,
              lead: "Proposal No : ${state.proposalNo}",
              message: "Proposal successfully Created for ${state.leadId}",
              onPressedLeftButton: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              onPressedRightButton: () {
                final applicantData =
                    state.leadSubmitRequest?.individualNonIndividualDetails;
                final applicantName =
                    '${applicantData?.firstName} ${applicantData?.lastName}';
                context.pushNamed(
                  'landholdings',
                  extra: {
                    'proposalNumber': state.proposalNo,
                    'applicantName': applicantName,
                  },
                );
              },
              leftButtonLabel: 'Go To Inbox',
              rightButtonLabel: 'Go To LandHolding',
            );
          } else if (state.proposalSubmitStatus == SaveStatus.failure) {
            print("state.proposalSubmitStatus == SaveStatus.failure");
            showSuccessBottomSheet(
              context: context,
              headerTxt: ApiConstants.api_response_failure,
              lead: "Proposal Not Generated for ${state.leadId}",
              message: "Proposal submittion failed..!!",
              leftButtonLabel: 'Cancel',
              rightButtonLabel: 'Ok',
              onPressedLeftButton: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              onPressedRightButton: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            );
          }
        },
        builder: (context, state) {
          final personalDetailsBloc = context.watch<PersonalDetailsBloc?>();
          final loanproductBloc = context.watch<LoanproductBloc?>();
          final addressBloc = context.watch<AddressDetailsBloc?>();
          final dedupeBloc = context.watch<DedupeBloc?>();
          final coguappBloc = context.watch<CoappDetailsBloc?>();

          final personalState = personalDetailsBloc?.state;

          final loanproductState = loanproductBloc?.state;
          final addressState = addressBloc?.state;
          final dedupeState = dedupeBloc?.state;
          final coguappState = coguappBloc?.state;

          LoanType loanType = LoanType(
            typeOfLoan: loanproductState?.selectedProductScheme?.optionValue,
          );

          LoanProduct loanProduct = LoanProduct(
            mainCategory: loanproductState?.selectedMainCategory?.lsfFacId,
            subCategory: loanproductState?.selectedSubCategoryList?.lsfFacId,
            producrId: loanproductState?.selectedProduct?.prdCode,
          );
          Dedupe dedupeData = Dedupe(
            existingCustomer: dedupeState?.isNewCustomer != null ? false : true,
            cifNumber: dedupeState?.cifResponse?.lldCbsid,
            constitution: dedupeState?.constitution,
          );
          PersonalData? personalData = personalState?.personalData;
          AddressData? addressData = addressState?.addressData;
          List<CoapplicantData>? coguappData = coguappState?.coAppList;
          String? isWhetherAddCoappGurantor = coguappState?.isApplicantsAdded;

          print('addressData-------------->$addressData');
          return state.leadId == null
              ? ListView(
                padding: const EdgeInsets.all(16),

                children:
                    (personalData != null &&
                            loanproductState?.selectedProduct != null &&
                            addressData != null)
                        ? showLeadSubmitCard(
                          personalData: personalData,
                          addressData: addressData,
                          loanType: loanType,
                          loanProduct: loanProduct,
                          dedupeData: dedupeData,
                          productMaster:
                              loanproductBloc?.state.selectedProduct
                                  as ProductMaster,
                          coguappData: coguappData,
                          isAddCoappGurantor: isWhetherAddCoappGurantor,
                          context: context,
                          status: state.leadSubmitStatus,
                        )
                        : showNoDataCard(context),
              )
              : ApplicationCard(
                leadId: state.leadId != null ? state.leadId! : '',
                status: state.proposalSubmitStatus,
                onProceedPressed: () {
                  createProposal(context, state);
                },
              );
        },
      ),
    );
  }

  void createProposal(BuildContext context, LeadSubmitState state) {
    // when lead is submitted success
    if (state.proposalSubmitStatus == SaveStatus.init &&
        state.leadId != null &&
        state.proposalNo == null) {
      context.read<LeadSubmitBloc>().add(
        CreateProposalEvent(
          proposalCreationRequest: ProposalCreationRequest(
            leadId: state.leadId,
          ),
        ),
      );
    } else if (state.proposalNo != null) {
      final applicantData =
          state.leadSubmitRequest?.individualNonIndividualDetails;
      final applicantName =
          '${applicantData?.firstName} ${applicantData?.lastName}';

      context.pushNamed(
        'landholdings',
        extra: {
          'proposalNumber': state.proposalNo,
          'applicantName': applicantName,
        },
      );
    }
  }

  void openProposalSheet(BuildContext context, LeadSubmitState state) {
    return openBottomSheet(
      context,
      0.5,
      0.5,
      0.9,
      (context, ctrl) => Card(
        margin: const EdgeInsets.all(6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Creating Propsal Please Wait...",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Lead ID : ${state.leadId}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 10),
              SizedBox(width: MediaQuery.of(context).size.width),
              CircularProgressIndicator(
                constraints: BoxConstraints(minWidth: 50, minHeight: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> showLeadSubmitCard({
    required PersonalData personalData,
    required AddressData addressData,
    required LoanProduct loanProduct,
    required LoanType loanType,
    required Dedupe dedupeData,
    required ProductMaster productMaster,
    required List<CoapplicantData>? coguappData,
    required String? isAddCoappGurantor,
    required BuildContext context,
    required status,
  }) {
    return <Widget>[
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SysmoTitle(
                icon: Icons.face,
                label: "Name",
                value: '${personalData.firstName} ${personalData.lastName}',
              ),
              SysmoTitle(
                icon: Icons.person,
                label: "Type",
                value:
                    dedupeData.cifNumber != null ||
                            dedupeData.cifNumber!.isNotEmpty
                        ? "Applicant | Existing Customer"
                        : "Applicant | New Customer",
              ),
              SysmoTitle(
                icon: Icons.badge,
                label: "Product",
                value: '${productMaster.prdCode} - ${productMaster.prdDesc}',
              ),
              SysmoTitle(
                icon: Icons.details,
                label: "CIF ID",
                value: dedupeData.cifNumber!,
              ),
              SysmoTitle(
                icon: Icons.currency_rupee,
                label: "Loan Amount",
                value: formatAmount('${personalData.loanAmountRequested}'),
              ),
              SysmoTitle(
                icon: Icons.location_on,
                label: "Location",
                value: addressData.cityDistrict!,
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 20),
      status == SubmitStatus.loading
          ? ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 75, 33, 83),
            ),
            child: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ),
          )
          : Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // submitLead(
                //   personlData: personalData,
                //   addressData: addressData,
                //   loanProduct: loanProduct,
                //   loanType: loanType,
                //   dedupeData: dedupeData,
                //   coAppAndGurantorData: coguappData!,
                //   isAddCoappGurantor: isAddCoappGurantor,
                //   context: context,
                // );
                showSuccessBottomSheet(
              context: context,
              headerTxt: ApiConstants.api_response_success,
              lead: "Lead ID : LEAD/202526/00009014",
              message: "Lead details successfully submitted",
              leftButtonLabel: 'Go To Inbox',
              rightButtonLabel: 'Close',
              // status: state.proposalSubmitStatus,
              onPressedLeftButton: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              onPressedRightButton: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }, // OnPressedRightButton,
            );
              },
              icon: Icon(Icons.send, color: Colors.white),
              label: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(text: 'Push to '),
                    TextSpan(
                      text: 'LEND',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'perfect',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  Size(double.infinity, 50),
                ),
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 75, 33, 83),
                ),
              ),
            ),
          ),
    ];
  }

  /* 

incase of incomplete dataentry show no data card

*/
  List<Widget> showNoDataCard(BuildContext context) {
    return <Widget>[
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SysmoNotificationCard(
                icon: Icons.close,
                label: "No Data",
                value: 'Please complete Personal and Address Details...!!',
                infoicon: Icons.info,
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
