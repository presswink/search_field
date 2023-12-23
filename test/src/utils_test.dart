import 'package:flutter_test/flutter_test.dart';
import 'package:search_field/src/Utils.dart';

void main(){
  test("buildKey method Testing ", () {
    final res = Utils.buildKey("hello bro");
    expect(res, "hello_bro");
  });
}

