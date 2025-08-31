
import 'flutter_perf_lens_platform_interface.dart';

class FlutterPerfLens {
  Future<String?> getPlatformVersion() {
    return FlutterPerfLensPlatform.instance.getPlatformVersion();
  }
}
