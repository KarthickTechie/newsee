import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/feature/addressdetails/presentation/bloc/address_details_bloc.dart';
import 'package:newsee/feature/dedupe/presentation/bloc/dedupe_bloc.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/dedupe.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_product.dart';
import 'package:newsee/feature/leadsubmit/domain/modal/loan_type.dart';
import 'package:newsee/feature/leadsubmit/presentation/bloc/lead_submit_bloc.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/product_master.dart';
import 'package:newsee/feature/personaldetails/presentation/bloc/personal_details_bloc.dart';
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
  }) {
    String? loanAmountFormatted = personlData.loanAmountRequested?.replaceAll(
      ',',
      '',
    );
    PersonalData updatedPersonalData = personlData.copyWith(
      loanAmountRequested: loanAmountFormatted,
      occupationType: '01',
      agriculturistType: '1',
      farmerCategory: '2',
      religion: '3',
      caste: 'CAS000001',
      farmerType: '1',
      passportNumber: '431241131',
      residentialStatus: '4',
      sourceid: 'AGRI1124',
      sourcename: 'Meena',
      subActivity: '1.3',
    );

    LeadSubmitPushEvent leadSubmitPushEvent = LeadSubmitPushEvent(
      loanType: loanType,
      loanProduct: loanProduct,
      dedupe: dedupeData,
      personalData: updatedPersonalData,
      addressData: addressData,
    );
    context.read<LeadSubmitBloc>().add(leadSubmitPushEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false),
      body: BlocConsumer<LeadSubmitBloc, LeadSubmitState>(
        listener: (context, state) {
          if (state.leadSubmitStatus == SubmitStatus.success) {
            showSuccessBottomSheet(
              context,
              ApiConstants.api_response_success,
              "Lead ID : ${state.leadId}",
              "Lead details successfully submitted",
            );
          } else if (state.leadSubmitStatus == SubmitStatus.failure) {
            showSuccessBottomSheet(
              context,
              ApiConstants.api_response_failure,
              "Lead ID Not Generated",
              "Lead details submittion failed..!!",
            );
          }
        },
        builder: (context, state) {
          final personalDetailsBloc = context.watch<PersonalDetailsBloc?>();
          final loanproductBloc = context.watch<LoanproductBloc?>();
          final addressBloc = context.watch<AddressDetailsBloc?>();
          final dedupeBloc = context.watch<DedupeBloc?>();

          final personalState = personalDetailsBloc?.state;

          final loanproductState = loanproductBloc?.state;
          final addressState = addressBloc?.state;
          final dedupeState = dedupeBloc?.state;

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
          print('addressData-------------->$addressData');
          return ListView(
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
                      context: context,
                    )
                    : showNoDataCard(),
          );
        },
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
    required BuildContext context,
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
                value: "Applicant | Existing Customer",
              ),
              SysmoTitle(
                icon: Icons.badge,
                label: "Product",
                value: '${productMaster.prdCode} - ${productMaster.prdDesc}',
              ),
              SysmoTitle(icon: Icons.details, label: "CIF ID", value: "121212"),
              SysmoTitle(
                icon: Icons.currency_rupee,
                label: "Loan Amount",
                value: formatAmount('${personalData.loanAmountRequested}'),
              ),
              SysmoTitle(
                icon: Icons.location_on,
                label: "Location",
                value: "Chennai",
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 20),
      Center(
        child: ElevatedButton.icon(
          onPressed: () {
            submitLead(
              personlData: personalData,
              addressData: addressData,
              loanProduct: loanProduct,
              loanType: loanType,
              dedupeData: dedupeData,
              context: context,
            );
            // show this success bottomsheet when leadsubmitstatus.success
            // showSuccessBottomSheet(
            //   context,
            //   "Submitted",
            //   "Lead ID : LEAD/202526/00008213",
            //   "Lead details successfully submitted",
            // );
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
                TextSpan(text: 'LEND', style: TextStyle(color: Colors.white)),
                TextSpan(
                  text: 'perfect',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
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

  List<Widget> showNoDataCard() {
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
