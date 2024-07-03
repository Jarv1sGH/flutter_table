import 'package:flutter/material.dart';
import 'package:studiovity_assignment/utils/utils.dart';

class StickyRowHeader extends StatelessWidget {
  const StickyRowHeader({
    super.key,
    required this.scrollController,
    required this.positionFromTop,
    required this.headerValue,
    required this.headerIndex,
    required this.extractedDates,
  });

  final ScrollController scrollController;
  final double positionFromTop;
  final String headerValue;
  final int headerIndex;
  final List<Map<String, int>> extractedDates;
  @override
  Widget build(BuildContext context) {
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thur',
      'Fri',
      'Sat',
      'Sun',
    ];

    TextStyle headerStyles = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 13,
    );
    return Positioned(
      top: positionFromTop,
      left: 0,
      right: 0,
      child: Row(
        children: [
          // left
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
                border: const TableBorder(
                  left: BorderSide(width: 1),
                  right: BorderSide(width: 1),
                  top: BorderSide(width: 1),
                  bottom: BorderSide(width: 1),
                ),
                headingRowColor: const WidgetStatePropertyAll(
                    Color.fromARGB(255, 156, 204, 255)),
                columns: [
                  DataColumn(
                      label: Center(
                    child: SizedBox(
                      width: 115,
                      child: Text(
                          textAlign: TextAlign.right,
                          headerValue,
                          style: headerStyles),
                    ),
                  )),
                ],
                rows: const []),
          ),
          // right
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DataTable(
                    border: const TableBorder(
                      left: BorderSide(width: 1),
                      right: BorderSide(width: .5),
                      top: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                      horizontalInside: BorderSide(width: 1),
                      verticalInside: BorderSide(width: 1),
                    ),
                    headingRowColor: const WidgetStatePropertyAll(
                        Color.fromARGB(255, 191, 222, 255)),
                    // headingRowColor: const WidgetStatePropertyAll(
                    //   Color.fromARGB(255, 214, 214, 254),
                    // ),
                    columns: [
                      ...extractedDates.map((item) {
                        return DataColumn(
                            label: SizedBox(
                          width: 90,
                          child: Text(
                            textAlign: TextAlign.center,
                            style: headerStyles,
                            headerIndex == 1
                                ? '${appendZeroOrNot(item['day'].toString())} / ${appendZeroOrNot(item['month'].toString())} '
                                : headerIndex == 2
                                    ? weekdays[(item['weekday']! - 1)]
                                    : headerIndex == 3
                                        ? appendZeroOrNot(
                                            item['day'].toString())
                                        : '',
                          ),
                        ));
                      }),
                      DataColumn(
                        label: SizedBox(
                          width: 90,
                          child: Text(
                              textAlign: TextAlign.center,
                              style: headerStyles,
                              headerIndex == 2 ? 'Start' : ''),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 90,
                          child: Text(
                              textAlign: TextAlign.center,
                              style: headerStyles,
                              headerIndex == 2 ? 'Finish' : ''),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 90,
                          child: Text(
                              textAlign: TextAlign.center,
                              style: headerStyles,
                              headerIndex == 2 ? 'Total' : ''),
                        ),
                      ),
                    ],
                    rows: const []),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
