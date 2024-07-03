import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:studiovity_assignment/components/sticky_row_header.dart';
import 'package:studiovity_assignment/models/data_model.dart';

import 'package:studiovity_assignment/utils/utils.dart';

class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  late ScrollController headerScrollController1;
  late ScrollController headerScrollController2;
  late ScrollController headerScrollController3;
  late ScrollController cellScrollController;
  LinkedScrollControllerGroup groupController = LinkedScrollControllerGroup();

  ApiResponse? apiResponse;
  bool isLoading = true;
  bool isError = false;

  void onFetchSuccess(ApiResponse? response) {
    setState(() {
      apiResponse = response;
      isLoading = false;
      isError = false;
    });
  }

  void onFetchError() {
    setState(() {
      isError = true;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    headerScrollController1 = groupController.addAndGet();
    headerScrollController2 = groupController.addAndGet();
    headerScrollController3 = groupController.addAndGet();
    cellScrollController = groupController.addAndGet();
    fetchData(
        onFetchSuccess: (response) {
          onFetchSuccess(response);
        },
        onFetchError: onFetchError);
  }

  @override
  void dispose() {
    super.dispose();
    headerScrollController1.dispose();
    headerScrollController2.dispose();
    headerScrollController3.dispose();
    cellScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return const Center(child: Text('Failed to load data'));
    }

    Set<DateTime> uniqueDates = {}; // to flter out any duplicate dates
    // filtering out null values

    for (var date in apiResponse!.startDates) {
      if (date != null && date != DateTime.utc(1970, 1, 1)) {
        uniqueDates.add(DateTime.parse(date.toString()));
      }
    }

    // Sort dates in ascending order
    List<DateTime> sortedDates = uniqueDates.toList()..sort();

    // Extract date and month
    List<Map<String, int>> extractedDates = sortedDates.map((date) {
      return {
        'day': date.day,
        'month': date.month,
        'year': date.year,
        'weekday': date.weekday
      };
    }).toList();

    List<DataColumn> buildColumns(int columnCount) {
      return [
        ...List.generate(columnCount + 3, (index) {
          return const DataColumn(label: Text(''));
        }),
      ];
    }

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 112),
        child: SingleChildScrollView(
          child: Row(
            children: [
              // left sticky column
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
                child: DataTable(
                  headingRowColor: const WidgetStatePropertyAll(
                      Color.fromARGB(255, 254, 247, 255)),
                  dataRowColor: const WidgetStatePropertyAll(
                      Color.fromARGB(255, 254, 247, 255)),
                  border: const TableBorder(
                    left: BorderSide(width: 1),
                    right: BorderSide(width: 0.5),
                    top: BorderSide(width: 1),
                    bottom: BorderSide(width: 1),
                    horizontalInside: BorderSide(width: 1),
                    verticalInside: BorderSide(width: 1),
                  ),
                  columns: const [
                    DataColumn(label: Text('')),
                  ],
                  rows: apiResponse!.data.map((item) {
                    return DataRow(cells: [
                      DataCell(
                        SizedBox(
                          width: 115,
                          child: Text(
                            textAlign: TextAlign.left,
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),

              // right scrollable columns
              Expanded(
                  child: SingleChildScrollView(
                controller: cellScrollController,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(width: 0.5),
                  columns: buildColumns(sortedDates.length),
                  // check the utils file for this function
                  rows: buildRows(apiResponse!, sortedDates, extractedDates),
                ),
              )),
            ],
          ),
        ),
      ),
      StickyRowHeader(
        scrollController: headerScrollController1,
        positionFromTop: 0,
        headerIndex: 1,
        headerValue: 'Day/Month',
        extractedDates: extractedDates,
      ),
      StickyRowHeader(
        scrollController: headerScrollController2,
        positionFromTop: 56,
        headerIndex: 2,
        headerValue: 'Day of Week',
        extractedDates: extractedDates,
      ),
      StickyRowHeader(
        scrollController: headerScrollController3,
        positionFromTop: 112,
        headerIndex: 3,
        headerValue: 'Shooting Day',
        extractedDates: extractedDates,
      ),
    ]);
  }
}
