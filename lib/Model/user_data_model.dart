import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  int? providerId;
  String? status;
  int? totalBooking;

  ///check its use
  String? description;
  String? knownLanguages;
  String? lat;
  String? long;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  String? providerTypeId;
  String? providerType;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;
  String? uid;
  String? socialImage;
  String? loginType;
  int? serviceAddressId;
  num? providersServiceRating;
  num? handymanRating;
  int? isVerifyProvider;
  String? designation;
  String? apiToken;
  String? emailVerifiedAt;
  List<String>? userRole;
  int? isUserExist;
  String? password;
  num? isFavourite;

  String? verificationId;
  String? otpCode;

  bool isSelected = false;
  int? isOnline;
  int? emailVerified;
  String? bloodGroup;
  DateTime? lastdonated;

  ///Local
  bool get isHandyman => userType == USER_TYPE_HANDYMAN;

  bool get isProvider => userType == USER_TYPE_PROVIDER;

  List<String> get knownLanguagesArray => buildKnownLanguages();

  List<String> get longArray => buildlong();

  List<String> buildKnownLanguages() {
    List<String> array = [];
    String tempLanguages = knownLanguages.validate();
    if (tempLanguages.isNotEmpty && tempLanguages.isJson()) {
      Iterable it1 = jsonDecode(knownLanguages.validate());
      array.addAll(it1.map((e) => e.toString()).toList());
    }

    return array;
  }

  List<String> buildlong() {
    List<String> array = [];
    String templong = long.validate();
    if (templong.isNotEmpty && templong.isJson()) {
      Iterable it2 = jsonDecode(long.validate());
      array.addAll(it2.map((e) => e.toString()).toList());
    }

    return array;
  }

  UserData(
      {this.address,
      this.apiToken,
      this.cityId,
      this.contactNumber,
      this.countryId,
      this.createdAt,
      this.displayName,
      this.socialImage,
      this.email,
      this.emailVerifiedAt,
      this.firstName,
      this.id,
      this.isFeatured,
      this.lastName,
      this.description,
      this.knownLanguages,
      this.lat,
      this.long,
      this.providerType,
      this.cityName,
      this.providerId,
      this.providerTypeId,
      this.stateId,
      this.status,
      this.updatedAt,
      this.userRole,
      this.userType,
      this.username,
      this.profileImage,
      this.uid,
      this.handymanRating,
      this.lastNotificationSeen,
      this.loginType,
      this.providersServiceRating,
      this.serviceAddressId,
      this.timeZone,
      this.isOnline,
      this.isVerifyProvider,
      this.isUserExist,
      this.password,
      this.isFavourite,
      this.designation,
      this.verificationId,
      this.otpCode,
      this.totalBooking,
      this.emailVerified,
      this.bloodGroup,
      this.lastdonated});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        address: json['address'],
        apiToken: json['api_token'],
        cityId: json['city_id'],
        contactNumber: json['contact_number'],
        countryId: json['country_id'],
        createdAt: json['created_at'],
        displayName: json['display_name'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'],
        firstName: json['first_name'],
        id: json['id'].toString().toInt(),
        isFeatured: json['is_featured'],
        lastName: json['last_name'],
        socialImage: json['social_image'],
        providerId: json['provider_id'],
        //providertype_id: json['providertype_id'],
        stateId: json['state_id'],
        status: json['status'],
        updatedAt: json['updated_at'],
        userRole: json['user_role'] != null
            ? new List<String>.from(json['user_role'])
            : null,
        userType: json['user_type'],
        username: json['username'],
        isOnline: json['isOnline'],
        profileImage: json['profile_image'],
        uid: json['uid'],
        password: json['password'],
        isFavourite: json['is_favourite'],
        description: json['description'],
        knownLanguages: json['known_languages'],
        lat: json['lat'],
        long: json['long'],
        providerType: json['providertype'],
        cityName: json['city_name'],
        loginType: json['login_type'],
        serviceAddressId: json['service_address_id'],
        lastNotificationSeen: json['last_notification_seen'],
        providersServiceRating: json['providers_service_rating'],
        handymanRating: json['handyman_rating'],
        timeZone: json['time_zone'],
        isVerifyProvider: json['is_verify_provider'],
        isUserExist: json['is_user_exist'],
        verificationId: json['verificationId'],
        designation: json['designation'],
        otpCode: json['otpCode'],
        totalBooking: json['total_services_booked'],
        emailVerified: json['is_email_verified'],
        bloodGroup: json['bloodGroup'],
        lastdonated: json['lastdonated']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) data['address'] = this.address;
    if (this.apiToken != null) data['api_token'] = this.apiToken;
    if (this.cityId != null) data['city_id'] = this.cityId;
    if (this.password != null) data['password'] = this.password;
    if (this.contactNumber != null) data['contact_number'] = this.contactNumber;
    if (this.countryId != null) data['country_id'] = this.countryId;
    if (this.createdAt != null) data['created_at'] = this.createdAt;
    if (this.displayName != null) data['display_name'] = this.displayName;
    if (this.email != null) data['email'] = this.email;
    if (this.emailVerifiedAt != null)
      data['email_verified_at'] = this.emailVerifiedAt;
    if (this.firstName != null) data['first_name'] = this.firstName;
    if (this.id != null) data['id'] = this.id;
    if (this.socialImage != null) data['social_image'] = this.socialImage;
    if (this.isFeatured != null) data['is_featured'] = this.isFeatured;
    if (this.lastName != null) data['last_name'] = this.lastName;
    if (this.providerId != null) data['provider_id'] = this.providerId;
    if (this.providerTypeId != null)
      data['providertype_id'] = this.providerTypeId;
    if (this.stateId != null) data['state_id'] = this.stateId;
    if (this.status != null) data['status'] = this.status;
    if (this.updatedAt != null) data['updated_at'] = this.updatedAt;
    if (this.userType != null) data['user_type'] = this.userType;
    if (this.username != null) data['username'] = this.username;
    if (this.profileImage != null) data['profile_image'] = this.profileImage;
    if (this.uid != null) data['uid'] = this.uid;
    if (this.isOnline != null) data['isOnline'] = this.isOnline;
    if (this.description != null) data['description'] = this.description;
    if (this.knownLanguages != null)
      data['known_languages'] = this.knownLanguages;
    if (this.lat != null) data['lat'] = this.lat;
    if (this.long != null) data['long'] = this.long;
    if (this.providerType != null) data['providertype'] = this.providerType;
    if (this.cityName != null) data['city_name'] = this.cityName;
    if (this.timeZone != null) data['time_zone'] = this.timeZone;
    if (this.loginType != null) data['login_type'] = this.loginType;
    if (this.serviceAddressId != null)
      data['service_address_id'] = this.serviceAddressId;
    if (this.lastNotificationSeen != null)
      data['last_notification_seen'] = this.lastNotificationSeen;
    if (this.providersServiceRating != null)
      data['providers_service_rating'] = this.providersServiceRating;
    if (this.handymanRating != null)
      data['handyman_rating'] = this.handymanRating;
    if (this.isVerifyProvider != null)
      data['is_verify_provider'] = this.isVerifyProvider;
    if (this.isUserExist != null) data['is_user_exist'] = this.isUserExist;
    if (this.designation != null) data['designation'] = this.designation;
    if (this.verificationId != null)
      data['verificationId'] = this.verificationId;
    if (this.otpCode != null) data['otpCode'] = this.otpCode;
    if (this.isFavourite != null) data['is_favourite'] = this.isFavourite;
    if (this.totalBooking != null)
      data['total_services_booked'] = this.totalBooking;
    if (this.emailVerified != null)
      data['is_email_verified'] = this.emailVerified;
    if (this.bloodGroup != null) data['bloodGroup'] = this.bloodGroup;
    if (this.lastdonated != null) data['lastdonated'] = this.lastdonated;

    if (this.userRole != null) {
      data['user_role'] = this.userRole;
    }
    return data;
  }

  factory UserData.fromMap(dynamic json) {
    return UserData(
        address: json['address'],
        apiToken: json['api_token'],
        cityId: json['city_id'],
        contactNumber: json['contact_number'],
        countryId: json['country_id'],
        createdAt: json['created_at'],
        displayName: json['display_name'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'],
        firstName: json['first_name'],
        id: json['id'].toString().toInt(),
        isFeatured: json['is_featured'],
        lastName: json['last_name'],
        socialImage: json['social_image'],
        providerId: json['provider_id'],
        //providertype_id: json['providertype_id'],
        stateId: json['state_id'],
        status: json['status'],
        updatedAt: json['updated_at'],
        userRole: json['user_role'] != null
            ? new List<String>.from(json['user_role'])
            : null,
        userType: json['user_type'],
        username: json['username'],
        isOnline: json['isOnline'],
        profileImage: json['profile_image'],
        uid: json['uid'],
        password: json['password'],
        isFavourite: json['is_favourite'],
        description: json['description'],
        knownLanguages: json['known_languages'],
        lat: json['lat'],
        long: json['long'],
        providerType: json['providertype'],
        cityName: json['city_name'],
        loginType: json['login_type'],
        serviceAddressId: json['service_address_id'],
        lastNotificationSeen: json['last_notification_seen'],
        providersServiceRating: json['providers_service_rating'],
        handymanRating: json['handyman_rating'],
        timeZone: json['time_zone'],
        isVerifyProvider: json['is_verify_provider'],
        isUserExist: json['is_user_exist'],
        verificationId: json['verificationId'],
        designation: json['designation'],
        otpCode: json['otpCode'],
        totalBooking: json['total_services_booked'],
        emailVerified: json['is_email_verified'],
        bloodGroup: json['bloodGroup'],
        lastdonated: json['lastdonated']);
  }

  Map<String, dynamic> toFirebaseJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) data['id'] = this.id;
    if (this.uid != null) data['uid'] = this.uid;
    if (this.firstName != null) data['first_name'] = this.firstName;
    if (this.lastName != null) data['last_name'] = this.lastName;
    if (this.email != null) data['email'] = this.email;
    if (this.displayName != null) data['display_name'] = this.displayName;
    if (this.password != null) data['password'] = this.password;
    if (this.profileImage != null) data['profile_image'] = this.profileImage;
    if (this.isOnline != null) data['isOnline'] = this.isOnline;
    if (this.updatedAt != null) data['updated_at'] = this.updatedAt;
    if (this.createdAt != null) data['created_at'] = this.createdAt;
    if (this.bloodGroup != null) data['bloodGroup'] = this.bloodGroup;
    if (this.lastdonated != null) data['lastdonated'] = this.lastdonated;
    return data;
  }
}
