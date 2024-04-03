// ignore_for_file: prefer_const_constructors
import 'package:dynamic_form/feature_layer/new_car/bloc/new_car_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewCarEvent', () {
    group('NewCarFormLoaded', () {
      test('supports value comparison', () {
        expect(NewCarFormLoaded(), NewCarFormLoaded());
      });
    });

    group('NewCarBrandChanged', () {
      const mockCarBrand = 'Chevy';
      test('supports value comparison', () {
        expect(NewCarBrandChanged(), NewCarBrandChanged());
        expect(
          NewCarBrandChanged(brand: mockCarBrand),
          NewCarBrandChanged(brand: mockCarBrand),
        );
      });
    });

    group('NewCarModelChanged', () {
      const mockCarModel = 'Malibu';
      test('supports value comparison', () {
        expect(NewCarModelChanged(), NewCarModelChanged());
        expect(
          NewCarModelChanged(model: mockCarModel),
          NewCarModelChanged(model: mockCarModel),
        );
      });
    });

    group('NewCarYearChanged', () {
      const mockYear = '2021';
      test('supports value comparison', () {
        expect(NewCarYearChanged(), NewCarYearChanged());
        expect(
          NewCarYearChanged(year: mockYear),
          NewCarYearChanged(year: mockYear),
        );
      });
    });
  });
}
