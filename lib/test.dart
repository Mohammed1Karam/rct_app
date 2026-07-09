// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:rct/view-model/cubits/order%20number/order_number_cubit.dart';

// // // Import your Cubit class
// // class OrderNumberScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Order Numbers"),
// //       ),
// //       body: BlocProvider(
// //         create: (context) => OrderNumberCubit()..fetchOrders(),
// //         child: BlocBuilder<OrderNumberCubit, OrderNumberState>(
// //           builder: (context, state) {
// //             if (state is OrderNumberLoading) {
// //               return Center(child: CircularProgressIndicator());
// //             } else if (state is OrderNumberSuccess) {
// //               final orderNumbers = state.orderNumber
// //                   .map((order) => order['number'])
// //                   .toList(); // Extract only the 'number' field

// //               return ListView.builder(
// //                 itemCount: orderNumbers.length,
// //                 itemBuilder: (context, index) {
// //                   final orderNumber = orderNumbers[index];
// //                   return ListTile(
// //                     title: Text("Order Number: $orderNumber"),
// //                   );
// //                 },
// //               );
// //             } else if (state is OrderNumberFailure) {
// //               return Center(
// //                 child: Text(
// //                   'Failed to load orders: ${state.errMessage}',
// //                   style: TextStyle(color: Colors.red),
// //                 ),
// //               );
// //             }

// //             return Center(child: Text('No orders to display.'));
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:jhijri/jHijri.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String _jHijriDate = "";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Hijri Date Converter"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: Text(_jHijriDate),
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           getDate();
//         },
//         child: const Icon(Icons.cached),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   getDate() {
//     final jh1 = JHijri.now();
//     final jh2 = JHijri(fMonth: 2, fYear: 1444, fDay: 11);
//     final jh3 = JHijri(fDate: DateTime.parse("1984-12-24"));
//     setState(() {
//       _jHijriDate = '''
//       ${jh1.dateTime.toString()}
//       ${jh1.hijri.westernDate.toString()}
//       ${jh2.hijri.toString()}
//       ${jh3.hijri.toMap().toString()}
//       ''';
//     });
//   }    
// }
