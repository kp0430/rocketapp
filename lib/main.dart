import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Rocket Launch Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget that will be started on the application startup
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  // set counter value
  int _counter = 0;
  
  //set color variable
List<Color> containerGradient = [Colors.red, Colors.redAccent];

  // Task 1: method to increase counter by 1
  void _ignite() {
    setState(() {
      // NOTE: Task 1 does not require a max cap
      _counter += 1;
      _counter = _counter.clamp(0,100);
      if(_counter == 100) {
        //show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("LIFTOFF!!!!",
            style: TextStyle(
              fontSize: 50.0,
              fontStyle: FontStyle.italic,
              color: Colors.red
            )

            )
            )
            );
      }
      _updateContainerColor();
    });
  }

  // Task 2: method to decrease counter by 1 (never below 0)
  void _abort() {
    setState(() {
      _counter = _counter - 1;
      _updateContainerColor();
       _counter = _counter.clamp(0,100);
      if (_counter < 0) _counter = 0; // prevent negative fuel
    });
  }

  // Task 2: method to reset counter to 0
  void _reset() {
    setState(() {
      _counter = 0;
      _updateContainerColor();
    });
  }

  void _updateContainerColor() {
    // 0 to 50 is a gradient change from red to orange
     if (_counter <= 50) {
    double t = (_counter.clamp(0, 50)) / 50;
    Color mix = Color.lerp(Colors.red, Colors.orange, t)!;
    containerGradient = [mix, mix.withOpacity(0.2)];
    //50 to 100 is a gradient change from orange to green
  } else {
    double t = ((_counter.clamp(50, 100)) - 50) / 50;
    Color mix2 = Color.lerp(Colors.orange, Colors.green, t)!;
    containerGradient = [mix2, mix2.withOpacity(0.2)];
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
      ),
      // set up the widget alignment
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:containerGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
                ),
              ),
              child: Text(
                // to displays current number
                '$_counter',
                style: TextStyle(fontSize: 50.0),
              ),
            ),
          ),

          // slider to adjust the counter value
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble().clamp(0, 100),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
                _updateContainerColor();
                if(_counter == 100) {
        //show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("LIFTOFF!!!!",
            style: TextStyle(
              fontSize: 50.0,
              fontStyle: FontStyle.italic,
              color: Colors.red
            )

            ),
            )
            );
      }
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),

          // Ignite button (Task 1) — placed BELOW the slider per requirement
          ElevatedButton(
            onPressed: _ignite,
            child: const Text("Ignite +1"),
          ),

          // Task 2: Abort (decrement) and Reset buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: _abort,
                child: const Text('Abort -1'),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _reset,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
