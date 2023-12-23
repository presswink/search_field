import 'package:flutter_test/flutter_test.dart';
import 'package:search_field/search_field.dart';

void main(){
  test("should have keys", () {
    final model = SearchFieldDataModel(key: "key", value: "value");
    expect(model.key, "key");
    expect(model.value, "value");
  });
}