import 'package:flutter/material.dart';
import 'package:studiovity_assignment/my_table.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 65,
          child: Text(
            'Day out of Days Report for Cast Members',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: SizedBox(
                height: constraints.maxHeight,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: MyTable(),
                ),
              ),
            );
          }),
        ),
        // SizedBox(
        //   height: 4,
        // )
      ],
    );
  }
}
