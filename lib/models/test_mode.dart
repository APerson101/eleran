import 'dart:convert';

import 'package:flutter/foundation.dart';

enum PersonTitle { mr, mrs, miss, others }

enum Gender { male, female, nonbinary, nonconforming, transmale, transfemale }

enum States { adamawa, lagos, kano, others }

enum AdamawaLGA { jimeta, yola, savannah }

enum LagosLGA { lekki, ajah, ikeja }

enum KanoLGA { wudil, garko, bichi }

enum MaritalStatus {
  divorced,
  single,
  coding,
  widowed,
  others,
  married,
  complicated,
  separated
}

class Person {
  String firstname;
  String lastname;
  String? address;
  DateTime? dateOfBirth;
  String phoneNumber;
  String email;
  List<BankInfo> bankInfo;
  PersonTitle title;
  Gender gender;
  String nationality;
  MaritalStatus maritalStatus;
  int id;
  String state;
  String lga;
  Person({
    required this.firstname,
    required this.lastname,
    this.address,
    this.dateOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.bankInfo,
    required this.gender,
    required this.nationality,
    required this.maritalStatus,
    required this.id,
    required this.title,
    required this.state,
    required this.lga,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'phoneNumber': phoneNumber,
      'email': email,
      'bankInfo': bankInfo.map((x) => x.toMap()).toList(),
      'gender': describeEnum(gender),
      'nationality': nationality,
      'maritalStatus': describeEnum(maritalStatus),
      'id': id,
      'state': state,
      'lga': lga,
      'title': describeEnum(title)
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      address: map['address'],
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'])
          : null,
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      title: PersonTitle.values
          .firstWhere((element) => describeEnum(element) == map['title']),
      bankInfo:
          List<BankInfo>.from(map['bankInfo']?.map((x) => BankInfo.fromMap(x))),
      gender: Gender.values
          .firstWhere((element) => describeEnum(element) == map['gender']),
      nationality: map['nationality'] ?? '',
      maritalStatus: MaritalStatus.values.firstWhere(
          (element) => describeEnum(element) == map['maritalStatus']),
      id: map['id']?.toInt() ?? 0,
      state: map['state'] ?? '',
      lga: map['lga'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Person.fromJson(String source) => Person.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Person(firstname: $firstname, lastname: $lastname, address: $address, dateOfBirth: $dateOfBirth, phoneNumber: $phoneNumber, email: $email, bankInfo: $bankInfo, gender: $gender, nationality: $nationality, maritalStatus: $maritalStatus, id: $id, state: $state, lga: $lga)';
  }
}

class BankInfo {
  int id;
  String accountName;
  String accountNumber;
  String bankName;
  String? accountBalance;
  List<BankInfo>? benefitiaries;
  BankInfo({
    required this.id,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    this.accountBalance,
    this.benefitiaries,
  });

  BankInfo copyWith({
    int? id,
    String? accountName,
    String? accountNumber,
    String? bankName,
    String? accountBalance,
    List<BankInfo>? benefitiaries,
  }) {
    return BankInfo(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      accountBalance: accountBalance ?? this.accountBalance,
      benefitiaries: benefitiaries ?? this.benefitiaries,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'accountBalance': accountBalance,
      'benefitiaries': benefitiaries?.map((x) => x.toMap()).toList(),
    };
  }

  factory BankInfo.fromMap(Map<String, dynamic> map) {
    return BankInfo(
      id: map['id']?.toInt() ?? 0,
      accountName: map['accountName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      bankName: map['bankName'] ?? '',
      accountBalance: map['accountBalance'],
      benefitiaries: map['benefitiaries'] != null
          ? List<BankInfo>.from(
              map['benefitiaries']?.map((x) => BankInfo.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BankInfo.fromJson(String source) =>
      BankInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BankInfo(id: $id, accountName: $accountName, accountNumber: $accountNumber, bankName: $bankName, accountBalance: $accountBalance, benefitiaries: $benefitiaries)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BankInfo &&
        other.id == id &&
        other.accountName == accountName &&
        other.accountNumber == accountNumber &&
        other.bankName == bankName &&
        other.accountBalance == accountBalance &&
        listEquals(other.benefitiaries, benefitiaries);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        accountName.hashCode ^
        accountNumber.hashCode ^
        bankName.hashCode ^
        accountBalance.hashCode ^
        benefitiaries.hashCode;
  }
}
