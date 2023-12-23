import 'package:flutter_test/flutter_test.dart';
import 'package:search_field/search_field.dart';

void main(){
  test("should have keys", (){
    late SearchFieldDataModel data;
    final controller = SearchFieldController(text: "hello", isLoading: true, selected: (SearchFieldDataModel model){
      data = model;
    });
    controller.selected!(SearchFieldDataModel(key: "key", value: "value"));
    expect(controller.text, "hello");
    expect(controller.isLoading, true);
    expect(data.key, "key");
    expect(data.value, "value");
  });
}