import 'package:flutter/material.dart';
import 'package:search_field/src/Utils.dart';
import 'package:search_field/src/search_field_controller.dart';
import 'package:search_field/src/search_field_data_model.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

class SearchField extends StatefulWidget {
  final InputDecoration? inputDecoration;
  final String? hint;
  final InputBorder? inputBorder;
  final TextStyle? hintTextStyle;
  final TextDirection? textDirection;
  final SearchFieldDataModel? initialValue;
  final List<SearchFieldDataModel>? filterItems;
  final Color? borderColor;
  final bool fullTextSearch;
  final TextInputAction? textInputAction;
  final Future<List<SearchFieldDataModel>?> Function(String query)? fetch;
  final List<SearchFieldDataModel>? Function(List<SearchFieldDataModel>? filterItems, String query)? query;
  final Color? rippleColor;
  final Future<void> Function(bool isPrimary, int index, SearchFieldDataModel selectedItem)? onSelected;
  final SearchFieldController? controller;
  final SearchFieldController? dependency;
  // constructor
  const SearchField({super.key, this.inputDecoration, this.hint, this.inputBorder, this.hintTextStyle, this.textDirection, this.initialValue, this.filterItems, this.borderColor, this.fetch, this.query, this.fullTextSearch = false, this.rippleColor, this.onSelected, this.controller, this.dependency, this.textInputAction});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late FocusNode _focusNode;
  bool isLoading = false;
  List<SearchFieldDataModel>? items;
  SearchFieldDataModel? currentValue;

  final OverlayPortalController _overlayPortalController = OverlayPortalController();
  final _controller = TextEditingController();
  final _globalKey = GlobalKey();


  @override
  void initState() {
    _focusNode = FocusNode();
    if(widget.initialValue != null){
      setCurrentValue(widget.initialValue!);
    }
    super.initState();
    _focusNode.addListener(() {
      if(_focusNode.hasFocus){
        _overlayPortalController.show();
      }else {
        _overlayPortalController.hide();
      }
    });
    items = widget.filterItems;
  }

  void setCurrentValue(SearchFieldDataModel value){
    currentValue = value;
    _controller.text = value.value!;
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
          height: 250,
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 15, offset: Offset(2, 3))]),
          child: isLoading ? const CircularProgressIndicator():  ListView.builder(
              itemCount: items != null ? items!.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return TouchRippleEffect(
                  rippleColor: widget.rippleColor ?? Colors.grey,
                  onTap: (){
                    _focusNode.unfocus();
                    setCurrentValue(items![index]);
                    if(widget.onSelected != null){
                      widget.onSelected!(index == 0 ? true: false, index, items![index]);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
                    child: Text(items![index].value!, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                );
              }),
        ),
      ),
      controller: _overlayPortalController,
      child: TextField(
        key: _globalKey,
        controller: _controller,
        style: const TextStyle(color: Colors.black,fontSize: 18, fontWeight: FontWeight.w400),
        focusNode: _focusNode,
        textInputAction: widget.textInputAction ?? TextInputAction.go,
        keyboardType: TextInputType.text,
        maxLines: 1,
        onEditingComplete: (){
          // on keyboard go button press we are treating this request as a initial / primary item selected in the list
          setCurrentValue(SearchFieldDataModel(key: Utils.buildKey(_controller.value.text), value: _controller.value.text));
          // triggering onSelected function
          if(widget.onSelected != null){
            widget.onSelected!(true, 0, currentValue!);
          }
          // removing focus from search field
          _focusNode.unfocus();
        },
        onChanged: (String value) async{
          // enabling loader
          setState(() {
            isLoading = true;
          });

          if(widget.query != null){
            // if user wants to add custom filter on query item then this statement is going to trigger
            items = widget.query!(widget.filterItems, value);
          }else if(widget.fetch != null) {
            // if user wants to add server / network query filter then this statement is going to trigger
            final res = await widget.fetch!(value);
            if(res!.isNotEmpty){
              // if there is an item in the response then trigger this
              items = [SearchFieldDataModel(key: Utils.buildKey(value), value: value), ...res];
            }else {
              // if there is no items in the response then add on default item
              items = [SearchFieldDataModel(key: Utils.buildKey(value), value: value)];
            }
          }else {
            // if none of the function has defined then it's going to trigger as a default query filter function
            if(value.isNotEmpty){
              String pattern = r"\b" + value + r"\b";
              RegExp wordRegex = RegExp(pattern, caseSensitive: false);
              final lists = widget.filterItems?.where((element) => element.value!.contains(widget.fullTextSearch ? wordRegex: value)).toList();
              items = [SearchFieldDataModel(key: Utils.buildKey(value), value: value), ...?lists];
            }else {
              // if query string is empty then add default filter list in the request
              items = widget.filterItems;
            }
          }
          // disabling loader
          setState(() {
            isLoading = false;
          });
        },
        onTap: (){
          // this function is going to trigger on select search field
          _focusNode.requestFocus();
        },
        decoration: widget.inputDecoration ?? InputDecoration(
          border: widget.inputBorder ??  OutlineInputBorder(borderSide: BorderSide(color: widget.borderColor ?? Colors.black87, width: 1.0, style: BorderStyle.solid)),
          hintText: widget.hint ?? "please type your query",
          hintStyle: widget.hintTextStyle ?? const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        textDirection: widget.textDirection ?? TextDirection.ltr,
      ),
    );
  }
}

