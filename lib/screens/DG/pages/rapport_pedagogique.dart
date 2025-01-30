import 'package:flutter/material.dart';
import 'package:frontend/screens/DG/dg_screen.dart';
import 'package:frontend/utils/constants.dart';
import 'package:frontend/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';
// import 'package:flutter/rendering.dart';

class RapportPedagogiqueScreen extends StatelessWidget {
  RapportPedagogiqueScreen({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          ExampleSidebarX(controller: _controller, home: DGScreen(),),
          const Expanded(
            child: RapportPedagogiqueHome(),
          ),
        ],
      ),
    );
  }
}

class RapportPedagogiqueHome extends StatefulWidget {
  const RapportPedagogiqueHome({super.key});

  @override
  State<RapportPedagogiqueHome> createState() => _RapportPedagogiqueHomeState();
}

class _RapportPedagogiqueHomeState extends State<RapportPedagogiqueHome> {
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