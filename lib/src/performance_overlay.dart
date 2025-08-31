import 'dart:async';
import 'package:flutter/material.dart';
import 'performance_monitor.dart';
import 'perf_lens_theme.dart';

class PerformanceOverlay extends StatefulWidget {
  const PerformanceOverlay({Key? key}) : super(key: key);

  @override
  State<PerformanceOverlay> createState() => _PerformanceOverlayState();
}

class _PerformanceOverlayState extends State<PerformanceOverlay>
    with TickerProviderStateMixin {
  StreamSubscription<PerformanceMetrics>? _subscription;
  PerformanceMetrics? _currentMetrics;
  bool _isExpanded = false;
  bool _isDragging = false;
  Offset _position = const Offset(20, 100);
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _subscription = PerformanceMonitor().metricsStream.listen((metrics) {
      if (mounted) {
        setState(() {
          _currentMetrics = metrics;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Color _getFpsColor(double fps) {
    if (fps >= 55) return Colors.green;
    if (fps >= 45) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentMetrics == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: (_) {
          _isDragging = true;
          _animationController.forward();
        },
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        onPanEnd: (_) {
          _isDragging = false;
          _animationController.reverse();
          
          // Snap to edges
          final screenSize = MediaQuery.of(context).size;
          setState(() {
            if (_position.dx < screenSize.width / 2) {
              _position = Offset(20, _position.dy);
            } else {
              _position = Offset(screenSize.width - 120, _position.dy);
            }
            
            // Keep within screen bounds
            _position = Offset(
              _position.dx.clamp(0, screenSize.width - 120),
              _position.dy.clamp(0, screenSize.height - 200),
            );
          });
        },
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isDragging ? _scaleAnimation.value : 1.0,
              child: _buildOverlayContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverlayContent() {
    final theme = PerfLensThemeData.getTheme(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isExpanded ? 200 : 100,
      height: _isExpanded ? 160 : 80,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _currentMetrics!.isLagging ? theme.errorColor : theme.successColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isExpanded ? _buildExpandedView() : _buildCompactView(),
      ),
    );
  }

  Widget _buildCompactView() {
    final theme = PerfLensThemeData.getTheme(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.speed,
              color: _getFpsColor(_currentMetrics!.fps),
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '${_currentMetrics!.fps.toStringAsFixed(0)}',
              style: TextStyle(
                color: _getFpsColor(_currentMetrics!.fps),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'FPS',
          style: TextStyle(
            color: theme.textColor.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
        if (_currentMetrics!.isLagging)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: theme.errorColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'LAG',
              style: TextStyle(
                color: theme.textColor,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExpandedView() {
    final theme = PerfLensThemeData.getTheme(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PerfLens',
              style: TextStyle(
                color: theme.textColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              _currentMetrics!.isLagging ? Icons.warning : Icons.check_circle,
              color: _currentMetrics!.isLagging ? theme.errorColor : theme.successColor,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildMetricRow(
          'FPS',
          '${_currentMetrics!.fps.toStringAsFixed(0)}',
          _getFpsColor(_currentMetrics!.fps),
          Icons.speed,
        ),
        _buildMetricRow(
          'Memory',
          '${_currentMetrics!.memoryUsage}MB',
          Colors.blue,
          Icons.memory,
        ),
        _buildMetricRow(
          'Network',
          '${_currentMetrics!.networkCalls}',
          Colors.purple,
          Icons.network_check,
        ),
        _buildMetricRow(
          'Rebuilds',
          '${_currentMetrics!.widgetRebuilds}',
          theme.warningColor,
          Icons.refresh,
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, Color color, IconData icon) {
    final theme = PerfLensThemeData.getTheme(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 6),
          Text(
            '$label:',
            style: TextStyle(
              color: theme.textColor.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
