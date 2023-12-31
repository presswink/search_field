import 'package:flutter/material.dart';
import 'package:text_search_field/src/Utils.dart';
import 'package:text_search_field/src/text_search_field_controller.dart';
import 'package:text_search_field/src/text_search_field_data_model.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'global_key.dart';

/// this is a search for searching or filtering item from list, server or network
/// [hint] is a string to show hint to user in textSearchField,
/// using [inputBorder] you can change your textSearchField broder colors and style,
/// with [searchFieldTextStyle] you can change input text style of textSearchField,
/// and with [searchFieldHintTextStyle] you will be able to change hint text style,
/// if you want to add default or initial value to textSearchField you will able to do it with [initialValue],
/// you can add predefine list for filter in the search field using [filterItems],
/// if you want to enable [fullTextSearch] on default filter you can do it by enable this,
/// if you want to change keyboard input type or submit button then you will be able to do it by [textInputAction],
/// if you want to handle filter or search from the server then you will be able to do it using [fetch],
/// with [query] you can added custom filter code on predefined list,
/// you can change suggestion item touch ripple colors with [rippleColor],
/// whenever user will press submit button or they will touch suggestion item then [onSelected] method is going to trigger
/// with [controller] you will be able to add dependency and able to handle textSearchField widget
/// with [dependency] you can declare dependency on other textSearchField
/// if searchFiled has dependency on other searchFiled then after fetching initial searchFiled this [dependencyFetch] method is going to trigger
/// you can change text style with [suggestionTextStyle]
/// you you want to style your suggestion item you can do with [suggestionItemDecoration]
/// you can define height of suggestion item with [suggestionItemContainerHeight]
/// you can add alignment of text with [suggestionTextAlignment]
/// with [suggestionContainerHeight] you can define suggestion height
/// with [caseSensitive] you can enable and disable case sensitive of default query filter
///
class TextSearchField extends StatefulWidget {
  final String? hint;
  final InputBorder? inputBorder;
  final TextStyle? searchFieldTextStyle;
  final TextStyle? searchFieldHintTextStyle;
  final TextSearchFieldDataModel? initialValue;
  final List<TextSearchFieldDataModel>? filterItems;
  final bool fullTextSearch;
  final TextInputAction? textInputAction;
  final Future<List<TextSearchFieldDataModel>?> Function(String query)? fetch;
  final List<TextSearchFieldDataModel>? Function(
      List<TextSearchFieldDataModel>? filterItems, String query)? query;
  final Color? rippleColor;
  final Future<void> Function(
          bool isPrimary, int index, TextSearchFieldDataModel selectedItem)?
      onSelected;
  final TextSearchFieldController? controller;
  final TextSearchFieldController? dependency;
  final Future<List<TextSearchFieldDataModel>> Function(
      TextSearchFieldDataModel modelItem)? dependencyFetch;
  final TextStyle? suggestionTextStyle;
  final BoxDecoration? suggestionItemDecoration;
  final double suggestionItemContainerHeight;
  final Alignment? suggestionTextAlignment;
  final double suggestionContainerHeight;
  final bool caseSensitive;
  // constructor
  const TextSearchField({
    super.key,
    this.hint,
    this.inputBorder,
    this.searchFieldHintTextStyle,
    this.initialValue,
    this.filterItems,
    this.fetch,
    this.query,
    this.fullTextSearch = false,
    this.rippleColor,
    this.onSelected,
    this.controller,
    this.dependency,
    this.textInputAction,
    this.dependencyFetch,
    this.searchFieldTextStyle,
    this.suggestionTextStyle,
    this.suggestionItemDecoration,
    this.suggestionItemContainerHeight = 50,
    this.suggestionTextAlignment,
    this.suggestionContainerHeight = 250,
    this.caseSensitive = false
  });

