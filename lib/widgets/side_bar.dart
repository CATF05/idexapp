import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/firebase/controlers/auth_controler.dart';
import 'package:frontend/screens/DG/pages/notifications.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:sidebarx/sidebarx.dart';

class ExampleSidebarX extends ConsumerWidget {
  final Widget home;
  Widget? notif;
  ExampleSidebarX({
    Key? key,
    required SidebarXController controller,
    required this.home,
    this.notif,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context, ref) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return const SizedBox(
          height: 100,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.school, color: Colors.white, size: 40,),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            Navigator.pushReplacement(
              context, MaterialPageRoute(
                builder: (context) => home
              ),
            );
          },
        ),
        SidebarXItem(
          icon: Icons.notifications_active_outlined,
          label: 'Notifications',
          onTap: () {
            if (notif != null) {
              Navigator.pushReplacement(
                context, MaterialPageRoute(
                  builder: (context) => NotificationsDGScreen()
                ),
              );
            }
          },
        ),
        const SidebarXItem(
          icon: Icons.settings,
          label: 'Paramettres',
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'Deconnection',
          onTap: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Deconnexion'),
                content: const Text('Voulez-vous deconnecter'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Non'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(authControllerProvider.notifier).logOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Oui', style: TextStyle(color: Colors.red),),
                  ),
                ],
              ),
            );
          }
        ),
      ],
    );
  }
}


























// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:frontend/screens/comptable/account_screen.dart';

// class SideNavWidget extends StatefulWidget {
//   const SideNavWidget({
//     super.key,
//     int? selectedNav,
//   }) : this.selectedNav = selectedNav ?? 1;

//   final int selectedNav;

//   @override
//   State<SideNavWidget> createState() => _SideNavWidgetState();
// }

// class _SideNavWidgetState extends State<SideNavWidget> {
//     // State field(s) for MouseRegion widget.
//   bool mouseRegionHovered1 = false;
//   // State field(s) for MouseRegion widget.
//   bool mouseRegionHovered2 = false;
//   // State field(s) for MouseRegion widget.
//   bool mouseRegionHovered3 = false;
//   // State field(s) for MouseRegion widget.
//   bool mouseRegionHovered4 = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Container(
//         width: 270,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           boxShadow: const [
//             BoxShadow(
//               blurRadius: 3,
//               color: Color(0x33000000),
//               offset: Offset(
//                 0,
//                 1,
//               ),
//             )
//           ],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: const Color(0xffE0E3E7),
//             width: 1,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 16),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
//                       child: Icon(
//                         Icons.flourescent_rounded,
//                         color: Theme.of(context).primaryColor,
//                         size: 36,
//                       ),
//                     ),
//                     const Text(
//                       'flow.io',
//                       style:
//                           TextStyle(
//                                 fontFamily: 'Inter Tight',
//                                 letterSpacing: 0.0,
//                               ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(
//                 height: 12,
//                 thickness: 2,
//                 color: Color(0xffE0E3E7),
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
//                       child: Text(
//                         'Settings',
//                         style:
//                             TextStyle(
//                                   fontFamily: 'Inter',
//                                   letterSpacing: 0.0,
//                                 ),
//                       ),
//                     ),
//                     MouseRegion(
//                       opaque: false,
//                       cursor: MouseCursor.defer,
//                       onEnter: ((event) async {
//                         setState(() => mouseRegionHovered4 = true);
//                       }),
//                       onExit: ((event) async {
//                         setState(
//                             () => mouseRegionHovered4 = false);
//                       }),
//                       child: Padding(
//                         padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
//                         child: InkWell(
//                           splashColor: Colors.transparent,
//                           focusColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           onTap: () async {
//                             // context.pushNamed(
//                             //   'webFlow_04',
//                             //   extra: <String, dynamic>{
//                             //     kTransitionInfoKey: TransitionInfo(
//                             //       hasTransition: true,
//                             //       transitionType: PageTransitionType.fade,
//                             //       duration: Duration(milliseconds: 0),
//                             //     ),
//                             //   },
//                             // );
//                           },
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 350),
//                             curve: Curves.easeInOut,
//                             width: double.infinity,
//                             height: 44,
//                             decoration: BoxDecoration(
//                               color: () {
//                                 if (mouseRegionHovered4) {
//                                   return primaryColor;
//                                 } else if (widget.selectedNav == 4) {
//                                   return canvasColor;
//                                 } else {
//                                   return white;
//                                 }
//                               }(),
//                               borderRadius: BorderRadius.circular(12),
//                               shape: BoxShape.rectangle,
//                             ),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsetsDirectional.fromSTEB(8, 0, 6, 0),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Icon(
//                                     Icons.notifications_rounded,
//                                     color: widget.selectedNav == 4
//                                         ? primaryColor
//                                         : Colors.black,
//                                     size: 24,
//                                   ),
//                                   const Expanded(
//                                     child: Padding(
//                                       padding: EdgeInsetsDirectional.fromSTEB(
//                                           12, 0, 0, 0),
//                                       child: Text(
//                                         'Page Four',
//                                         style: TextStyle(
//                                               fontFamily: 'Inter',
//                                               letterSpacing: 0.0,
//                                             ),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 32,
//                                     decoration: BoxDecoration(
//                                       color: primaryColor,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: const Align(
//                                       alignment: AlignmentDirectional(0, 0),
//                                       child: Padding(
//                                         padding:
//                                             EdgeInsetsDirectional.fromSTEB(
//                                                 8, 4, 8, 4),
//                                         child: Text(
//                                           '12',
//                                           style: TextStyle(
//                                                 fontFamily: 'Inter',
//                                                 color: Colors.redAccent,
//                                                 letterSpacing: 0.0,
//                                               ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12)
//                   ],
//                 ),
//               ),
//               const Divider(
//                 height: 12,
//                 thickness: 2,
//                 color: Color(0xffE0E3E7),
//               ),
//               const Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
//                 child: Expanded(
//                   child: Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Andrew D.',
//                           style: TextStyle(
//                                 fontFamily: 'Inter',
//                                 letterSpacing: 0.0,
//                               ),
//                         ),
//                         Padding(
//                           padding:
//                               EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
//                           child: Text(
//                             'admin@gmail.com',
//                             style: TextStyle(
//                                   fontFamily: 'Inter',
//                                   letterSpacing: 0.0,
//                                 ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
