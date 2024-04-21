import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:ordinary/app/modules/history/controllers/history_controller.dart';
import 'package:ordinary/app/shared/theme.dart'; // Make sure to import your controller

class DateSelectionTabs extends StatelessWidget {
  final HistoryController controller = Get.find<HistoryController>();
  final DateFormat dateFormat =
      DateFormat('dd MMM yyyy'); // Adjust date format if needed

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border:
              Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
          // color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10)),
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Date Filter",
                style: medium.copyWith(fontSize: 18),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary),
              child: TabBar(
                controller: controller.tabController,
                indicatorColor: Theme.of(context).colorScheme.onPrimary,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    child: Text(
                      "Exact Date",
                      style: medium.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Date Range",
                      style: medium.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
                dividerColor: Theme.of(context).colorScheme.background,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 40, // Adjust height to fit your design
              decoration: BoxDecoration(),
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  exactDatePickerWidget(context),
                  dateRangePickerWidget(context),
                ],
              ),
            ),
            // Include the Go button here or elsewhere in your layout as needed
            // ElevatedButton(
            //   onPressed: () {
            //     // Add the logic for what should happen when Go is pressed
            //   },
            //   child: Text('Go'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget exactDatePickerWidget(BuildContext context) {
    return InkWell(
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
      child: Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedDate != null
                      ? dateFormat.format(controller.selectedDate!)
                      : 'From date',
                  style: regular.copyWith(fontSize: 16),
                ),
                // Icon(Icons.calendar_today),
                if (controller.selectedDate != null)
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => controller.updateSelectedDate(null),
                    ),
                  )
              ],
            ),
          )),
    );
  }

  Widget dateRangePickerWidget(BuildContext context) {
    return InkWell(
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
      child: Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.selectedDateRange != null
                      ? '${dateFormat.format(controller.selectedDateRange!.start)} - ${dateFormat.format(controller.selectedDateRange!.end)}'
                      : 'Select Date Range',
                  style: regular.copyWith(fontSize: 16),
                ),
                // Icon(Icons.calendar_today),
                if (controller.selectedDateRange != null)
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => controller.updateSelectedDateRange(null),
                    ),
                  )
              ],
            ),
          )),
    );
  }
}
