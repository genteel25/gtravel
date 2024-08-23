part of 'country_cubit.dart';

@freezed
class CountryState with _$CountryState {
  const factory CountryState.initial() = _Initial;
  const factory CountryState.loading() = _Loading;
  const factory CountryState.success({required List<CountryData> countries}) =
      _Success;
  const factory CountryState.selectedSuccess(
      {required CountryData selectedCountry}) = _SelectedSuccess;
}
