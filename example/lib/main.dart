import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_perf_lens/flutter_perf_lens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PerfLens(
      child: MaterialApp(
        title: 'PerfLens Demo',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: const DemoHomePage(),
      ),
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _heavyComputationTimer;
  Timer? _networkTimer;
  List<Widget> _widgets = [];
  int _counter = 0;
  bool _isPerformingHeavyTask = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _heavyComputationTimer?.cancel();
    _networkTimer?.cancel();
    super.dispose();
  }

  void _addWidgets() {
    setState(() {
      _widgets.addAll(
        List.generate(
          50,
          (index) => RebuildDetector(
            debugLabel: 'DemoWidget_$index',
            child: Container(
              margin: const EdgeInsets.all(4),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _clearWidgets() {
    setState(() {
      _widgets.clear();
    });
  }

  void _startHeavyComputation() {
    setState(() {
      _isPerformingHeavyTask = true;
    });

    _heavyComputationTimer = Timer.periodic(const Duration(milliseconds: 16), (
      timer,
    ) {
      // Simulate heavy computation that blocks the UI thread
      final random = Random();
      var sum = 0;
      for (int i = 0; i < 100000; i++) {
        sum += random.nextInt(1000);
      }

      setState(() {
        _counter = sum % 1000;
      });

      if (timer.tick > 120) {
        timer.cancel();
        setState(() {
          _isPerformingHeavyTask = false;
        });
      }
    });
  }

  void _makeNetworkCalls() {
    _networkTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) async {
      try {
        final client = HttpClient();
        final request = await client.getUrl(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
        );
        final response = await request.close();
        await response.drain();
        client.close();
      } catch (e) {
        // Ignore network errors for demo
      }

      if (timer.tick > 10) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 PerfLens Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PerfLens Performance Monitor',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Look for the floating performance overlay! Tap it to expand/collapse, drag to move.',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Green border = Good performance\nRed border = Performance issues detected',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Performance Tests',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _addWidgets,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Widgets'),
                        ),
                        ElevatedButton.icon(
                          onPressed: _clearWidgets,
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Widgets'),
                        ),
                        ElevatedButton.icon(
                          onPressed:
                              _isPerformingHeavyTask
                                  ? null
                                  : _startHeavyComputation,
                          icon: const Icon(Icons.memory),
                          label: Text(
                            _isPerformingHeavyTask
                                ? 'Computing...'
                                : 'Heavy Task',
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _makeNetworkCalls,
                          icon: const Icon(Icons.network_check),
                          label: const Text('Network Calls'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isPerformingHeavyTask)
              Card(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Heavy Computation Running',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Counter: $_counter'),
                            const Text('Watch the FPS drop in PerfLens!'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Animated widget to show FPS changes
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 2 * 3.14159,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple, Colors.pink],
                        stops: [0.0, _animation.value, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.speed,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Widget grid to demonstrate rebuilds
            if (_widgets.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dynamic Widgets (${_widgets.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(children: _widgets),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        tooltip: 'Trigger Rebuild',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
