import 'package:dynamic_form/domain_layer/domain_layer.dart';
import 'package:dynamic_form/feature_layer/new_car/view/new_car_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (_) => NewCarRepository(),
        child: const MaterialApp(home: NewCarPage()));
  }
}
