import 'package:json_annotation/json_annotation.dart';

part 'app_address.g.dart';

@JsonSerializable(explicitToJson: true)
class AppAddress {
  String officeName;
  String streetAddress;
  String city;
  String state;
  int zip;

  AppAddress(
      {required this.officeName,
      required this.streetAddress,
      required this.city,
      required this.state,
      required this.zip});

  factory AppAddress.fromJson(Map<String, dynamic> json) =>
      _$AppAddressFromJson(json);

  Map<String, dynamic> toJson() => _$AppAddressToJson(this);

  AppAddress copyWith({
    String? officeName,
    String? streetAddress,
    String? city,
    String? state,
    int? zip,
  }) =>
      AppAddress(
          officeName: officeName ?? this.officeName,
          streetAddress: streetAddress ?? this.streetAddress,
          city: city ?? this.city,
          state: state ?? this.state,
          zip: zip ?? this.zip);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAddress &&
          runtimeType == other.runtimeType &&
          officeName == other.officeName &&
          streetAddress == other.streetAddress &&
          city == other.city &&
          state == other.state &&
          zip == other.zip;

  @override
  int get hashCode =>
      officeName.hashCode ^
      streetAddress.hashCode ^
      city.hashCode ^
      state.hashCode ^
      zip.hashCode;
}
