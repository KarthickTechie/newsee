// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Dedupe {
  final bool? existingCustomer;
  final String? cifNumber;
  final String? constitution;
  Dedupe({
    required this.existingCustomer,
    required this.cifNumber,
    required this.constitution,
  });

  Dedupe copyWith({
    bool? existingCustomer,
    String? cifNumber,
    String? constitution,
  }) {
    return Dedupe(
      existingCustomer: existingCustomer ?? this.existingCustomer,
      cifNumber: cifNumber ?? this.cifNumber,
      constitution: constitution ?? this.constitution,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'existingCustomer': existingCustomer,
      'cifNumber': cifNumber,
      'constitution': constitution,
    };
  }

  factory Dedupe.fromMap(Map<String, dynamic> map) {
    return Dedupe(
      existingCustomer: map['existingCustomer'] as bool,
      cifNumber: map['cifNumber'] as String,
      constitution: map['constitution'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dedupe.fromJson(String source) =>
      Dedupe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Dedupe(existingCustomer: $existingCustomer, cifNumber: $cifNumber, constitution: $constitution)';

  @override
  bool operator ==(covariant Dedupe other) {
    if (identical(this, other)) return true;

    return other.existingCustomer == existingCustomer &&
        other.cifNumber == cifNumber &&
        other.constitution == constitution;
  }

  @override
  int get hashCode =>
      existingCustomer.hashCode ^ cifNumber.hashCode ^ constitution.hashCode;
}
