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

enum Turtle {
  forward, back, left, right, penup, pendown
}

class PageButton extends StatelessWidget {
  final Turtle pageId;
  final IconData pageIcon;

  const PageButton({
      super.key,
      required this.pageId,
      // TODO make this opt
      required this.pageIcon,
  });

  String makeButtonTitle(Turtle cmd) {
    switch (cmd) {
      case .forward:
      return 'Forward';
      case .back:
      return 'Back';
      case .right:
      case .left:
      return 'Turn';
      case .pendown:
      return 'Pen down';
      case .penup:
      return 'Pen up';
    }
  }

  Widget? getPage(Turtle cmd) {
    switch (cmd) {
      case .forward:
      return const ForwardScreen();
      case .back:
      return const BackScreen();
      case .right:
      case .left:
      return const TurnScreen();
      case .pendown:
      return null;
      case .penup:
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? destination = getPage(pageId);

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
              print('Command: ${makeButtonTitle(pageId)} ${result}');
            }

          } else {
            if (pageId == .penup || pageId == .pendown) {
              print('Command: ${makeButtonTitle(pageId)}');
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
                makeButtonTitle(pageId),
                style: TextStyle(fontSize: 22),
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
              flex: 6,
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
                          Expanded(child: PageButton(pageId: Turtle.pendown, pageIcon: Icons.draw)),
                          Expanded(child: PageButton(pageId: Turtle.penup, pageIcon: Icons.edit_off)),
                          ]),
                      Row(
                        children: [
                          Expanded(child: PageButton(pageId: Turtle.forward, pageIcon: Icons.arrow_upward)),
                          Expanded(child: PageButton(pageId: Turtle.back, pageIcon: Icons.arrow_downward)),
                        ]),
                      PageButton(pageId: Turtle.right, pageIcon: Icons.u_turn_right),
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
