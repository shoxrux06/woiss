import 'package:flutter/material.dart';
import 'package:furniture_app/data/cart.dart';

class DataTableWidget extends StatelessWidget {
  final List<Cart> listOfColumns = [];
//  DataTableWidget(this.listOfColumns);     // Getting the data from outside, on initialization
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('N')),
        DataColumn(label: Text('ОБЪЯСНЕНИЕ')),
        DataColumn(label: Text('СПИСОК ЦЕН')),
        DataColumn(label: Text('ОБЩАЯ ЦЕНА СО СКИДКОЙ, СОМ')),
        DataColumn(label: Text('USD'))
    ],
      rows:
      listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
          .map(
        ((element) => DataRow(
          cells: <DataCell>[
            DataCell(Text(element.id.toString())), //Extracting from Map element the value
            // DataCell(Text(element.totalPrice.toString())), //Extracting from Map element the value
            // DataCell(Text(element.totalPrice.toString())), //Extracting from Map element the value
            DataCell(Text(element.quantity.toString())), //Extracting from Map element the value
          ],
        )),
      ).toList(),
    );
  }
}