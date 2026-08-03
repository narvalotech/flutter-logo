import 'package:flutter/material.dart';

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
    return ElevatedButton(
      onPressed: () {
        print('pressed: $pageId');
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Row(
        children: [
          Icon(pageIcon,
          size: 32.0),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              pageId,
              style: TextStyle(fontSize: 30),
            )
          ),
        ],
      ),
    );
  }
}

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
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: const Text(
                  'Command list',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),

            // Page & Action Buttons
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PageButton(pageId: 'Pen Up / Down', pageIcon: Icons.create),
                      SizedBox(height: 12),
                      PageButton(pageId: 'Forward', pageIcon: Icons.arrow_upward),
                      SizedBox(height: 12),
                      PageButton(pageId: 'Turn', pageIcon: Icons.u_turn_right),
                  ]),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                        tooltip: 'Erase Last',
                      ),
                      IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.stop),
                        style: IconButton.styleFrom(backgroundColor: Colors.red),
                        tooltip: 'Stop',
                      ),
                      IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow),
                        style: IconButton.styleFrom(backgroundColor: Colors.green),
                        tooltip: 'Run',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main app widget layout:
// - x split (column)
//   - text view
//   - button area
//     - column
//       - "pen up/down"
//       - "forward"
//       - "turn"
//       - y split (row)
//       (icon row)
//         - erase last
//         - stop
//         - play
