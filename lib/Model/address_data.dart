// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/widgets.dart';

class AddressData {
  final String? addressType;
  final String? address1;
  final String? address2;
  final String? address3;
  final String? state;
  final String? cityDistrict;
  final String? area;
  final String? pincode;
  AddressData({
    this.addressType,
    this.address1,
    this.address2,
    this.address3,
    this.state,
    this.cityDistrict,
    this.area,
    this.pincode,
  });

  AddressData copyWith({
    ValueGetter<String?>? addressType,
    ValueGetter<String?>? address1,
    ValueGetter<String?>? address2,
    ValueGetter<String?>? address3,
    ValueGetter<String?>? state,
    ValueGetter<String?>? cityDistrict,
    ValueGetter<String?>? area,
    ValueGetter<String?>? pincode,
  }) {
    return AddressData(
      addressType: addressType != null ? addressType() : this.addressType,
      address1: address1 != null ? address1() : this.address1,
      address2: address2 != null ? address2() : this.address2,
      address3: address3 != null ? address3() : this.address3,
      state: state != null ? state() : this.state,
      cityDistrict: cityDistrict != null ? cityDistrict() : this.cityDistrict,
      area: area != null ? area() : this.area,
      pincode: pincode != null ? pincode() : this.pincode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addressType': addressType,
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'state': state,
      'cityDistrict': cityDistrict,
      'area': area,
      'pincode': pincode,
    };
  }

  factory AddressData.fromMap(Map<String, dynamic> map) {
    return AddressData(
      addressType: map['addressType'],
      address1: map['address1'],
      address2: map['address2'],
      address3: map['address3'],
      state: map['state'],
      cityDistrict: map['cityDistrict'],
      area: map['area'],
      pincode: map['pincode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressData.fromJson(String source) =>
      AddressData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressData(addressType: $addressType, address1: $address1, address2: $address2, address3: $address3, state: $state, cityDistrict: $cityDistrict, area: $area, pincode: $pincode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressData &&
        other.addressType == addressType &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.address3 == address3 &&
        other.state == state &&
        other.cityDistrict == cityDistrict &&
        other.area == area &&
        other.pincode == pincode;
  }

  @override
  int get hashCode {
    return addressType.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        address3.hashCode ^
        state.hashCode ^
        cityDistrict.hashCode ^
        area.hashCode ^
        pincode.hashCode;
  }
}
