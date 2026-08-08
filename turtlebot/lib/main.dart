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

class TurtleCommand {
  Turtle command;
  num? magnitude;

  TurtleCommand(this.command, [this.magnitude]);

  @override
  String toString() {
    String name = command.name.toUpperCase();
    if (magnitude != null) {
      final int m = magnitude!.round().toInt();
      return '${name} ${m}';
    }
    return name;
  }
}

class CommandNotification extends Notification {
  final TurtleCommand command;

  CommandNotification(this.command);
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

            if (result != null && result is num) {
              print('Command: ${makeButtonTitle(pageId)} ${result}');
              if (pageId == .right && result > 180) {
                // pas tres catholique tout ca
                CommandNotification(TurtleCommand(Turtle.left, 360 - result)).dispatch(context);
              } else {
                CommandNotification(TurtleCommand(pageId, result)).dispatch(context);
              }
            }

          } else {
            if (pageId == .penup || pageId == .pendown) {
              print('Command: ${makeButtonTitle(pageId)}');
              CommandNotification(TurtleCommand(pageId)).dispatch(context);
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var commands = <TurtleCommand>[];
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addCommand(TurtleCommand command) {
    print('Adding: ${command}');
    setState(() {
        commands.add(command);
        _needsScroll = true;
    });
    print('Current list: ${commands}');
  }

  void _popCommand() {
    setState(() {
        commands.removeLast();
        _needsScroll = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToBottom());
      _needsScroll = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turtlebot'),
      ),
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Commands view
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child:
                ListView.builder(
                  controller: _scrollController,
                  itemCount: commands.length,
                  itemBuilder: (context, index) {
                    final cmd = commands[index];
                    return Text(
                        cmd.toString(),
                        style: TextStyle(fontSize: 20.0));
                    }))),

            SizedBox(height: 12),

            // Page & Action Buttons
            NotificationListener<CommandNotification>(
              onNotification: (notification) {
                _addCommand(notification.command);
                return true;    // Consume notification
              },
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

            SizedBox(height: 20),

            // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filledTonal(
                    onPressed: _popCommand,
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
            )]),

            SizedBox(height: 20),
    ]))));
  }
}
