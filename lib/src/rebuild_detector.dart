import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'performance_monitor.dart';

class RebuildDetector extends StatefulWidget {
  final Widget child;
  final String? debugLabel;

  const RebuildDetector({
    Key? key,
    required this.child,
    this.debugLabel,
  }) : super(key: key);

  @override
  State<RebuildDetector> createState() => _RebuildDetectorState();
}

class _RebuildDetectorState extends State<RebuildDetector> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _rebuildCount++;
      PerformanceMonitor().incrementWidgetRebuilds();
      
      if (kDebugMode && _rebuildCount > 10) {
        debugPrint('⚠️ PerfLens: Widget "${widget.debugLabel ?? widget.runtimeType}" has rebuilt $_rebuildCount times');
      }
    }
    
    return widget.child;
  }
}

class PerfLensWidgetObserver extends WidgetsBindingObserver {
  static final PerfLensWidgetObserver _instance = PerfLensWidgetObserver._internal();
  factory PerfLensWidgetObserver() => _instance;
  PerfLensWidgetObserver._internal();

  bool _isObserving = false;

  void startObserving() {
    if (_isObserving) return;
    _isObserving = true;
    WidgetsBinding.instance.addObserver(this);
  }

  void stopObserving() {
    if (!_isObserving) return;
    _isObserving = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      PerformanceMonitor().resetCounters();
    }
  }
}
