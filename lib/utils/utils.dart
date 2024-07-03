import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:studiovity_assignment/models/data_model.dart';

int firstNonEmptyString(List<String> listString) {
  int firstNonEmptyIndex = -1;

  for (int i = 0; i < listString.length; i++) {
    if (listString[i].isNotEmpty) {
      firstNonEmptyIndex = i;
      break;
    }
  }

  return firstNonEmptyIndex;
}

int lastNonEmptyString(List<String> listString) {
  int lastNonEmptyIndex = -1;

  for (int i = listString.length - 1; i >= 0; i--) {
    if (listString[i].isNotEmpty) {
      lastNonEmptyIndex = i;
      break;
    }
  }

  return lastNonEmptyIndex;
}

// fetch data

Future<void> fetchData({
  required Function(ApiResponse? response) onFetchSuccess,
  required Function() onFetchError,
}) async {
  String bearerToken = dotenv.env['TOKEN']!;
  final Uri uri = Uri.parse(dotenv.env['API_URL']!);

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      onFetchSuccess(ApiResponse.fromJson(jsonDecode(response.body)));
    } else {
      onFetchError();
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    onFetchError();
    throw Exception('Failed to load data: $e');
  }
}

// appends a 0 for single digit dates or strings
String appendZeroOrNot(String string) {
  if (string.length == 1) {
    return '0$string';
  }
  return string;
}

Color? cellColorGenerator(String string) {
  Color cellColor = Colors.transparent;
  if (string == 'SWF') {
    cellColor = Colors.green;
  } else if (string == 'SW') {
    cellColor = Colors.blue;
  } else if (string == 'W') {
    cellColor = Colors.greenAccent;
  } else if (string == 'WF') {
    cellColor = Colors.green;
  }
  return cellColor;
}

// generates rows for the table
List<DataRow> buildRows(ApiResponse apiResponse, List<DateTime> sortedDates,
    List<Map<String, int>> extractedDates) {
  TextStyle textStyle = const TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black);
  return apiResponse.data.map(
    (dataElement) {
      // extracting the dates (start key) from the shooting scene array from
      // each object in the data array

      List<DateTime?> shootingSceneDates =
          dataElement.shootingScenes.map((scene) {
        return scene.start;
      }).toList();

      // initalizing empty list for cell values
      // cell values list is  reprenting each row below the header rows
      // and each item in cellvalues list is the particular cell
      // that means cellValue[0] is the first cell and so on..
      List<String> cellValues =
          List.generate(sortedDates.length, (index) => '');

      // initalizing empty list for all the matching dates from the
      // shootingSceneDates and sorted startdates array from api response
      List<int> matchingIndexes = [];

      // checking for matching dates , if a date matches adds that index to
      // the list of indices
      for (int i = 0; i < sortedDates.length; i++) {
        if (shootingSceneDates.contains(sortedDates[i])) {
          matchingIndexes.add(i);
        }
      }

      // checkiing the length of matchingIndexes and assigining the
      // cellvalues based on the criteria

      if (matchingIndexes.length == 1) {
        // only one date match =  SWF(Start work finish)
        cellValues[matchingIndexes[0]] = 'SWF';
      } else if (matchingIndexes.length == 2) {
        // only two dates match =  SW (Start Work)for first date and WF (work finish) for the second date.
        cellValues[matchingIndexes[0]] = 'SW';
        cellValues[matchingIndexes[1]] = 'WF';
      } else if (matchingIndexes.length > 2) {
        // More than two matching dates ,
        // First and last date gets SW and WF respectively and dates in the middle gets W (work).
        cellValues[matchingIndexes[0]] = 'SW';
        for (int i = 1; i < matchingIndexes.length; i++) {
          cellValues[matchingIndexes[i]] = 'W';
        }
        cellValues[matchingIndexes.last] = 'WF';
      }

      // extracting the first and last index with the non empty string in cellvalues array
      // will be used to show the starting and finish dates in the start and finish column
      int firstIndex = firstNonEmptyString(cellValues);
      int lastIndex = lastNonEmptyString(cellValues);

      return DataRow(cells: [
        ...List.generate(
          sortedDates.length,
          (index) {
            bool isEmptyCell = cellValues[index].isEmpty;
            return DataCell(
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: isEmptyCell == false
                        ? cellColorGenerator(cellValues[index])
                        : null),
                width: 90,
                child: Text(
                  style: textStyle,
                  cellValues[index],
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        // cell for the Start Column

        DataCell(
          SizedBox(
            width: 90,
            child: Text(
                style: textStyle,
                textAlign: TextAlign.center,
                firstIndex != -1 && firstIndex < extractedDates.length
                    ? '${appendZeroOrNot(extractedDates[firstNonEmptyString(cellValues)]['day'].toString())} / ${appendZeroOrNot(extractedDates[firstNonEmptyString(cellValues)]['month'].toString())}'
                    : ''),
          ),
        ),

        // cell for the Finish Column
        DataCell(
          SizedBox(
            width: 90,
            child: Text(
                style: textStyle,
                textAlign: TextAlign.center,
                lastIndex != -1 && lastIndex < extractedDates.length
                    ? '${appendZeroOrNot(extractedDates[lastNonEmptyString(cellValues)]['day'].toString())} / ${appendZeroOrNot(extractedDates[lastNonEmptyString(cellValues)]['month'].toString())}'
                    : ''),
          ),
        ),

        // cell for the Total Column
        DataCell(
          SizedBox(
            width: 90,
            child: Text(
                style: textStyle,
                textAlign: TextAlign.center,
                appendZeroOrNot(matchingIndexes.length.toString())),
          ),
        ),
      ]);
    },
  ).toList();
}
