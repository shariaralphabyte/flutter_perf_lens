# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-31

### Added
- 🎯 **One-line integration** - Simple `PerfLens(child: MyApp())` wrapper
- 📊 **Real-time FPS monitoring** - Live frame rate tracking with color-coded indicators
- 🧠 **Memory usage tracking** - Heap monitoring and GC activity detection
- 🌐 **Network call debugging** - Automatic HTTP request interception and counting
- 🔄 **Widget rebuild detection** - Identify excessive widget rebuilds with debug logging
- 🎨 **Draggable overlay UI** - Beautiful floating performance monitor
- 📱 **Interactive overlay** - Tap to expand/collapse, drag to reposition
- 🌙 **Theme support** - Auto-adapts to light/dark themes
- 🐛 **Debug-only operation** - Automatically disabled in release builds
- 🎛️ **Configurable options** - Enable/disable specific monitoring features
- 📦 **Zero dependencies** - Pure Flutter implementation
- 🚀 **Performance optimized** - Minimal impact on app performance

### Features
- **FPS Monitoring**: Uses `SchedulerBinding.instance.addTimingsCallback` for accurate frame timing
- **Memory Tracking**: Real-time heap usage monitoring
- **Network Interception**: HTTP call counting via `HttpOverrides`
- **Rebuild Detection**: `RebuildDetector` wrapper for widget optimization
- **Visual Indicators**: Color-coded performance status (Green = Good, Red = Issues)
- **Responsive UI**: Smooth animations and transitions
- **Cross-platform**: Works on iOS, Android, Web, Desktop

### Technical Details
- Minimum Flutter SDK: 3.3.0
- Minimum Dart SDK: 3.7.2
- License: MIT
- Platform support: iOS, Android, Web, Desktop

### Documentation
- Comprehensive README with usage examples
- Interactive demo app with performance stress tests
- API documentation for all public methods
- Migration guide for future versions
