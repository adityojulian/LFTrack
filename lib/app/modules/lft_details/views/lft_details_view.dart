import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ordinary/app/shared/theme.dart';

import '../../../models/lft_result.dart';
import '../controllers/lft_details_controller.dart';

class LftDetailsView extends GetView<LftDetailsController> {
  const LftDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // Using Obx here to listen to changes in currentResult
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Edit LFT Result',
        style: bold.copyWith(fontSize: 24),
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Obx(() {
          LFTResult result = controller.currentResult.value;
          return ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: result.barcode,
                onChanged: (val) => result.barcode = val,
                decoration: InputDecoration(
                    labelText: 'Barcode',
                    labelStyle: regular,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.colorScheme.outline)),
                    prefixIcon: Icon(Icons.qr_code),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(10))),
                style: regular,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: result.lftResult,
                onChanged: (val) => result.lftResult = val,
                decoration: InputDecoration(
                    labelText: 'Result',
                    labelStyle: regular,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.colorScheme.outline)),
                    prefixIcon: Icon(Icons.medical_services),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(10))),
                style: regular,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: result.confidence,
                onChanged: (val) => result.confidence = val,
                decoration: InputDecoration(
                    labelText: 'Result',
                    labelStyle: regular,
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.colorScheme.outline)),
                    prefixIcon: Icon(Icons.analytics),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(10))),
                style: regular,
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Date Created',
                  style: semibold,
                ),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy – hh:mm')
                      .format(result.createdOn!.toDate()),
                  style: regular,
                ),
                leading: Icon(Icons.calendar_today),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text(
                  'Save Changes',
                  style: bold,
                ),
                onPressed: () => controller.showSaveConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary, // background
                  foregroundColor: theme.colorScheme.onPrimary, // foreground
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text(
                  'Delete Record',
                  style: bold,
                ),
                onPressed: () =>
                    controller.showDeleteConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary, // background
                  foregroundColor: theme.colorScheme.onTertiary, // foreground
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
