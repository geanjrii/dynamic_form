import 'package:dynamic_form/domain_layer/new_car_repository.dart';
import 'package:dynamic_form/feature_layer/new_car/bloc/new_car_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewCarPage extends StatelessWidget {
  const NewCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => NewCarBloc(
          newCarRepository: context.read<NewCarRepository>(),
        )..add(const NewCarFormLoaded()),
        child: const NewCarForm(),
      ),
    );
  }
}

class NewCarForm extends StatelessWidget {
  const NewCarForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment(0, -3 / 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BrandDropdownButton(),
            ModelDropdownButton(),
            YearDropdownButton(),
            FormSubmitButton(),
          ],
        ),
      ),
    );
  }
}

class BrandDropdownButton extends StatelessWidget {
  const BrandDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    final brands = context.select((NewCarBloc bloc) => bloc.state.brands);
    final brand = context.select((NewCarBloc bloc) => bloc.state.brand);
    return Material(
      child: DropdownButton<String>(
        key: const Key('newCarForm_brand_dropdownButton'),
        items: brands.isNotEmpty
            ? brands.map((brand) {
                return DropdownMenuItem(value: brand, child: Text(brand));
              }).toList()
            : const [],
        value: brand,
        hint: const Text('Select a Brand'),
        onChanged: (brand) {
          context.read<NewCarBloc>().add(NewCarBrandChanged(brand: brand));
        },
      ),
    );
  }
}

class ModelDropdownButton extends StatelessWidget {
  const ModelDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    final models = context.select((NewCarBloc bloc) => bloc.state.models);
    final model = context.select((NewCarBloc bloc) => bloc.state.model);
    return Material(
      child: DropdownButton<String>(
        key: const Key('newCarForm_model_dropdownButton'),
        items: models.isNotEmpty
            ? models.map((model) {
                return DropdownMenuItem(value: model, child: Text(model));
              }).toList()
            : const [],
        value: model,
        hint: const Text('Select a Model'),
        onChanged: (model) {
          context.read<NewCarBloc>().add(NewCarModelChanged(model: model));
        },
      ),
    );
  }
}

class YearDropdownButton extends StatelessWidget {
  const YearDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    final years = context.select((NewCarBloc bloc) => bloc.state.years);
    final year = context.select((NewCarBloc bloc) => bloc.state.year);
    return Material(
      child: DropdownButton<String>(
        key: const Key('newCarForm_year_dropdownButton'),
        items: years.isNotEmpty
            ? years.map((year) {
                return DropdownMenuItem(value: year, child: Text(year));
              }).toList()
            : const [],
        value: year,
        hint: const Text('Select a Year'),
        onChanged: (year) {
          context.read<NewCarBloc>().add(NewCarYearChanged(year: year));
        },
      ),
    );
  }
}

class FormSubmitButton extends StatelessWidget {
  const FormSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NewCarBloc>().state;

    void onFormSubmitted() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content:
                Text('Submitted ${state.brand} ${state.model} ${state.year}'),
          ),
        );
    }

    return ElevatedButton(
      onPressed: state.isComplete ? onFormSubmitted : null,
      child: const Text('Submit'),
    );
  }
}
