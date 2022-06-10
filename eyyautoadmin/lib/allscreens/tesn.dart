
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';

// import 'addnote.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "todo app",
//       theme: ThemeData(
//         primaryColor: Colors.greenAccent[700],
//       ),
//       home: Home(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final fb = FirebaseDatabase.instance;
//   @override
//   Widget build(BuildContext context) {
//     final ref = fb.ref().child('todos');
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.indigo[900],
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => addnote(),
//             ),
//           );
//         },
//         child: Icon(
//           Icons.add,
//         ),
//       ),
//       appBar: AppBar(
//         title: Text(
//           'Todos',
//           style: TextStyle(
//             fontSize: 30,
//           ),
//         ),
//         backgroundColor: Colors.indigo[900],
//       ),
//       body: FirebaseAnimatedList(
//         query: ref,
//         shrinkWrap: true,
//         itemBuilder: (context, snapshot, animation, index) {
//           return GestureDetector(
//             onTap: () {},
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListTile(
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       color: Colors.white,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   tileColor: Colors.indigo[100],
//                   trailing: IconButton(
//                     icon: Icon(
//                       Icons.delete,
//                       color: Colors.red[900],
//                     ),
//                     onPressed: () {
//                       ref.child(snapshot.key!).remove();
//                     },
//                   ),
//                   title: Text(
//                     snapshot.value.toString(),
//                     style: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
