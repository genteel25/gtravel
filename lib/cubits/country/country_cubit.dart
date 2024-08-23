import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/calendar.dart';

part 'country_cubit.freezed.dart';
part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit() : super(const CountryState.initial());

  final List<CountryData> _countries = [
    CountryData(color: ColorEnum.orange, name: "Prague"),
    CountryData(color: ColorEnum.blue, name: "Paris"),
    CountryData(color: ColorEnum.pink, name: "London"),
    CountryData(color: ColorEnum.purple, name: "California"),
  ];

  List<CountryData> get countriesList => _countries;

  CountryData? _selectedCountryData;
  CountryData get selectedCountryData =>
      _selectedCountryData ?? countriesList.first;

  selectCountryHandler({CountryData? country}) {
    _selectedCountryData = country;
    emit(CountryState.selectedSuccess(
        selectedCountry: country ?? _countries.first));
  }

  autoSelectCountryHandler() {
    int currentIndex =
        _countries.indexWhere((item) => item.name == selectedCountryData.name) +
            1;
    if (currentIndex < _countries.length) {
      emit(CountryState.selectedSuccess(
          selectedCountry: _countries[currentIndex]));
      _selectedCountryData = _countries[currentIndex];
    }
  }
}
