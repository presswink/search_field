
import 'package:text_search_field/src/text_search_field_data_model.dart';

class TextSearchFieldController {
  String text;
  bool isLoading;
  void Function(TextSearchFieldDataModel model)? selected;
  TextSearchFieldController({this.text ="", this.isLoading = false, this.selected});
}

