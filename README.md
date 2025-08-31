# 🔥 flutter_perf_lens

**The Lighthouse for Flutter Apps** - A one-line integration performance monitoring plugin that overlays real-time performance metrics on your Flutter app.

[![pub package](https://img.shields.io/pub/v/flutter_perf_lens.svg)](https://pub.dev/packages/flutter_perf_lens)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

- **🎯 One-line integration** - Just wrap your app with `PerfLens()`
- **📊 Real-time FPS monitoring** - See frame rate drops instantly
- **🧠 Memory usage tracking** - Monitor heap usage and GC activity
- **🌐 Network call debugging** - Track HTTP requests automatically
- **🔄 Widget rebuild detection** - Identify excessive rebuilds
- **🎨 Draggable overlay UI** - Move and expand/collapse the monitor
- **🌙 Theme support** - Auto-adapts to light/dark themes
- **🐛 Debug-only** - Automatically disabled in release builds

## 🚀 Quick Start

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_perf_lens: ^0.0.1
```

### Usage

**Option 1: Wrap your entire app (Recommended)**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_perf_lens/flutter_perf_lens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PerfLens(
      child: MaterialApp(
        title: 'My App',
        home: HomePage(),
      ),
    );
  }
}
```

**Option 2: Global monitoring**

```dart
import 'package:flutter_perf_lens/flutter_perf_lens.dart';

void main() {
  FlutterPerfLens.enableGlobalMonitoring();
  runApp(MyApp());
}
```

That's it! 🎉 You'll see a floating performance monitor overlay on your app.

## 📱 How to Use the Overlay

- **Tap** to expand/collapse detailed metrics
- **Drag** to move the overlay around the screen
- **Green border** = Good performance (FPS > 55)
- **Red border** = Performance issues detected (FPS < 45)

### Compact View
Shows just the FPS with a color-coded indicator.

### Expanded View
Shows detailed metrics:
- **FPS** - Frames per second
- **Memory** - Current memory usage
- **Network** - Number of network calls
- **Rebuilds** - Widget rebuild count

## 🛠️ Advanced Configuration

```dart
PerfLens(
  enabled: kDebugMode,           // Enable/disable monitoring
  showOverlay: true,             // Show/hide the overlay
  interceptNetwork: true,        // Enable network monitoring
  child: MyApp(),
)
```

## 🎨 Custom Theming

PerfLens automatically adapts to your app's theme, but you can customize it:

```dart
import 'package:flutter_perf_lens/flutter_perf_lens.dart';

// The overlay will automatically use light/dark theme based on system
// No additional configuration needed!
```

## 🔍 Detecting Widget Rebuilds

Wrap specific widgets to monitor their rebuild frequency:

```dart
RebuildDetector(
  debugLabel: 'MyExpensiveWidget',
  child: MyExpensiveWidget(),
)
```

Excessive rebuilds (>10) will be logged to the console in debug mode.

## 📊 Performance Metrics

### FPS Monitoring
- Uses `SchedulerBinding.instance.addTimingsCallback`
- Calculates real-time frame rates
- Color-coded indicators:
  - 🟢 Green: 55+ FPS (Smooth)
  - 🟠 Orange: 45-54 FPS (Minor lag)
  - 🔴 Red: <45 FPS (Performance issues)

### Memory Tracking
- Monitors heap usage
- Tracks garbage collection frequency
- Helps identify memory leaks

### Network Monitoring
- Intercepts all HTTP calls using `HttpOverrides`
- Counts requests automatically
- No impact on network performance

### Widget Rebuilds
- Detects unnecessary widget rebuilds
- Helps optimize widget trees
- Debug console warnings for excessive rebuilds

## 🎯 Why PerfLens?

Every Flutter developer struggles with app performance, but learning DevTools can be overwhelming. PerfLens gives you instant visual feedback with zero learning curve.

### Perfect for:
- 🚀 **Rapid prototyping** - Spot performance issues early
- 🐛 **Debugging** - Visual feedback during development
- 📈 **Optimization** - Monitor improvements in real-time
- 👥 **Team collaboration** - Share performance screenshots
- 🎓 **Learning** - Understand Flutter performance patterns

## 🔮 Roadmap

- [ ] **Export Performance Reports** - JSON/CSV summaries
- [ ] **Custom Alerts** - Configurable performance thresholds
- [ ] **CI/CD Integration** - Automated performance reports
- [ ] **Remote Dashboard** - Desktop/web monitoring interface
- [ ] **Battery Impact Monitoring** - Advanced power usage tracking
- [ ] **Custom Metrics** - Plugin API for custom measurements

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by Chrome DevTools Lighthouse
- Built with ❤️ for the Flutter community
- Special thanks to all contributors

---

**Made with 🔥 by the Flutter community**

*If PerfLens helped you optimize your app, consider giving it a ⭐ on GitHub!*

## 🏷️ Tags

#Flutter #FlutterDev #PerformanceMonitoring #DevTools #MobileApp #AppOptimization #FPS #MemoryUsage #NetworkMonitoring #WidgetRebuild #FlutterPlugin #DeveloperTools #AppPerformance #Lighthouse #ChromeDevTools #FlutterCommunity #OpenSource #MIT #Debugging #Profiling #RealTimeMonitoring #UIPerformance #MobileDevelopment #CrossPlatform #DartLang #FlutterPackage #PubDev #GitHub #SoftwareDevelopment #CodeOptimization
