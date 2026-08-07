import 'package:flutter/material.dart';
import 'screens/turn.dart';
import 'screens/forward.dart';
import 'screens/back.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class PageButton extends StatelessWidget {
  final String pageId;
  final IconData pageIcon;

  const PageButton({
      super.key,
      required this.pageId,
      // TODO make this opt
      required this.pageIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget? destination = null;

    // FIXME this is ugly
    if (pageId == 'Forward') {
      destination = const ForwardScreen();
    } else if (pageId == 'Back') {
      destination = const BackScreen();
    } else if (pageId == 'Turn') {
      destination = const TurnScreen();
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () async {
          if (destination != null) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => destination as Widget,
            ));

            if (result != null) {
              // TODO: add to command stack
              print('Got result: ${result}');
            }
          }
        },
        style: ElevatedButton.styleFrom(
          // TODO: make buttons stand out more
          // y google hate contrast?
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          )
        ),
        child: Row(
          children: [
            Icon(pageIcon,
              size: 32.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                pageId,
                style: TextStyle(fontSize: 28),
    ))])));
}}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turtlebot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Commands view
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Text(
                  'Command list',
                  style: TextStyle(fontSize: 24.0),
            ))),

            SizedBox(height: 12),

            // Page & Action Buttons
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                      Row(
                        children: [
                          Expanded(child: PageButton(pageId: 'Pen Up', pageIcon: Icons.draw)),
                          Expanded(child: PageButton(pageId: 'Down', pageIcon: Icons.edit_off)),
                          ]),
                      Row(
                        children: [
                          Expanded(child: PageButton(pageId: 'Forward', pageIcon: Icons.arrow_upward)),
                          Expanded(child: PageButton(pageId: 'Back', pageIcon: Icons.arrow_downward)),
                        ]),
                      PageButton(pageId: 'Turn', pageIcon: Icons.u_turn_right),
            ])),

            // Action buttons
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, size: 50.0),
                    tooltip: 'Erase Last',
                  ),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.stop, size: 50.0),
                    style: IconButton.styleFrom(backgroundColor: Colors.red),
                    tooltip: 'Stop',
                  ),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow, size: 50.0),
                    style: IconButton.styleFrom(backgroundColor: Colors.green),
                    tooltip: 'Run',
            )]))
    ])));
  }
}
