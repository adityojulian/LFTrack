import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordinary/app/models/lft_result.dart';
import 'package:ordinary/app/shared/theme.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  HistoryView({Key? key}) : super(key: key);

  // Define a helper function to format DateTime
  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat(
        'dd/MM/yyyy hh:mm:ss'); // Adjust the date format to match your needs
    return dateFormat.format(dateTime);
  }

  // Use this function to determine the color based on the result
  Color _getResultColor(String result) {
    switch (result.toUpperCase()) {
      case 'NEGATIVE':
        return Colors.blue;
      case 'POSITIVE':
        return Colors.red;
      case 'INVALID':
        return Colors.grey;
      default:
        return Colors.black; // Default color if result is not recognized
    }
  }

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  // Build the ListTile widget
  Widget buildLFTListTile(BuildContext context, LFTResult result) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDateTime(result.createdOn.toDate()),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.barcode,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8.0),
              decoration: BoxDecoration(
                color: _getResultColor(result.lftResult),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'C',
                        style: bold.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      Text(
                        'T',
                        style: bold.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                  Container(
                    width: 10,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "-",
                          style: bold.copyWith(
                              color: _getResultColor(result.lftResult)),
                        ),
                        Text(
                          result.lftResult == "positive" ? "-" : "",
                          style: bold.copyWith(
                              color: _getResultColor(result.lftResult)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    result.lftResult.toUpperCase(),
                    style: bold.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget datePickerWidget(BuildContext context) {
    return Column(
      children: [
        Obx(() => InkWell(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  controller.updateSelectedDate(pickedDate);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.selectedDate != null
                          ? 'Date: ${dateFormat.format(controller.selectedDate!)}'
                          : 'Select Date',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (controller.selectedDate != null)
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => controller.updateSelectedDate(null),
                      )
                  ],
                ),
              ),
            )),
        SizedBox(height: 8),
        Obx(() => InkWell(
              onTap: () async {
                final DateTimeRange? pickedRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (pickedRange != null) {
                  // Include the entire end day by setting the time to just before midnight
                  final DateTime endOfDay = DateTime(
                    pickedRange.end.year,
                    pickedRange.end.month,
                    pickedRange.end.day,
                    23,
                    59,
                  );
                  // Update the date range with the adjusted end time
                  final DateTimeRange updatedRange = DateTimeRange(
                    start: pickedRange.start,
                    end: endOfDay,
                  );
                  controller.updateSelectedDateRange(updatedRange);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.selectedDateRange != null
                          ? 'Range: ${dateFormat.format(controller.selectedDateRange!.start)} - ${dateFormat.format(controller.selectedDateRange!.end)}'
                          : 'Select Date Range',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (controller.selectedDateRange != null)
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () =>
                            controller.updateSelectedDateRange(null),
                      )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(
          'History',
          style: bold.copyWith(
              fontSize: 70, color: Theme.of(context).colorScheme.onBackground),
        ),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                controller.exportFilteredResultsToCsv();
              },
              child: const Text("Export"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Scrollbar(
          thumbVisibility: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Replace with the color of your choice
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: InkWell(
                        onTap: () {
                          // Action when the container is tapped
                          // For example, navigate to a details screen
                        },
                        child: Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Arrow icon
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Adjust the styling as needed
                                    Text("Total of LFT Scans",
                                        style: regular.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary)),
                                    // The total number of scans
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${controller.lftResults.length}',
                                          style: bold.copyWith(
                                              fontSize: 40,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'scans',
                                          style: medium.copyWith(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      onChanged: (text) => controller.updateSearchText(text),
                      decoration: InputDecoration(
                        label: Text(
                          "Search by result...",
                          style: regular,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  // Date picker button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: datePickerWidget(context),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Obx(() {
                      if (controller.filteredLftResults.isEmpty) {
                        return Center(
                          child: Text(
                            'No history found',
                            style: bold,
                          ),
                        );
                      }
                      return Container(
                        height: 300,
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: controller.filteredLftResults.length,
                            itemBuilder: (context, index) {
                              final result =
                                  controller.filteredLftResults[index];
                              return buildLFTListTile(context, result);
                              // return ListTile(
                              //   shape: RoundedRectangleBorder(),
                              //   title: Container(
                              //     width: 20,
                              //     padding: const EdgeInsets.all(4),
                              //     decoration: BoxDecoration(
                              //       color: Theme.of(context).colorScheme.tertiaryContainer,
                              //       borderRadius: BorderRadius.circular(
                              //           4), // Rounded corners for the container
                              //     ),
                              //     child: Text(
                              //       "${result.createdOn.toDate().day}/${result.createdOn.toDate().month}/${result.createdOn.toDate().year} ${result.createdOn.toDate().hour}:${result.createdOn.toDate().minute}:${result.createdOn.toDate().second}",
                              //       style: const TextStyle(
                              //           fontSize:
                              //               10), // Replace with your 'regular' style if needed
                              //     ),
                              //   ),
                              //   subtitle: Text(result.lftResult.capitalize_custom()),
                              //   tileColor: Theme.of(context).colorScheme.primaryContainer,
                              // );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
