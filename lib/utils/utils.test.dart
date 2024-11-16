import 'package:mindfulness_app/utils/utils.dart';
import 'package:test/test.dart';

test_calculateLightness() {
  test("it returns 0.4 for matching max values", () {
    expect(calculateLightness(10, 7, 10), 0.4);
    expect(calculateLightness(-10, 7, 10), 0.4);
  });
  test("it returns 0.6 for matching min values", () {
    expect(calculateLightness(7, 7, 10), 0.6);
    expect(calculateLightness(3, 3, 7), 0.6);
    expect(calculateLightness(0, 0, 3), 0.6);
    expect(calculateLightness(-7, 7, 10), 0.6);
    expect(calculateLightness(-3, 3, 7), 0.6);
  });
  test("it returns values between 0.4 and 0.6 for other values", () {
    final higher1 = calculateLightness(8, 7, 10);
    final smaller1 = calculateLightness(9, 7, 10);
    expect(higher1, greaterThan(0.4));
    expect(higher1, lessThan(0.6));
    expect(smaller1, greaterThan(0.4));
    expect(smaller1, lessThan(0.6));
    expect(higher1, greaterThan(smaller1));

    final higher2 = calculateLightness(4, 3, 7);
    final smaller2 = calculateLightness(6, 3, 7);
    expect(higher2, greaterThan(0.4));
    expect(higher2, lessThan(0.6));
    expect(smaller2, greaterThan(0.4));
    expect(smaller2, lessThan(0.6));
    expect(higher2, greaterThan(smaller2));

    final higher3 = calculateLightness(1, 0, 3);
    final smaller3 = calculateLightness(2, 0, 3);
    expect(higher3, greaterThan(0.4));
    expect(higher3, lessThan(0.6));
    expect(smaller3, greaterThan(0.4));
    expect(smaller3, lessThan(0.6));
    expect(higher3, greaterThan(smaller3));

    final higher4 = calculateLightness(-8, 7, 10);
    final smaller4 = calculateLightness(-9, 7, 10);
    expect(higher4, greaterThan(0.4));
    expect(higher4, lessThan(0.6));
    expect(smaller4, greaterThan(0.4));
    expect(smaller4, lessThan(0.6));
    expect(higher4, greaterThan(smaller4));

    final higher5 = calculateLightness(-4, 3, 7);
    final smaller5 = calculateLightness(-6, 3, 7);
    expect(higher5, greaterThan(0.4));
    expect(higher5, lessThan(0.6));
    expect(smaller5, greaterThan(0.4));
    expect(smaller5, lessThan(0.6));
    expect(higher5, greaterThan(smaller5));
  });
}
