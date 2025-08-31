import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_perf_lens_method_channel.dart';

abstract class FlutterPerfLensPlatform extends PlatformInterface {
  /// Constructs a FlutterPerfLensPlatform.
  FlutterPerfLensPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPerfLensPlatform _instance = MethodChannelFlutterPerfLens();

  /// The default instance of [FlutterPerfLensPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPerfLens].
  static FlutterPerfLensPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPerfLensPlatform] when
  /// they register themselves.
  static set instance(FlutterPerfLensPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
