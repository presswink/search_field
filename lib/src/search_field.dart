import 'package:flutter/material.dart';
import 'package:search_field/src/search_field_data_model.dart';

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
  final List<SearchFieldDataModel>? items;
  final Color? borderColor;
  const SearchField({super.key, this.inputDecoration, this.hint, this.inputBorder, this.hintTextStyle, this.textDirection, this.initialValue, this.items, this.borderColor});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late FocusNode _focusNode;
  final OverlayPortalController _overlayPortalController = OverlayPortalController();

  final _controller = TextEditingController();
  final _globalKey = GlobalKey();
  @override
  void initState() {
    _focusNode = FocusNode();
    if(widget.initialValue != null){
      _controller.text = widget.initialValue!.value!;
    }
    super.initState();
    _focusNode.addListener(() {
      if(_focusNode.hasFocus){
        _overlayPortalController.show();
      }else {
        _overlayPortalController.hide();
      }
    });
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
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(2, 3))]),
          child: ListView.builder(
              itemCount: widget.items != null ? widget.items!.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
                  child: Text(widget.items![index].value!, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),),
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
        keyboardType: TextInputType.text,
        maxLines: 1,
        onChanged: (String value) {

        },
        onTap: (){
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

