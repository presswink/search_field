import 'package:search_field/search_field.dart';

class SearchFieldController {
  String text;
  bool isLoading;
  void Function(SearchFieldDataModel model)? selected;
  SearchFieldController({this.text ="", this.isLoading = false, this.selected});
}

