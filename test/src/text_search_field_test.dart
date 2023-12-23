import 'package:flutter_test/flutter_test.dart';
import 'package:text_search_field/text_search_field.dart';
import '../my_widget_tester.dart';

void main(){
  testWidgets("should have search Field", (widgetTester) async{
    await widgetTester.pumpWidget(const MyWidgetTester(widget: TextSearchField(hint: "hello",)));
    final textFinder = find.text("hello");
    expect(textFinder, findsOneWidget);
  });
}


