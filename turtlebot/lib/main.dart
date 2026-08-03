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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          print('pressed: $pageId');
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
                style: TextStyle(fontSize: 30),
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
                      PageButton(pageId: 'Pen Up / Down', pageIcon: Icons.create),
                      PageButton(pageId: 'Forward', pageIcon: Icons.arrow_upward),
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
