import 'package:search_field/search_field.dart';

class SearchFieldController {
  String text;
  bool isLoading;
  bool selected;
  void Function(SearchFieldDataModel item)? fetch;
  SearchFieldController({this.text ="", this.isLoading = false, this.selected = true});
}

