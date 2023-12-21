import 'package:flutter_test/flutter_test.dart';
import 'package:search_field/search_field.dart';
import 'package:search_field/search_field_platform_interface.dart';
import 'package:search_field/search_field_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSearchFieldPlatform
    with MockPlatformInterfaceMixin
    implements SearchFieldPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SearchFieldPlatform initialPlatform = SearchFieldPlatform.instance;

  test('$MethodChannelSearchField is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSearchField>());
  });

  test('getPlatformVersion', () async {
    SearchField searchFieldPlugin = SearchField();
    MockSearchFieldPlatform fakePlatform = MockSearchFieldPlatform();
    SearchFieldPlatform.instance = fakePlatform;

    expect(await searchFieldPlugin.getPlatformVersion(), '42');
  });
}