  @override
  State<TextSearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<TextSearchField> {
  late FocusNode _focusNode;
  bool isLoading = false;
  List<TextSearchFieldDataModel>? items;
  TextSearchFieldDataModel? currentValue;
  bool isSelected = false;

  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();
  final _controller = TextEditingController();
  final _globalKey = GlobalKey();

  @override
  void initState() {
    _focusNode = FocusNode();
    // setting up initial value if there any
    if (widget.initialValue != null) {
      setCurrentValue(widget.initialValue!);
    }

    _focusNode.addListener(() {
      // showing and hiding search suggestion list
      if (_focusNode.hasFocus) {
        _overlayPortalController.show();
      } else {
        _overlayPortalController.hide();
      }
    });
    items = widget.filterItems;
    if (widget.dependency != null) {
      widget.dependency!.selected = (TextSearchFieldDataModel item) async {
        // enabling loader and search field
        setState(() {
          isLoading = true;
          isSelected = true;
        });
        // calling dependency fetch method
        if (widget.dependencyFetch != null) {
          items = await widget.dependencyFetch!(item);
        }
        // disabling loader after content fetch
        setState(() {
          isLoading = false;
        });
      };
    }
    super.initState();
  }

  void setCurrentValue(TextSearchFieldDataModel value) {
    currentValue = value;
    _controller.text = value.value!;
    if (widget.controller != null) {
      if (widget.controller!.selected != null) {
        widget.controller!.selected!(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      overlayChildBuilder: (BuildContext context) => Positioned(
        width: _globalKey.globalPaintBounds!.width,
        top: _globalKey.globalPaintBounds!.bottom,
        left: _globalKey.globalPaintBounds!.left,
        child: Container(
          alignment: Alignment.center,
          height: widget.suggestionContainerHeight,
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 15, offset: Offset(2, 3))
          ]),
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: items != null ? items!.length : 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return TouchRippleEffect(
                      rippleColor: widget.rippleColor ?? Colors.grey,
                      onTap: () {
                        _focusNode.unfocus();
                        setCurrentValue(items![index]);
                        if (widget.onSelected != null) {
                          widget.onSelected!(
                              index == 0 && _controller.value.text.isNotEmpty ? true : false, index, items![index]);
                        }
                      },
                      child: Container(
                        key: Key(items![index].key!),
                        alignment:
                            widget.suggestionTextAlignment ?? Alignment.center,
                        height: widget.suggestionItemContainerHeight,
                        decoration: widget.suggestionItemDecoration ??
                            const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                        child: Text(
                          items![index].value!,
                          style: widget.suggestionTextStyle ??
                              const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    );
                  }),
        ),
      ),
      controller: _overlayPortalController,
      child: TextField(
        key: _globalKey,
        controller: _controller,
        enabled: widget.dependency == null ? true : isSelected,
        style: widget.searchFieldTextStyle ??
            const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        focusNode: _focusNode,
        textInputAction: widget.textInputAction ?? TextInputAction.go,
        keyboardType: TextInputType.text,
        maxLines: 1,
        onEditingComplete: () {
          // on keyboard go button press we are treating this request as a initial / primary item selected in the list
          setCurrentValue(TextSearchFieldDataModel(
              key: Utils.buildKey(_controller.value.text),
              value: _controller.value.text));
          // triggering onSelected function
          if (widget.onSelected != null) {
            widget.onSelected!(_controller.value.text.isNotEmpty, 0, currentValue!);
          }
          // removing focus from search field
          _focusNode.unfocus();
        },
        onChanged: (String value) async {
          // enabling loader
          setState(() {
            isLoading = true;
          });

          if (widget.query != null) {
            // if user wants to add custom filter on query item then this statement is going to trigger
            items = widget.query!(widget.filterItems, value);
          } else if (widget.fetch != null) {
            // if user wants to add server / network query filter then this statement is going to trigger
            final res = await widget.fetch!(value);
            if (res!.isNotEmpty) {
              // if there is an item in the response then trigger this
              items = [
                TextSearchFieldDataModel(
                    key: Utils.buildKey(value), value: value),
                ...res
              ];
            } else {
              // if there is no items in the response then add on default item
              items = [
                TextSearchFieldDataModel(
                    key: Utils.buildKey(value), value: value)
              ];
            }
          } else {
            // if none of the function has defined then it's going to trigger as a default query filter function
            if (value.isNotEmpty) {
              String pattern = r"\b" + value + r"\b";
              RegExp wordRegex = RegExp(pattern, caseSensitive: widget.caseSensitive);
              final lists = widget.filterItems
                  ?.where((element) => element.value!
                      .contains(widget.fullTextSearch ? wordRegex : RegExp(value, caseSensitive: widget.caseSensitive)))
                  .toList();
              items = [
                TextSearchFieldDataModel(
                    key: Utils.buildKey(value), value: value),
                ...?lists
              ];
            } else {
              // if query string is empty then add default filter list in the request
              items = widget.filterItems;
            }
          }
          // disabling loader
          setState(() {
            isLoading = false;
          });
        },
        onTap: () {
          // this function is going to trigger on select search field
          _focusNode.requestFocus();
        },
        decoration: InputDecoration(
          border: widget.inputBorder ??
              const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black87,
                      width: 1.0,
                      style: BorderStyle.solid)),
          hintText: widget.hint ?? "please type your query",
          hintStyle: widget.searchFieldHintTextStyle ??
              const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
