import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class RequestBloodData {
  int? id;
  String? ptfirstName;
  String? ptlastName;
  String? bloodGroup;
  String? bloodType;
  String? bloodAmount;
  double? lat;
  double? long;
  String? address;
  DateTime? requiredDate;
  TimeOfDay? needTime;
  String? contactNumber;
  String? needFor;
  String? description;
  String? priority;
  String? createdAt;

  RequestBloodData({
    this.address,
    this.contactNumber,
    this.createdAt,
    this.ptfirstName,
    this.id,
    this.ptlastName,
    this.description,
    this.bloodType,
    this.requiredDate,
    this.needTime,
    this.lat,
    this.bloodAmount,
    this.long,
    this.priority,
    this.bloodGroup,
  });

  factory RequestBloodData.fromJson(Map<String, dynamic> json) {
    return RequestBloodData(
        address: json['address'],
        contactNumber: json['contact_number'],
        createdAt: json['created_at'],
        ptfirstName: json['first_name'],
        id: json['id'].toString().toInt(),
        ptlastName: json['last_name'],
        bloodAmount: json['provider_id'],
        priority: json['user_type'],
        description: json['description'],
        bloodType: json['known_languages'],
        needTime: json['needTime'],
        lat: json['city_name'],
        bloodGroup: json['bloodGroup'],
        requiredDate: json['requiredDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) data['address'] = this.address;
    if (this.contactNumber != null) data['contact_number'] = this.contactNumber;
    if (this.createdAt != null) data['created_at'] = this.createdAt;
    if (this.ptfirstName != null) data['first_name'] = this.ptfirstName;
    if (this.id != null) data['id'] = this.id;
    if (this.ptlastName != null) data['last_name'] = this.ptlastName;
    if (this.bloodAmount != null) data['provider_id'] = this.bloodAmount;
    if (this.long != null) data['providertype_id'] = this.long;
    if (this.priority != null) data['user_type'] = this.priority;
    if (this.needFor != null) data['needFor'] = this.needFor;
    if (this.description != null) data['description'] = this.description;
    if (this.bloodType != null) data['known_languages'] = this.bloodType;
    if (this.needTime != null) data['needTime'] = this.needTime;
    if (this.lat != null) data['city_name'] = this.lat;
    if (this.bloodGroup != null) data['bloodGroup'] = this.bloodGroup;
    if (this.requiredDate != null) data['requiredDate'] = this.requiredDate;

    return data;
  }

  Map<String, dynamic> toFirebaseJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) data['address'] = this.address;
    if (this.contactNumber != null) data['contact_number'] = this.contactNumber;
    if (this.createdAt != null) data['created_at'] = this.createdAt;
    if (this.ptfirstName != null) data['first_name'] = this.ptfirstName;
    if (this.id != null) data['id'] = this.id;
    if (this.ptlastName != null) data['last_name'] = this.ptlastName;
    if (this.bloodAmount != null) data['provider_id'] = this.bloodAmount;
    if (this.long != null) data['providertype_id'] = this.long;
    if (this.priority != null) data['user_type'] = this.priority;
    if (this.needFor != null) data['needFor'] = this.needFor;
    if (this.description != null) data['description'] = this.description;
    if (this.bloodType != null) data['known_languages'] = this.bloodType;
    if (this.needTime != null) data['needTime'] = this.needTime;
    if (this.lat != null) data['city_name'] = this.lat;
    if (this.bloodGroup != null) data['bloodGroup'] = this.bloodGroup;
    if (this.requiredDate != null) data['requiredDate'] = this.requiredDate;
    return data;
  }
}
