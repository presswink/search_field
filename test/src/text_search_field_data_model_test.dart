
import 'package:flutter_test/flutter_test.dart';
import 'package:text_search_field/text_search_field.dart';

void main(){
  test("should have keys", () {
    final model = TextSearchFieldDataModel(key: "key", value: "value");
    expect(model.key, "key");
    expect(model.value, "value");
  });
}