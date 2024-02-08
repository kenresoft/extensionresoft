import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:extensionresoft/extensionresoft.dart';

void main() {
  group('SpaceExtension', () {
    test('spaceX should return a SizedBox with specified width', () {
      final spacerX = 16.spaceX();
      expect(spacerX.width, equals(16.0));
    });

    test('spaceY should return a SizedBox with specified height', () {
      final spacerY = 24.spaceY();
      expect(spacerY.height, equals(24.0));
    });

    test('spaceXY should return a SizedBox with specified width and height', () {
      final spacerXY = 32.spaceXY();
      expect(spacerXY.width, equals(32.0));
      expect(spacerXY.height, equals(32.0));
    });

    test('spX getter should return a SizedBox with specified width', () {
      final spacerXGetter = 20.spX;
      expect(spacerXGetter.width, equals(20.0));
    });

    test('spY getter should return a SizedBox with specified height', () {
      final spacerYGetter = 30.spY;
      expect(spacerYGetter.height, equals(30.0));
    });

    test('spXY getter should return a SizedBox with specified width and height', () {
      final spacerXYGetter = 40.spXY;
      expect(spacerXYGetter.width, equals(40.0));
      expect(spacerXYGetter.height, equals(40.0));
    });
  });

  group('CustomCardExtension', () {
    test('radius should return a Card widget with specified properties', () {
      final Card roundedCard = 16.radius(
        child: const Text('Test'),
        elevation: 4,
        color: Colors.blue,
        strokeColor: Colors.black,
        shadowColor: Colors.grey,
      ) as Card;

      expect(roundedCard.elevation, equals(4));
      expect(roundedCard.color, equals(Colors.blue));
      expect(roundedCard.shadowColor, equals(Colors.grey));
    });
  });

  group('PathExtension', () {
    test('p function should apply function to number and return result', () {
      final result = 16.p((n) => n * 2);
      expect(result, equals(32.0));
    });
  });

  group('TextExtension', () {
    test('edit function should return a Text widget with specified properties', () {
      final textWidget = 'Hello'.edit(textStyle: const TextStyle(fontSize: 20), textAlign: TextAlign.center);
      expect(textWidget.data, equals('Hello'));
      expect(textWidget.style!.fontSize, equals(20));
      expect(textWidget.textAlign, equals(TextAlign.center));
    });
  });

  group('CustomImageExtension', () {
    test('img function should return an Image widget with specified properties', () {
      final imageWidget = 'assets/image.png'.img(width: 100, height: 100, fit: BoxFit.cover);
      expect(imageWidget.width, equals(100.0));
      expect(imageWidget.height, equals(100.0));
    });
  });

  group('Conditional Function', () {
    test('condition function should return correct value based on condition', () {
      final result = condition(true, 'True Value', 'False Value');
      expect(result, equals('True Value'));
    });

    test('conditionFunction should invoke correct function based on condition', () {
      final result = conditionFunction(true, () => 'True Value', () => 'False Value');
      expect(result, equals('True Value'));
    });
  });

  group('Get Function', () {
    test('get function should return correct value based on key and default value', () {
      final result = get('Existing Value', 'Default Value');
      expect(result, equals('Existing Value'));
    });
  });
}
