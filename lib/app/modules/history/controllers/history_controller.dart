import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordinary/app/models/lft_result.dart';
import 'package:ordinary/firebase_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class HistoryController extends GetxController {
  final Rx<List<LFTResult>> _lftResults = Rx<List<LFTResult>>([]);
  List<LFTResult> get lftResults => _lftResults.value;

  @override
  void onInit() {
    super.onInit();
    // Subscribe to the LFT results stream
    _lftResults.bindStream(getLFTResultsStream());
  }

  Stream<List<LFTResult>> getLFTResultsStream() {
    // Replace 'YOUR_USER_ID' with the correct path to the user's data
    return firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('lftResults')
        .snapshots()
        .map((query) =>
            query.docs.map((item) => LFTResult.fromJson(item.data())).toList());
  }

  // Filter-related observables
  final RxString _searchText = ''.obs;
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);
  final Rx<DateTimeRange?> _selectedDateRange = Rx<DateTimeRange?>(null);

  // Public getters for filter values
  String get searchText => _searchText.value;
  DateTime? get selectedDate => _selectedDate.value;
  DateTimeRange? get selectedDateRange => _selectedDateRange.value;

  // Filtered list of results
  List<LFTResult> get filteredLftResults {
    var filteredList = _lftResults.value;
    // Apply text search filter if search text is not empty
    if (_searchText.value.isNotEmpty) {
      filteredList = filteredList.where((result) {
        return result.lftResult
            .toLowerCase()
            .contains(_searchText.value.toLowerCase());
      }).toList();
    }
    // Apply date filter
    if (_selectedDate.value != null) {
      filteredList = filteredList.where((result) {
        return isSameDay(result.createdOn.toDate(), _selectedDate.value!);
      }).toList();
    }
    // Apply date range filter
    if (_selectedDateRange.value != null) {
      filteredList = filteredList.where((result) {
        final date = result.createdOn.toDate();
        return date.isAfter(_selectedDateRange.value!.start) &&
            date.isBefore(_selectedDateRange.value!.end);
      }).toList();
    }
    return filteredList;
  }

  // Method to update the search text
  void updateSearchText(String text) {
    _searchText.value = text;
  }

  // Method to update the selected date
  void updateSelectedDate(DateTime? date) {
    _selectedDate.value = date;
    _selectedDateRange.value =
        null; // Clear date range when a single date is selected
  }

  // Method to update the selected date range
  void updateSelectedDateRange(DateTimeRange? range) {
    log("date: ${range.toString()}");
    _selectedDateRange.value = range;
    _selectedDate.value = null; // Clear single date when a range is selected
  }

  // Utility method to check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else {
        var result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      }
    }
    return false;
  }

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy_hh-mm-ss');

  // Method to export data to a CSV file
  Future<void> exportFilteredResultsToCsv() async {
    List<List<dynamic>> rows = [];

    // Create a header row
    List<dynamic> row = [
      'Date',
      'ID',
      'Result',
    ];
    rows.add(row);

    // Add data rows
    for (LFTResult result in filteredLftResults) {
      List<dynamic> row = [];
      row.add(result.createdOn.toDate().toString());
      row.add(result.barcode);
      row.add(result.lftResult);
      rows.add(row);
    }

    // Convert to CSV and write the string to a file
    String csv = const ListToCsvConverter().convert(rows);
    // Request the necessary permissions
    if (await _requestStoragePermission()) {
      var directory = await getExternalStorageDirectory();
      log("Dir: $directory");
      final String dirPath = '/storage/emulated/0/Download';
      final Directory dir = Directory(dirPath);

      // Check if the custom directory exists, if not, create it
      if (!(await dir.exists())) {
        await dir.create(recursive: true);
      }

      // Save the file
      final String filePath = path.join(dirPath,
          "lft_results_${dateFormat.format(Timestamp.now().toDate()).toString()}.csv");
      final File file = File(filePath);
      await file.writeAsString(csv);

      log('CSV Exported: $filePath');
    } else {
      log('Permission Denied');
    }
    // Ensure necessary permissions are granted
    // if (await _requestStoragePermission()) {
    //   final File file = File(path);
    //   await file.writeAsString(csv);

    //   // If you want to share the file or perform other actions, you can do so here
    //   log('CSV Exported: $path');
    // } else {
    //   log('Permission Denied');
    // }
  }

  // Future<bool> _requestStoragePermission() async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     status = await Permission.storage.request();
  //   }
  //   return status.isGranted;
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void signOut() {
    try {
      auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
