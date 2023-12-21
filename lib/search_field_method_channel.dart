import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'search_field_platform_interface.dart';

/// An implementation of [SearchFieldPlatform] that uses method channels.
class MethodChannelSearchField extends SearchFieldPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('search_field');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
