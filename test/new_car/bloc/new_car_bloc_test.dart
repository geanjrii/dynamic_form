import 'package:bloc_test/bloc_test.dart';
import 'package:dynamic_form/domain_layer/new_car_repository.dart';
import 'package:dynamic_form/feature_layer/new_car/bloc/new_car_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNewCarRepository extends Mock implements NewCarRepository {}

void main() {
  const mockBrands = ['Chevy', 'Toyota', 'Honda'];
  const mockBrand = 'Chevy';
  const mockModels = ['Malibu', 'Impala'];
  const mockModel = 'Malibu';
  const mockYears = ['2008', '2020'];
  const mockYear = '2008';

  group('NewCarBloc', () {
    late NewCarRepository newCarRepository;

    setUp(() {
      newCarRepository = MockNewCarRepository();
    });


    buildBloc() => NewCarBloc(newCarRepository: newCarRepository);

    test('initial state is NewCarState.initial', () {
      expect(buildBloc().state, const NewCarState.initial());
    });

    group('onNewCarFormLoaded', () {
      blocTest<NewCarBloc, NewCarState>(
        'emits brands loading in progress and brands load success',
        setUp: () {
          when(newCarRepository.fetchBrands)
              .thenAnswer((_) async => mockBrands);
        },
        build: () => buildBloc(),
        act: (bloc) => bloc.add(const NewCarFormLoaded()),
        expect: () => [
          const NewCarState.brandsLoadInProgress(),
          const NewCarState.brandsLoadSuccess(brands: mockBrands),
        ],
        verify: (_) => verify(newCarRepository.fetchBrands).called(1),
      );
    });
    group('onNewCarBrandChanged', () {
      blocTest<NewCarBloc, NewCarState>(
        'emits models loading in progress and models load success',
        setUp: () {
          when(
            () => newCarRepository.fetchModels(brand: mockBrand),
          ).thenAnswer((_) async => mockModels);
        },
        build: () => buildBloc(),
        act: (bloc) => bloc.add(const NewCarBrandChanged(brand: mockBrand)),
        expect: () => [
          const NewCarState.modelsLoadInProgress(brands: [], brand: mockBrand),
          const NewCarState.modelsLoadSuccess(
            brands: [],
            brand: mockBrand,
            models: mockModels,
          ),
        ],
        verify: (_) {
          verify(() => newCarRepository.fetchModels(brand: mockBrand))
              .called(1);
        },
      );
    });

    group('onNewCarModelChanged', () {
      blocTest<NewCarBloc, NewCarState>(
        'emits years loading in progress and year load success',
        setUp: () {
          when(
            () => newCarRepository.fetchYears(model: mockModel),
          ).thenAnswer((_) async => mockYears);
        },
        build: () => buildBloc(),
        act: (bloc) => bloc.add(const NewCarModelChanged(model: mockModel)),
        expect: () => [
          const NewCarState.yearsLoadInProgress(
            brands: [],
            brand: null,
            models: [],
            model: mockModel,
          ),
          const NewCarState.yearsLoadSuccess(
            brands: [],
            brand: null,
            models: [],
            model: mockModel,
            years: mockYears,
          ),
        ],
        verify: (_) {
          verify(
            () => newCarRepository.fetchYears(model: mockModel),
          ).called(1);
        },
      );
    });

    group('onNewCarYearChanged', () {
      blocTest<NewCarBloc, NewCarState>(
        'changes year when NewCarYearChanged is added',
        build: () => buildBloc(),
        act: (bloc) => bloc.add(const NewCarYearChanged(year: mockYear)),
        expect: () => [const NewCarState.initial().copyWith(year: mockYear)],
      );
    });

    blocTest<NewCarBloc, NewCarState>(
      'emits correct states when complete flow is executed',
      setUp: () {
        when(
          newCarRepository.fetchBrands,
        ).thenAnswer((_) => Future.value(mockBrands));
        when(
          () => newCarRepository.fetchModels(brand: mockBrand),
        ).thenAnswer((_) => Future.value(mockModels));
        when(
          () => newCarRepository.fetchYears(brand: mockBrand, model: mockModel),
        ).thenAnswer((_) => Future.value(mockYears));
      },
      build: () => buildBloc(),
      act: (bloc) => bloc
        ..add(const NewCarFormLoaded())
        ..add(const NewCarBrandChanged(brand: mockBrand))
        ..add(const NewCarModelChanged(model: mockModel))
        ..add(const NewCarYearChanged(year: mockYear)),
      expect: () => [
        const NewCarState.brandsLoadInProgress(),
        const NewCarState.brandsLoadSuccess(brands: mockBrands),
        const NewCarState.modelsLoadInProgress(
            brands: mockBrands, brand: mockBrand),
        const NewCarState.modelsLoadSuccess(
          brands: mockBrands,
          brand: mockBrand,
          models: mockModels,
        ),
        const NewCarState.yearsLoadInProgress(
          brands: mockBrands,
          brand: mockBrand,
          models: mockModels,
          model: mockModel,
        ),
        const NewCarState.yearsLoadSuccess(
          brands: mockBrands,
          brand: mockBrand,
          models: mockModels,
          model: mockModel,
          years: mockYears,
        ),
        const NewCarState.yearsLoadSuccess(
          brands: mockBrands,
          brand: mockBrand,
          models: mockModels,
          model: mockModel,
          years: mockYears,
        ).copyWith(year: mockYear),
      ],
      verify: (_) => verifyInOrder([
        newCarRepository.fetchBrands,
        () => newCarRepository.fetchModels(brand: mockBrand),
        () => newCarRepository.fetchYears(brand: mockBrand, model: mockModel),
      ]),
    );
  });
}
