const _delay = Duration(milliseconds: 300);
Future<void> wait() => Future.delayed(_delay);

class NewCarRepository {
  Future<List<String>> fetchBrands() async {
    await wait();
    return ['Chevy', 'Toyota', 'Honda'];
  }

  Future<List<String>> fetchModels({String? brand}) async {
    await wait();
    const models = {
      'Chevy': ['Malibu', 'Impala'],
      'Toyota': ['Corolla', 'Supra'],
      'Honda': ['Civic', 'Accord'],
    };

    return models[brand] ?? [];
  }

  Future<List<String>> fetchYears({String? brand, String? model}) async {
    await wait();

    const years = {
      'Chevy': {
        'Malibu': ['2019', '2018'],
        'Impala': ['2017', '2016'],
      },
      'Toyota': {
        'Corolla': ['2015', '2014'],
        'Supra': ['2013', '2012'],
      },
      'Honda': {
        'Civic': ['2011', '2010'],
        'Accord': ['2009', '2008'],
      },
    };

    return years[brand]?[model] ?? [];
  }
}
