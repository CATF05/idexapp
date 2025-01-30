import 'package:flutter/material.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

class RapportFinanceScreen extends StatelessWidget {
  RapportFinanceScreen({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: DGScreen(),),
          const Expanded(
            child: RapportFinanceHome(),
          ),
        ],
      ),
    );
  }
}

class RapportFinanceHome extends StatefulWidget {
  const RapportFinanceHome({super.key});

  @override
  State<RapportFinanceHome> createState() => _RapportFinanceHomeState();
}

class _RapportFinanceHomeState extends State<RapportFinanceHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Les Professeurs", style: TextStyle(color: Colors.white)),
        backgroundColor: canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container()
    );
  }
}