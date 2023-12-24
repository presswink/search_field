import 'package:flutter_test/flutter_test.dart';
import 'package:text_search_field/text_search_field.dart';

void main() {
  test("should have keys", () {
    late TextSearchFieldDataModel data;
    final controller = TextSearchFieldController(
        text: "hello",
        isLoading: true,
        selected: (TextSearchFieldDataModel model) {
          data = model;
        });
    controller.selected!(TextSearchFieldDataModel(key: "key", value: "value"));
    expect(controller.text, "hello");
    expect(controller.isLoading, true);
    expect(data.key, "key");
    expect(data.value, "value");
  });
}
