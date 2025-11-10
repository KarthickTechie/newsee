import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsee/AppData/DBConstants/table_key_auditlog.dart';
import 'package:newsee/AppData/app_forms.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/audit_log/domain/modal/auditlog.dart';
import 'package:newsee/feature/audit_log/domain/repository/audit_log_crud_repo.dart';
import 'package:newsee/widgets/drop_down.dart';
import 'package:newsee/widgets/sysmo_alert.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class AuditLogPage extends StatefulWidget {
  const AuditLogPage({super.key});

  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  bool isVisibility = false;
  bool isLoading = false;

  // AuditLogCrudRepo using insert, delete, save , etc...
  AuditLogCrudRepo? repository;
  final FormGroup customDateForm = AppForms.AUDIT_LOG_FORM();

  // initially Loaded the saveAuditLog

  @override
  void initState() {
    super.initState();
    saveAuditLog();
    // Dropdown select custom onnly show like start date, end date , show time , and end time
    customDateForm
        .control('todayAndThisweek')
        .valueChanges
        .listen(
          (value) => setState(() {
            isVisibility = value == "Custom";
          }),
        );
  }

  // combine the DateAndTime
  DateTime combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // format the LocalTime
  String formatTime(
    BuildContext context,
    TimeOfDay timeOfDay, {
    bool alwaysUse24HourFormat = false,
  }) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      timeOfDay,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
    );
  }

  //fetch auditlog details..

  Future<void> fetchAuditLogsForDate({
    required String startDateStr,
    required String endDateStr,
  }) async {
    try {
      // db config
      Database db = await DBConfig().database;
      // filter the based on query related  startDate time
      final rows = await db.query(
        AuditLogSchema.tableName,
        where:
            '${AuditLogSchema.timestamp} >= ? AND ${AuditLogSchema.timestamp} <= ?',
        whereArgs: [startDateStr, endDateStr],
        orderBy: '${AuditLogSchema.timestamp} DESC',
      );

      final logs = rows.map(AuditLog.fromJson).toList();

      if (logs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No audit logs found between $startDateStr and $endDateStr',
            ),
          ),
        );
        return;
      }

      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'audit_logs_${startDateStr.replaceAll('/', '_')}_${endDateStr.replaceAll('/', '_')}.txt';
      final file = File('${directory.path}/$fileName');

      // Write logs to file
      final buffer = StringBuffer();
      buffer.writeln('Audit logs between $startDateStr and $endDateStr:');

      for (final log in logs) {
        buffer.writeln('User ID: ${log.userid}');
        buffer.writeln('Timestamp: ${log.timestamp}');
        buffer.writeln('Device ID: ${log.deviceId}');
        buffer.writeln('Request: ${log.request}');
      }

      await file.writeAsString(buffer.toString());

      SysmoAlert.success(message: 'Audit logs saved to: ${file.path}');
      showDialog(
        context: context,
        builder:
            (_) => SysmoAlert.success(
              message: 'Audit logs send Successfully',
              // : ${file.path}',
              onButtonPressed: () {
                Navigator.pop(context);
              },
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
      print('fetchAuditLogsForDate-error: $e');
    }
  }

  Future<void> saveAuditLog() async {
    try {
      Database db = await DBConfig().database;
      AuditLogCrudRepo auditLogCrudRepo = AuditLogCrudRepo(db);

      final userId = '1234';
      final timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());
      final deviceId = 'readmir_7';
      // final request = 'id';
      final requestJson = {
        "Setup": {
          "MobSetupMasterMain": {
            "Setupmastval": {
              "setupVersion": "2",
              "setupmodule": "AGRI",
              "setupTypeOfMaster": "StateCityMaster",
            },
          },
        },
      };

      final log = AuditLog(
        userid: userId,
        timestamp: timestamp,
        deviceId: deviceId,
        request: jsonEncode(requestJson),
      );

      final id = await auditLogCrudRepo.save(log);
      print('Inserted audit log row id: $id');

      final all = await auditLogCrudRepo.getAll();
      print('AuditLog table rows:');
      for (final row in all) {
        final auditLogData = jsonDecode(row.request);
        print('auditLogData get Data List $auditLogData');
      }
    } catch (error) {
      print("saveAuditLog-error: $error");
    }
  }

  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Audit Log'))),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Card(
                elevation: 4,
                shape: Border.all(
                  color: Colors.blue,
                  width: 0.1,
                  style: BorderStyle.solid,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ReactiveForm(
                                formGroup: customDateForm,
                                child: Column(
                                  children: [
                                    Dropdown(
                                      controlName: 'todayAndThisweek',
                                      label: 'SelectDays',
                                      items: ['Today', 'ThisWeek', 'Custom'],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child:
                                          isVisibility
                                              ? ReactiveTextField<String>(
                                                formControlName: 'startDate',
                                                validationMessages: {
                                                  ValidationMessage.required:
                                                      (error) =>
                                                          'startDate is required',
                                                },
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  labelText: 'Start Date',
                                                  suffixIcon: Icon(
                                                    Icons.calendar_today,
                                                  ),
                                                ),
                                                onTap: (control) async {
                                                  final DateTime? pickedDate =
                                                      await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate: DateTime(
                                                          1900,
                                                        ),
                                                        lastDate:
                                                            DateTime.now(),
                                                      );
                                                  if (pickedDate != null) {
                                                    final formatted =
                                                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                                                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                                                        "${pickedDate.year}";
                                                    customDateForm
                                                        .control('startDate')
                                                        .value = formatted;
                                                  }
                                                },
                                              )
                                              : SizedBox(),
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child:
                                          isVisibility
                                              ? ReactiveTextField<String>(
                                                formControlName: 'endDate',
                                                validationMessages: {
                                                  ValidationMessage.required:
                                                      (error) =>
                                                          'EndDate is required',
                                                },
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  labelText: 'End Date',
                                                  suffixIcon: Icon(
                                                    Icons.calendar_today,
                                                  ),
                                                ),
                                                onTap: (control) async {
                                                  final DateTime? pickedDate =
                                                      await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate: DateTime(
                                                          1900,
                                                        ),
                                                        lastDate: DateTime(
                                                          2026,
                                                        ),
                                                      );
                                                  if (pickedDate != null) {
                                                    final formatted =
                                                        "${pickedDate.day.toString().padLeft(2, '0')}/"
                                                        "${pickedDate.month.toString().padLeft(2, '0')}/"
                                                        "${pickedDate.year}";
                                                    customDateForm
                                                        .control('endDate')
                                                        .value = formatted;
                                                  }
                                                },
                                              )
                                              : SizedBox(),
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child:
                                          isVisibility
                                              ? ReactiveTextField<TimeOfDay>(
                                                formControlName: 'startTime',
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  labelText: 'Start Time',
                                                  suffixIcon: Icon(
                                                    Icons.access_time,
                                                  ),
                                                ),
                                                onTap: (control) async {
                                                  final TimeOfDay? pickedTime =
                                                      await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            control.value ??
                                                            TimeOfDay.now(),
                                                      );
                                                  if (pickedTime != null) {
                                                    control.updateValue(
                                                      pickedTime,
                                                    );
                                                  }
                                                },
                                                valueAccessor:
                                                    TimeOfDayValueAccessor(),
                                              )
                                              : SizedBox(),
                                    ),
                                    SizedBox(height: 20),

                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child:
                                          isVisibility
                                              ? ReactiveTextField<TimeOfDay>(
                                                formControlName: 'endTime',
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  labelText: 'End Time',
                                                  suffixIcon: Icon(
                                                    Icons.access_time,
                                                  ),
                                                ),
                                                onTap: (control) async {
                                                  final TimeOfDay? pickedTime =
                                                      await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            control.value ??
                                                            TimeOfDay.now(),
                                                      );
                                                  if (pickedTime != null) {
                                                    control.updateValue(
                                                      pickedTime,
                                                    );
                                                  }
                                                },
                                                valueAccessor:
                                                    TimeOfDayValueAccessor(),
                                              )
                                              : SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll<Color>(
                              Color.fromARGB(255, 2, 59, 105),
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            minimumSize: WidgetStatePropertyAll(Size(150, 40)),
                          ),
                          onPressed: () async {
                            try {
                              if (customDateForm.valid) {
                                setState(() {
                                  isLoading = true;
                                });
                                await Future.delayed(Duration(seconds: 2));
                                setState(() {
                                  isLoading = false;
                                });

                                // dismissLoading(context);

                                final selectedDay =
                                    customDateForm
                                        .control('todayAndThisweek')
                                        .value
                                        ?.toString() ??
                                    '';

                                if (selectedDay == 'Today') {
                                  final now = DateTime.now();
                                  final startDate = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                  );
                                  final endDate = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    23,
                                    59,
                                    59,
                                  );

                                  final start = DateFormat(
                                    'yyyy-MM-dd HH:mm:ss',
                                  ).format(startDate);
                                  final end = DateFormat(
                                    'yyyy-MM-dd HH:mm:ss',
                                  ).format(endDate);
                                  await fetchAuditLogsForDate(
                                    startDateStr: start,
                                    endDateStr: end,
                                  );
                                } else if (selectedDay == 'ThisWeek') {
                                  final today = DateTime.now();
                                  final startOfWeek = DateTime(
                                    today.year,
                                    today.month,
                                    today.day,
                                  );

                                  final endOfWeek = DateTime(
                                    today.year,
                                    today.month,
                                    today.day + 6,
                                    23,
                                    59,
                                    59,
                                  );

                                  final start = DateFormat(
                                    'yyyy-MM-dd HH:mm:ss',
                                  ).format(startOfWeek);
                                  final end = DateFormat(
                                    'yyyy-MM-dd HH:mm:ss',
                                  ).format(endOfWeek);
                                  await fetchAuditLogsForDate(
                                    startDateStr: start,
                                    endDateStr: end,
                                  );
                                }

                                final startDate =
                                    customDateForm.control('startDate').value ??
                                    '';
                                final endDate =
                                    customDateForm.control('endDate').value ??
                                    '';
                                final TimeOfDay? startTime =
                                    customDateForm.control('startTime').value;
                                final TimeOfDay? endTime =
                                    customDateForm.control('endTime').value;

                                final dateTimeCondition =
                                    startDate.isEmpty ||
                                    endDate.isEmpty ||
                                    startTime == null ||
                                    endTime == null;
                                final selectedDays = selectedDay.isEmpty;

                                if (dateTimeCondition || selectedDays) {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text('Please select all date and time'),
                                  //   ),
                                  // );
                                  return;
                                }

                                final DateTime startdata = DateFormat(
                                  "dd/MM/yyyy",
                                ).parse(startDate);
                                final DateTime enddata = DateFormat(
                                  "dd/MM/yyyy",
                                ).parse(endDate);

                                final startDateTime = combineDateAndTime(
                                  startdata,
                                  startTime,
                                );
                                final endDateTime = combineDateAndTime(
                                  enddata,
                                  endTime,
                                );

                                final start = DateFormat(
                                  'yyyy-MM-dd HH:mm:ss',
                                ).format(startDateTime);
                                final end = DateFormat(
                                  'yyyy-MM-dd HH:mm:ss',
                                ).format(endDateTime);

                                await fetchAuditLogsForDate(
                                  startDateStr: start,
                                  endDateStr: end,
                                );
                              } else {
                                customDateForm.markAllAsTouched();
                              }
                            } catch (e) {
                              print("auditlog customtime pressed => $e");
                            }
                          },
                          child: const Text('Generate Custom Log'),
                        ),
                      ),

                      //  ElevatedButton(
                      //   onPressed: saveAuditLog,
                      //   child: const Text('Create Audit Log'),
                      // ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class TimeOfDayValueAccessor extends ControlValueAccessor<TimeOfDay, String> {
  @override
  String? modelToViewValue(TimeOfDay? modelValue) {
    if (modelValue == null) return '';
    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      modelValue.hour,
      modelValue.minute,
    );
    return DateFormat.jm().format(dt);
  }

  @override
  TimeOfDay? viewToModelValue(String? viewValue) => null;
}
