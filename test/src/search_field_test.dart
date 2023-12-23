import 'package:flutter_test/flutter_test.dart';
import 'package:search_field/search_field.dart';
import '../my_widget_tester.dart';

void main(){
  testWidgets("should have search Field", (widgetTester) async{
    await widgetTester.pumpWidget(const MyWidgetTester(widget: SearchField(hint: "hello",)));
    final textFinder = find.text("hello");
    expect(textFinder, findsOneWidget);
  });
}


