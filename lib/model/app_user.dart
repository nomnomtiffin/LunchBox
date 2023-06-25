import 'dart:core';

import 'package:lunch_box/model/app_address.dart';

class AppUser {
  bool isSigned;
  bool isLoading;
  String uId;
  String phoneNumber;
  String name;
  AppAddress address;
  String preferredCombo;

  AppUser({
    required this.isSigned,
    required this.isLoading,
    required this.uId,
    required this.phoneNumber,
    required this.name,
    required this.address,
    required this.preferredCombo,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
        isSigned: map['isSigned'] ?? true,
        isLoading: map['isLoading'] ?? false,
        uId: map['uId'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        name: map['name'] ?? '',
        address: AppAddress.fromJson(map['address'] as Map<String, dynamic>),
        preferredCombo: map['preferredCombo'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      "uId": uId,
      "phoneNumber": phoneNumber,
      "name": name,
      "address": address.toJson(),
      "preferredCombo": preferredCombo,
    };
  }

  AppUser copyWith({
    bool? isSigned,
    bool? isLoading,
    String? uId,
    String? phoneNumber,
    String? name,
    AppAddress? address,
    String? preferredCombo,
  }) =>
      AppUser(
          isSigned: isSigned ?? this.isSigned,
          isLoading: isLoading ?? this.isLoading,
          uId: uId ?? this.uId,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          name: name ?? this.name,
          address: address ?? this.address,
          preferredCombo: preferredCombo ?? this.preferredCombo);
}
