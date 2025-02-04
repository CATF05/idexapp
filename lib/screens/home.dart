// import 'package:flutter/material.dart';
// import 'package:frontend/screens/comptable/account_screen.dart';
// import 'package:frontend/screens/comptable/facture.dart';
// import 'package:frontend/screens/comptable/paiement.dart';
// import 'package:frontend/screens/comptable/rapport.dart';
// import 'package:frontend/screens/comptable/transaction.dart';
// import 'package:frontend/screens/secretaire/secretaire.dart';
// import 'package:sidebarx/sidebarx.dart';

// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});

//   final _controller = SidebarXController(selectedIndex: 0, extended: true);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       // appBar: AppBar(
//       //   backgroundColor: primaryColor,
//       //   elevation: 0,
//       //   title: const Row(
//       //     children: [
//       //       // const Icon(Icons.school, color: Colors.white), // Icône représentant la finance
//       //       SizedBox(width: 8),
//       //       Text(
//       //         'AÏTA GUEYE SARR',
//       //         style: TextStyle(
//       //           fontSize: 26,
//       //           fontWeight: FontWeight.bold,
//       //           color: Colors.white,
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       //   actions: [
//       //     IconButton(
//       //       icon: const Icon(Icons.notifications, color: Colors.white),
//       //       onPressed: () {
//       //         // Remplacez 'SecretaireScreen()' par le nom de la page de secrétaire
//       //         Navigator.push(
//       //           context,
//       //           MaterialPageRoute(builder: (context) => SecretaryScreen()),
//       //         );
//       //       },
//       //     ),
//       //     IconButton(
//       //       icon: const Icon(Icons.settings, color: Colors.white),
//       //       onPressed: () {},
//       //     ),
//       //   ],
//       // ),
//       drawer: ExampleSidebarX(controller: _controller),
//       body: Row(
//         children: [
//           ExampleSidebarX(controller: _controller),
//           Expanded(
//             child: Center(
//               child: _ScreensExample(
//                 controller: _controller,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// class ExampleSidebarX extends StatelessWidget {
//   const ExampleSidebarX({
//     Key? key,
//     required SidebarXController controller,
//   })  : _controller = controller,
//         super(key: key);

//   final SidebarXController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return SidebarX(
//       controller: _controller,
//       theme: SidebarXTheme(
//         margin: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: canvasColor,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         hoverColor: scaffoldBackgroundColor,
//         textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
//         selectedTextStyle: const TextStyle(color: Colors.white),
//         hoverTextStyle: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w500,
//         ),
//         itemTextPadding: const EdgeInsets.only(left: 30),
//         selectedItemTextPadding: const EdgeInsets.only(left: 30),
//         itemDecoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: canvasColor),
//         ),
//         selectedItemDecoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: actionColor.withOpacity(0.37),
//           ),
//           gradient: const LinearGradient(
//             colors: [accentCanvasColor, canvasColor],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.28),
//               blurRadius: 30,
//             )
//           ],
//         ),
//         iconTheme: IconThemeData(
//           color: Colors.white.withOpacity(0.7),
//           size: 20,
//         ),
//         selectedIconTheme: const IconThemeData(
//           color: Colors.white,
//           size: 20,
//         ),
//       ),
//       extendedTheme: const SidebarXTheme(
//         width: 200,
//         decoration: BoxDecoration(
//           color: canvasColor,
//         ),
//       ),
//       footerDivider: divider,
//       headerBuilder: (context, extended) {
//         return const SizedBox(
//           height: 100,
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Icon(Icons.school, color: Colors.white, size: 40,),
//                 SizedBox(width: 8),
//                 Text(
//                   'AÏTA GUEYE SARR',
//                   style: TextStyle(
//                     fontSize: 19,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//       items: [
//         SidebarXItem(
//           icon: Icons.home,
//           label: 'Comptable',
//           onTap: () {
//             debugPrint('Home');
//           },
//         ),
//         const SidebarXItem(
//           icon: Icons.search,
//           label: 'Search',
//         ),
//         const SidebarXItem(
//           icon: Icons.people,
//           label: 'People',
//         ),
//         SidebarXItem(
//           icon: Icons.favorite,
//           label: 'Favorites',
//           selectable: false,
//           onTap: () => _showDisabledAlert(context),
//         ),
//         const SidebarXItem(
//           iconWidget: FlutterLogo(size: 20),
//           label: 'Flutter',
//         ),
//       ],
//     );
//   }

//   void _showDisabledAlert(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text(
//           'Item disabled for selecting',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//       ),
//     );
//   }
// }


// class _ScreensExample extends StatelessWidget {
//   const _ScreensExample({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);

//   final SidebarXController controller;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         final pageTitle = _getTitleByIndex(controller.selectedIndex);
//         switch (controller.selectedIndex) {
//           case 0:
//             return const AccountantScreen();
//           default:
//             return Text(
//               pageTitle,
//               style: theme.textTheme.headlineSmall,
//             );
//         }
//       },
//     );
//   }
// }


// String _getTitleByIndex(int index) {
//   switch (index) {
//     case 0:
//       return 'Home';
//     case 1:
//       return 'Search';
//     case 2:
//       return 'People';
//     case 3:
//       return 'Favorites';
//     case 4:
//       return 'Custom iconWidget';
//     case 5:
//       return 'Profile';
//     case 6:
//       return 'Settings';
//     default:
//       return 'Not found page';
//   }
// }

// const primaryColor = Color(0xFF685BFF);
// const canvasColor = Color(0xFF2E2E48);
// const scaffoldBackgroundColor = Color(0xFF464667);
// const accentCanvasColor = Color(0xFF3E3E61);
// const white = Colors.white;
// final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
// final divider = Divider(color: white.withOpacity(0.3), height: 1);