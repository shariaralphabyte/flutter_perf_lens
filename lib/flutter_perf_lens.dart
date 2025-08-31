
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/performance_monitor.dart';
import 'src/performance_overlay.dart' as perf_overlay;
import 'src/network_interceptor.dart';
import 'src/rebuild_detector.dart';

export 'src/performance_monitor.dart';
export 'src/rebuild_detector.dart';
export 'src/perf_lens_theme.dart';

class PerfLens extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final bool showOverlay;
  final bool interceptNetwork;

  const PerfLens({
    Key? key,
    required this.child,
    this.enabled = kDebugMode,
    this.showOverlay = true,
    this.interceptNetwork = true,
  }) : super(key: key);

  @override
  State<PerfLens> createState() => _PerfLensState();
}

class _PerfLensState extends State<PerfLens> {
  HttpOverrides? _previousOverrides;

  @override
  void initState() {
    super.initState();
    
    if (widget.enabled) {
      _initializePerformanceMonitoring();
    }
  }

  void _initializePerformanceMonitoring() {
    // Start performance monitoring
    PerformanceMonitor().startMonitoring();
    
    // Start widget observer
    PerfLensWidgetObserver().startObserving();
    
    // Setup network interception
    if (widget.interceptNetwork) {
      _previousOverrides = HttpOverrides.current;
      HttpOverrides.global = PerfLensHttpOverrides(_previousOverrides);
    }
  }

  @override
  void dispose() {
    if (widget.enabled) {
      PerformanceMonitor().stopMonitoring();
      PerfLensWidgetObserver().stopObserving();
      
      if (widget.interceptNetwork && _previousOverrides != null) {
        HttpOverrides.global = _previousOverrides;
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        if (widget.showOverlay)
          const perf_overlay.PerfLensOverlay(),
      ],
    );
  }
}

class FlutterPerfLens {
  static void enableGlobalMonitoring({
    bool interceptNetwork = true,
  }) {
    if (kDebugMode) {
      PerformanceMonitor().startMonitoring();
      PerfLensWidgetObserver().startObserving();
      
      if (interceptNetwork) {
        final previous = HttpOverrides.current;
        HttpOverrides.global = PerfLensHttpOverrides(previous);
      }
    }
  }

  static void disableGlobalMonitoring() {
    PerformanceMonitor().stopMonitoring();
    PerfLensWidgetObserver().stopObserving();
  }

  static Stream<PerformanceMetrics> get metricsStream => 
      PerformanceMonitor().metricsStream;

  // Legacy method for backward compatibility
  Future<String?> getPlatformVersion() async {
    return 'Flutter PerfLens v0.0.1';
  }
}
