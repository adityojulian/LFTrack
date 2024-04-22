import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ordinary/app/models/lft_result.dart';
import 'package:ordinary/app/shared/theme.dart';
import 'package:ordinary/firebase_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class HistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late ScrollController mainScrollController;
  late ScrollController listScrollController;

  final Rx<List<LFTResult>> _lftResults = Rx<List<LFTResult>>([]);
  List<LFTResult> get lftResults => _lftResults.value;

  // Filter-related observables
  final RxString _searchText = ''.obs;
  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(null);
  final Rx<DateTimeRange?> _selectedDateRange = Rx<DateTimeRange?>(null);

  final GetStorage _storage = GetStorage(); // Using GetStorage for persistence

  // Public getters for filter values
  String get searchText => _searchText.value;
  DateTime? get selectedDate => _selectedDate.value;
  DateTimeRange? get selectedDateRange => _selectedDateRange.value;

  @override
  void onInit() {
    super.onInit();
    _lftResults.bindStream(getLFTResultsStream());
    // tabController = TabController(vsync: this, length: 2, initialIndex: 0);
    mainScrollController = ScrollController();
    listScrollController = ScrollController();

    // Initialize the TabController
    int lastTabIndex = _storage.read('lastTabIndex') ?? 0;
    tabController =
        TabController(vsync: this, length: 2, initialIndex: lastTabIndex);

    // Add listener to update storage when tab changes
    tabController.addListener(_handleTabSelection);
  }

  void loadFilters() {
    // Load Filters
    _searchText.value = _storage.read('searchText') ?? '';
    _selectedDate.value = _storage.read('selectedDate') != null
        ? DateTime.tryParse(_storage.read('selectedDate'))
        : null;
    var rangeStart = _storage.read('selectedDateRangeStart');
    var rangeEnd = _storage.read('selectedDateRangeEnd');
    if (rangeStart != null && rangeEnd != null) {
      _selectedDateRange.value = DateTimeRange(
          start: DateTime.parse(rangeStart), end: DateTime.parse(rangeEnd));
    }
  }

  void _handleTabSelection() {
    if (tabController.indexIsChanging) {
      _storage.write('lastTabIndex', tabController.index);
    }
  }

  Stream<List<LFTResult>> getLFTResultsStream() {
    // Replace 'YOUR_USER_ID' with the correct path to the user's data
    return firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('lftResults')
        .orderBy("createdOn", descending: true)
        .snapshots()
        .map((query) =>
            query.docs.map((item) => LFTResult.fromJson(item.data())).toList());
  }

  // Filtered list of results
  List<LFTResult> get filteredLftResults {
    var filteredList = _lftResults.value;
    // Apply text search filter if search text is not empty
    if (_searchText.value.isNotEmpty) {
      String searchTextLower = _searchText.value.toLowerCase();
      filteredList = filteredList.where((result) {
        // Check if searchText is contained in lftResult or barcode
        return result.lftResult.toLowerCase().contains(searchTextLower) ||
            result.barcode.toLowerCase().contains(searchTextLower);
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
    _storage.write('searchText', text); // Save to storage
  }

  // Method to update the selected date
  void updateSelectedDate(DateTime? date) {
    _selectedDate.value = date;
    _storage.write('selectedDate', date?.toIso8601String()); // Save to storage
    _selectedDateRange.value =
        null; // Clear date range when a single date is selected
    _storage.remove('selectedDateRangeStart');
    _storage.remove('selectedDateRangeEnd');
  }

  // Method to update the selected date range
  void updateSelectedDateRange(DateTimeRange? range) {
    _selectedDateRange.value = range;
    if (range != null) {
      _storage.write('selectedDateRangeStart', range.start.toIso8601String());
      _storage.write('selectedDateRangeEnd', range.end.toIso8601String());
    } else {
      _storage.remove('selectedDateRangeStart');
      _storage.remove('selectedDateRangeEnd');
    }
    _selectedDate.value = null; // Clear single date when a range is selected
    _storage.remove('selectedDate');
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
  final DateFormat date = DateFormat('dd-MM-yyyy');

  // Method to export data to a CSV file
  Future<void> exportFilteredResultsToCsv() async {
    // Confirmation dialog
    bool confirmationResult = await Get.dialog<bool>(
          AlertDialog(
            title: Text(
              'Export to CSV',
              style: bold,
            ),
            content: SingleChildScrollView(
              // Enable scrolling on overflow
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Takes up minimal space vertically
                children: [
                  Text(
                    'The CSV file will include the current active filters:',
                    style: regular,
                  ),
                  SizedBox(height: 16),
                  if (searchText.isEmpty &&
                      selectedDate == null &&
                      selectedDateRange == null)
                    ListTile(
                      leading: Icon(Icons.clear),
                      title: Text('No filter is active', style: regular),
                      // subtitle: Text(searchText, style: bold),
                    ),
                  if (searchText.isNotEmpty)
                    ListTile(
                      leading: Icon(Icons.search),
                      title: Text('Search Value', style: regular),
                      subtitle: Text(searchText, style: bold),
                    ),
                  if (selectedDate != null)
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Picked Date', style: regular),
                      subtitle: Text(date.format(selectedDate!), style: bold),
                    ),
                  if (selectedDateRange != null)
                    ListTile(
                      leading: Icon(Icons.date_range),
                      title: Text('Picked Date Range', style: regular),
                      subtitle: Text(
                          '${date.format(selectedDateRange!.start)} to ${date.format(selectedDateRange!.end)}',
                          style: bold),
                    ),
                  SizedBox(height: 24),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text('Cancel', style: medium),
                        onPressed: () => Get.back(result: false),
                      ),
                      SizedBox(width: 8),
                      TextButton(
                        child: Text('Proceed', style: medium),
                        onPressed: () => Get.back(result: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ) ??
        false; // Handle the null case by defaulting to 'false'

    // If user confirmed, proceed with export
    if (!confirmationResult) return;

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

    loadFilters();
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabSelection);
    tabController.dispose();
    super.onClose();
  }
}
