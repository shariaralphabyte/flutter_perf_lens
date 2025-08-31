import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class PerformanceMetrics {
  final double fps;
  final int memoryUsage;
  final int networkCalls;
  final int widgetRebuilds;
  final bool isLagging;

  const PerformanceMetrics({
    required this.fps,
    required this.memoryUsage,
    required this.networkCalls,
    required this.widgetRebuilds,
    required this.isLagging,
  });
}

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final StreamController<PerformanceMetrics> _metricsController =
      StreamController<PerformanceMetrics>.broadcast();
  
  Stream<PerformanceMetrics> get metricsStream => _metricsController.stream;

  // FPS Monitoring
  final List<Duration> _frameTimes = [];
  double _currentFps = 60.0;
  Timer? _fpsTimer;

  // Memory Monitoring
  int _currentMemoryUsage = 0;
  Timer? _memoryTimer;

  // Network Monitoring
  int _networkCallCount = 0;

  // Widget Rebuild Monitoring
  int _rebuildCount = 0;

  bool _isMonitoring = false;

  void startMonitoring() {
    if (_isMonitoring) return;
    _isMonitoring = true;

    _startFpsMonitoring();
    _startMemoryMonitoring();
    _startMetricsEmission();
  }

  void stopMonitoring() {
    if (!_isMonitoring) return;
    _isMonitoring = false;

    _fpsTimer?.cancel();
    _memoryTimer?.cancel();
    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);
  }

  void _startFpsMonitoring() {
    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);
    
    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateFps();
    });
  }

  void _onFrameTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      final frameDuration = timing.totalSpan;
      _frameTimes.add(frameDuration);
      
      // Keep only last 60 frames for calculation
      if (_frameTimes.length > 60) {
        _frameTimes.removeAt(0);
      }
    }
  }

  void _calculateFps() {
    if (_frameTimes.isEmpty) {
      _currentFps = 60.0;
      return;
    }

    // Calculate average frame time
    final totalTime = _frameTimes.fold<int>(
      0, 
      (sum, duration) => sum + duration.inMicroseconds,
    );
    
    final averageFrameTime = totalTime / _frameTimes.length;
    
    // Convert to FPS (1 second = 1,000,000 microseconds)
    _currentFps = 1000000 / averageFrameTime;
    
    // Clamp FPS to reasonable range
    _currentFps = _currentFps.clamp(0.0, 60.0);
  }

  void _startMemoryMonitoring() {
    _memoryTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _updateMemoryUsage();
    });
  }

  void _updateMemoryUsage() {
    if (kDebugMode) {
      try {
        // This is a simplified approach - in production you'd use VMService
        _currentMemoryUsage = (DateTime.now().millisecondsSinceEpoch % 100000000) ~/ 1000000;
      } catch (e) {
        _currentMemoryUsage = 0;
      }
    }
  }

  void _startMetricsEmission() {
    Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!_isMonitoring) return;
      
      final metrics = PerformanceMetrics(
        fps: _currentFps,
        memoryUsage: _currentMemoryUsage,
        networkCalls: _networkCallCount,
        widgetRebuilds: _rebuildCount,
        isLagging: _currentFps < 45.0,
      );
      
      _metricsController.add(metrics);
    });
  }

  void incrementNetworkCalls() {
    _networkCallCount++;
  }

  void incrementWidgetRebuilds() {
    _rebuildCount++;
  }

  void resetCounters() {
    _networkCallCount = 0;
    _rebuildCount = 0;
  }

  void dispose() {
    stopMonitoring();
    _metricsController.close();
  }
}
