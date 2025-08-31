import 'dart:io';
import 'performance_monitor.dart';

class PerfLensHttpOverrides extends HttpOverrides {
  final HttpOverrides? _previous;
  
  PerfLensHttpOverrides(this._previous);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = _previous?.createHttpClient(context) ?? super.createHttpClient(context);
    return _PerfLensHttpClient(client);
  }
}

class _PerfLensHttpClient implements HttpClient {
  final HttpClient _inner;
  
  _PerfLensHttpClient(this._inner);

  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.open(method, host, port, path);
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.openUrl(method, url);
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.get(host, port, path);
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.getUrl(url);
  }

  @override
  Future<HttpClientRequest> post(String host, int port, String path) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.post(host, port, path);
  }

  @override
  Future<HttpClientRequest> postUrl(Uri url) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.postUrl(url);
  }

  @override
  Future<HttpClientRequest> put(String host, int port, String path) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.put(host, port, path);
  }

  @override
  Future<HttpClientRequest> putUrl(Uri url) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.putUrl(url);
  }

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.delete(host, port, path);
  }

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.deleteUrl(url);
  }

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.patch(host, port, path);
  }

  @override
  Future<HttpClientRequest> patchUrl(Uri url) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.patchUrl(url);
  }

  @override
  Future<HttpClientRequest> head(String host, int port, String path) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.head(host, port, path);
  }

  @override
  Future<HttpClientRequest> headUrl(Uri url) async {
    PerformanceMonitor().incrementNetworkCalls();
    return _inner.headUrl(url);
  }

  // Delegate all other properties and methods
  @override
  bool get autoUncompress => _inner.autoUncompress;

  @override
  set autoUncompress(bool value) => _inner.autoUncompress = value;

  @override
  Duration? get connectionTimeout => _inner.connectionTimeout;

  @override
  set connectionTimeout(Duration? value) => _inner.connectionTimeout = value;

  @override
  Duration get idleTimeout => _inner.idleTimeout;

  @override
  set idleTimeout(Duration value) => _inner.idleTimeout = value;

  @override
  int? get maxConnectionsPerHost => _inner.maxConnectionsPerHost;

  @override
  set maxConnectionsPerHost(int? value) => _inner.maxConnectionsPerHost = value;

  @override
  String? get userAgent => _inner.userAgent;

  @override
  set userAgent(String? value) => _inner.userAgent = value;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) =>
      _inner.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) =>
      _inner.addProxyCredentials(host, port, realm, credentials);

  @override
  void close({bool force = false}) => _inner.close(force: force);

  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) =>
      _inner.authenticate = f;

  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) =>
      _inner.authenticateProxy = f;

  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) =>
      _inner.badCertificateCallback = callback;

  @override
  set findProxy(String Function(Uri url)? f) => _inner.findProxy = f;

  @override
  set keyLog(Function(String line)? callback) => _inner.keyLog = callback;

  @override
  set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) =>
      _inner.connectionFactory = f;
}
