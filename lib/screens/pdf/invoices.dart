// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:furniture_app/screens/pdf/detail.dart';
// import 'package:furniture_app/screens/pdf/invoice_model.dart';
//
//
// class InvoicePage extends StatelessWidget {
//   InvoicePage({Key? key}) : super(key: key);
//
//   static String imageLogo = 'assets/icons/logo.png';
//   final invoices = <InvoiceModel>[
//     InvoiceModel(
//         customer: 'David Thomas',
//         address: '123 Fake St\r\nBermuda Triangle',
//         items: [
//           LineItem(
//             'Technical Engagement',
//             120,
//               'Deployment Assistance', 200,
//               imageLogo
//           ),
//           LineItem('Deployment Assistance', 200,'Deployment Assistance', 200,imageLogo),
//           LineItem('Develop Software Solution', 3020.45,'Deployment Assistance', 200,imageLogo),
//           LineItem('Produce Documentation', 840.50, 'Deployment Assistance', 200,imageLogo),
//         ],
//         name: 'Create and deploy software package'),
//     InvoiceModel(
//       customer: 'Michael Ambiguous',
//       address: '82 Unsure St\r\nBaggle Palace',
//       items: [
//         LineItem('Professional Advice', 100, 'Deployment Assistance', 200,imageLogo),
//         LineItem('Lunch Bill', 43.55, 'Deployment Assistance', 200,imageLogo),
//         LineItem('Remote Assistance', 50, 'Deployment Assistance', 200,imageLogo),
//       ],
//       name: 'Provide remote support after lunch',
//     ),
//     InvoiceModel(
//       customer: 'Marty McDanceFace',
//       address: '55 Dancing Parade\r\nDance Place',
//       items: [
//         LineItem('Program the robots', 400.50, 'Deployment Assistance', 200,imageLogo),
//         LineItem('Find tasteful dance moves for the robots', 80.55, 'Deployment Assistance', 200,imageLogo),
//         LineItem('General quality assurance', 80, 'Deployment Assistance', 200,imageLogo),
//       ],
//       name: 'Create software to teach robots how to dance',
//     )
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('InvoiceModels'),
//       ),
//       body: ListView(
//         children: [
//           ...invoices.map(
//                 (e) => ListTile(
//               title: Text(e.name),
//               subtitle: Text(e.customer),
//               trailing: Text('\$${e.totalCost().toStringAsFixed(2)}'),
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (builder) => DetailPage(invoice: e),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }