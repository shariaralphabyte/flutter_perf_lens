import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_perf_lens_platform_interface.dart';

/// An implementation of [FlutterPerfLensPlatform] that uses method channels.
class MethodChannelFlutterPerfLens extends FlutterPerfLensPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_perf_lens');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
