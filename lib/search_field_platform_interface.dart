import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'search_field_method_channel.dart';

abstract class SearchFieldPlatform extends PlatformInterface {
  /// Constructs a SearchFieldPlatform.
  SearchFieldPlatform() : super(token: _token);

  static final Object _token = Object();

  static SearchFieldPlatform _instance = MethodChannelSearchField();

  /// The default instance of [SearchFieldPlatform] to use.
  ///
  /// Defaults to [MethodChannelSearchField].
  static SearchFieldPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SearchFieldPlatform] when
  /// they register themselves.
  static set instance(SearchFieldPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
