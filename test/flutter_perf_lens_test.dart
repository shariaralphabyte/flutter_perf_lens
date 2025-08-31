import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_perf_lens/flutter_perf_lens.dart';
import 'package:flutter_perf_lens/flutter_perf_lens_platform_interface.dart';
import 'package:flutter_perf_lens/flutter_perf_lens_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPerfLensPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPerfLensPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPerfLensPlatform initialPlatform = FlutterPerfLensPlatform.instance;

  test('$MethodChannelFlutterPerfLens is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPerfLens>());
  });

  test('getPlatformVersion', () async {
    FlutterPerfLens flutterPerfLensPlugin = FlutterPerfLens();
    MockFlutterPerfLensPlatform fakePlatform = MockFlutterPerfLensPlatform();
    FlutterPerfLensPlatform.instance = fakePlatform;

    expect(await flutterPerfLensPlugin.getPlatformVersion(), '42');
  });
}
