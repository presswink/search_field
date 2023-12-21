
import 'search_field_platform_interface.dart';

class SearchField {
  Future<String?> getPlatformVersion() {
    return SearchFieldPlatform.instance.getPlatformVersion();
  }
}
