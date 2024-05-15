// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:game_design/pages/bouncing_ball.dart';

// void main() {
//   runApp(
//     GameWidget(
//       game: BouncingBall(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text('Lottery Game')),
        body: LotteryGame(),
      ),
    );
  }
}

class LotteryGame extends StatefulWidget {
  @override
  _LotteryGameState createState() => _LotteryGameState();
}

class _LotteryGameState extends State<LotteryGame> {
  late List<Ball> balls;
  Ball? selectedBall;
  Timer? timer;
  bool isAnimationStopped = false;

  @override
  void initState() {
    super.initState();
    balls = List.generate(9, (index) => Ball(index));
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!isAnimationStopped) {
        setState(() {
          selectedBall = (balls..shuffle()).first;
        });
      }
    });
  }

  void stopAnimation() {
    setState(() {
      isAnimationStopped = !isAnimationStopped;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BallAnimationWidget(
            balls: balls,
            isAnimationStopped: isAnimationStopped,
            selectedBall: selectedBall?.id,
          ),
        ),
        GestureDetector(
          onTap: stopAnimation,
          child: const Text(
            'Stop',
            style: TextStyle(color: Colors.white),
          ),
        ),
        if (selectedBall != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selected Ball: ${selectedBall!.id}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

class Ball {
  final int id;
  Ball(this.id);
}

class BallWidget extends StatelessWidget {
  final Ball ball;
  const BallWidget({Key? key, required this.ball}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            "lib/assets/color_win_ball_${ball.id}.png",
          ),
        ),
      ),
    );
  }
}

class BallAnimationWidget extends StatefulWidget {
  final List<Ball> balls;
  final bool isAnimationStopped;
  final int? selectedBall;
  const BallAnimationWidget({
    super.key,
    required this.balls,
    required this.isAnimationStopped,
    this.selectedBall,
  });

  @override
  _BallAnimationWidgetState createState() => _BallAnimationWidgetState();
}

class _BallAnimationWidgetState extends State<BallAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _positions;

  final double radius = 75.0; // Adjust the radius as needed

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    )..repeat();
    _positions =
        List.generate(widget.balls.length, (index) => _randomPosition());

    // Update positions periodically
    Timer.periodic(Duration(milliseconds: 120), (timer) {
      if (!widget.isAnimationStopped) {
        setState(() {
          _positions =
              List.generate(widget.balls.length, (index) => _randomPosition());
        });
      }
    });
  }

  Offset _randomPosition() {
    final random = Random();
    final angle = random.nextDouble() * 2 * pi;
    final r = sqrt(random.nextDouble()) *
        (radius - 25); // Adjust for ball radius (25)
    final x = r * cos(angle) + radius;
    final y = r * sin(angle) + radius - 10;
    return Offset(x, y);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 520,
        width: 280,
        child: Stack(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: (radius + 10) * 2,
                    height: (radius + 10) * 2,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // border: Border.all(color: Colors.black),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('lib/assets/circle.png'),
                      ),
                    ),
                    child: Stack(
                      children: widget.balls.asMap().entries.map((entry) {
                        int index = entry.key;
                        Ball ball = entry.value;
                        return AnimatedPositioned(
                          duration: const Duration(milliseconds: 120),
                          left: _positions[index].dx,
                          top: _positions[index].dy,
                          child: BallWidget(ball: ball),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                "lib/assets/stand.png",
              ),
            ),
            if (widget.selectedBall != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 110,
                child: Image.asset(
                  "lib/assets/color_win_ball_${widget.selectedBall}.png",
                  width: 50,
                  height: 50,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
