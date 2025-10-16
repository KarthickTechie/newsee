import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/offline_data_provider.dart';

class RbIHLandCrop extends StatefulWidget {
  const RbIHLandCrop({Key? key}) : super(key: key);

  @override
  RbIHLandCropState createState() => RbIHLandCropState();
}

class RbIHLandCropState extends State<RbIHLandCrop> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>>? ownerData;
  List<Map<String, dynamic>>? mortgageDetailsList;
  List<Map<String, dynamic>>? cropYieldDetailsList;
  String status = 'Not Submit';

  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Show bottom sheet when the page is navigated to
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

  // Function to show bottom sheet
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSheetSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter Details',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _field1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Village code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _field2Controller,
                    decoration: const InputDecoration(
                      labelText: 'ulpin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  status == 'loading'
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                              50, // Fixed height
                            ),
                            maximumSize: Size(
                              MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                              50, // Fixed height
                            ),
                          ),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2
                          )
                        )
                      : Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                status = 'loading'; // Update status in parent state
                              });
                              bottomSheetSetState(() {
                                // Ensure bottom sheet rebuilds to show loading
                              });
                              Future.delayed(const Duration(seconds: 3), () async {
                                await _loadData(); // Call _loadData
                                setState(() {
                                  status = 'loaded'; // Update status after loading
                                });
                                bottomSheetSetState(() {
                                  // Ensure bottom sheet rebuilds after loading
                                });
                                if (mounted) {
                                  Navigator.pop(context); // Close the bottom sheet
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                                50, // Fixed height
                              ),
                              maximumSize: Size(
                                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                                50, // Fixed height
                              ),
                            ),
                            child:  Text(
                              'Search',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16.0),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Function to load and parse JSON data
  Future<void> _loadData() async {
    try {
      final response = await offlineDataProvider(path: AppConstants.rhIHLandCropResponse);
      if (response != null) {
        final jsonData = response.data;
        final data = jsonData['data']['data'] as Map<String, dynamic>;

        setState(() {
          print("_loadData response $response");
          // Assuming the JSON structure has these keys

          // ownerData = (response.data['data']['data']['landOwnerDetails'] as List<dynamic>?)?.map((item) {
          //   return Map<String, dynamic>.from(item as Map);
          // }).toList() ?? [];
          final List<dynamic> landOwnerDetails = response.data['data']['data']['landOwnerDetails'];

          ownerData = (landOwnerDetails as List<dynamic>?)?.map((item) => item as Map<String, dynamic>).toList() ?? [];

          final List<dynamic> mortageData = response.data['data']['data']['farmRiskParams']['mortgageDetails']['addlremarks'];

          mortgageDetailsList = (mortageData as List<dynamic>?)?.map((item) => item as Map<String, dynamic>).toList() ?? [];

          // mortgageDetailsList = (response.data['data']['data']['farmRiskParams']['mortgageDetails'] as List<dynamic>?)?.map((item) {
          //   return Map<String, dynamic>.from(item as Map);
          // }).toList() ?? [];

          final List<dynamic> cryieldDetails = response.data['data']['data']['cropYieldDetails']['cropDetail'];

          cropYieldDetailsList = (cryieldDetails as List<dynamic>?)?.map((item) => item as Map<String, dynamic>).toList() ?? [];


          // cropYieldDetailsList = (response.data['data']['data']['cropYieldDetails'] as List<dynamic>?)?.map((item) {
          //   return Map<String, dynamic>.from(item as Map);
          // }).toList() ?? [];

          print("ownerData $ownerData");
          print("mortgageDetailsList $mortgageDetailsList");
          print("cropYieldDetailsList $cropYieldDetailsList");
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }
  
  convertRuppee(val) {
    try {
      final NumberFormat inrFormat = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 2,
      );
      final rupnumber = int.parse(val);
      final String ruppeeString = inrFormat.format(rupnumber);
      return ruppeeString;
    } catch (e) {
      print("convertRuppee $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Land & Owner Details'),
      ),
      body: ownerData == null || ownerData!.isEmpty
          ? const Center(child: Text('No data available. Please enter details.'))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Display Land Owner Details
                ...ownerData!.map((ownerDetail) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ownerDetail['owner']['fullname'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Divider(color: Colors.grey[300]),
                          const SizedBox(height: 8.0),
                          _buildDetailRow('Father\'s Name:', ownerDetail['owner']['fathername'] ?? 'N/A'),
                          _buildDetailRow('Address:', ownerDetail['owner']['address'] ?? 'N/A'),
                          _buildDetailRow('Hissa:', ownerDetail['owner']['hissa'] ?? 'N/A'),
                          _buildDetailRow('Heir Percentage Share:', '${ownerDetail['owner']['heirpcshr']}%' ?? 'N/A'),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Land Parcel Details:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          _buildDetailRow('Khasra No:', ownerDetail['landParcel']['khasrano'] ?? 'N/A'),
                          _buildDetailRow('Total Area:', '${ownerDetail['landParcel']['totarea']} Acre' ?? 'N/A'),
                          _buildDetailRow('Village Code:', ownerDetail['landParcel']['villagecode'] ?? 'N/A'),
                          _buildDetailRow('ULPIN:', ownerDetail['landParcel']['ulpin'] ?? 'N/A'),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24.0),

                // Display Mortgage Details
                const Text(
                  'Mortgage Details',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12.0),
                if (mortgageDetailsList != null && mortgageDetailsList!.isNotEmpty)
                  ...mortgageDetailsList!.map((mortgage) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Amount:', convertRuppee(mortgage['mortgage_amount']) ?? 'N/A'),
                            _buildDetailRow('Bank:', mortgage['bank_name'] ?? 'N/A'),
                            _buildDetailRow('Branch:', mortgage['branch_name'] ?? 'N/A'),
                          ],
                        ),
                      ),
                    );
                  }).toList()
                else
                  const Text('No mortgage details available.'),
                const SizedBox(height: 24.0),

                // Display Crop Yield Details
                const Text(
                  'Crop Yield Details',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 12.0),
                if (cropYieldDetailsList != null && cropYieldDetailsList!.isNotEmpty)
                  ...cropYieldDetailsList!.map((crop) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Season Type:', crop['seasontype'] ?? 'N/A'),
                            _buildDetailRow('Crop Area:', '${crop['croparea']} Acre' ?? 'N/A'),
                            _buildDetailRow('Crop Type:', crop['croptype'] ?? 'N/A'),
                            _buildDetailRow('Sichit Area:', '${crop['sichitarea']} Acre' ?? 'N/A'),
                          ],
                        ),
                      ),
                    );
                  }).toList()
                else
                  const Text('No crop yield details available.'),
              ],
            ),
    );
  }

  // Helper widget for consistent detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    super.dispose();
  }
}