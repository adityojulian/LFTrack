import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ordinary/app/models/recognition.dart';
import 'package:ordinary/app/shared/theme.dart';
import 'package:ordinary/app/utils/string_utilz.dart';

/// Row for one Stats field
class StatsSimple extends StatelessWidget {
  final Recognition lftResult;
  final String barcodeID;
  final Map<String, String> stats;

  const StatsSimple(this.lftResult, this.barcodeID, this.stats, {super.key});

  Widget columnData(String key, String value, BuildContext context) {
    // Provides a consistent style for the key
    TextStyle keyStyle =
        bold.copyWith(color: Theme.of(context).colorScheme.primary);
    // Provides a consistent style for the value within a bordered container
    TextStyle valueStyle =
        medium.copyWith(color: Theme.of(context).colorScheme.onPrimary);

    return Expanded(
      // Allows each column to expand equally
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Ensures alignment at the start
        children: [
          Text(key, style: keyStyle),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8), // Adds padding inside the container
            margin: const EdgeInsets.only(
                top: 4), // Adds space between key and value
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary, // Sets the background color to the primary color
              border:
                  Border.all(color: Theme.of(context).colorScheme.onBackground),
              borderRadius:
                  BorderRadius.circular(4), // Rounded corners for the container
            ),
            child: Text(value, style: valueStyle),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // bool allEmpty = barcodeID.isEmpty && lftResult.label.isEmpty && stats.isEmpty;
    // log("barcodeee: ${barcodeID}");
    // log("label: ${lftResult.label}");
    // log("stats: ${stats.entries.elementAt(2).value}");

    // Handles empty or missing barcode ID
    String displayBarcodeID = barcodeID.isNotEmpty ? barcodeID : "No barcode";
    // Access the inference time from the stats map more safely
    String inferenceTime = "${stats.entries.elementAt(2).value}ms";

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Adjusts spacing between columns
      children: [
        columnData("Barcode ID", displayBarcodeID, context),
        columnData("LFT Result", lftResult.label.capitalize_custom(), context),
        columnData("Inference Time", inferenceTime, context),
      ],
    );
  }
}
