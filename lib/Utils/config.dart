import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

const APP_NAME = 'Thopaa';
const APP_NAME_TAG_LINE = 'Live Blood Donor';
var defaultPrimaryColor =
    Color.fromARGB(255, 255, 0, 0); // Don't add slash at the end of the url
// const DOMAIN_URL =
//     'https://sewahub.com.np/oldd'; // Don't add slash at the end of the url
// const BASE_URL = '$DOMAIN_URL/api/';

const DEFAULT_LANGUAGE = 'en';

/// You can change this to your Provider App package name
/// This will be used in Registered As Partner in Sign In Screen where your users can redirect to the Play/App Store for Provider App
/// You can specify in Admin Panel, These will be used if you don't specify in Admin Panel
// const PROVIDER_PACKAGE_NAME = 'com.sewahub.provider';
// const IOS_LINK_FOR_PARTNER = "#";

// const IOS_LINK_FOR_USER = '#';

const DASHBOARD_AUTO_SLIDER_SECOND = 5;
const OTP_TEXT_FIELD_LENGTH = 6;

const TERMS_CONDITION_URL = 'https://sewahub.com.np/thopaa/term-conditions';
const PRIVACY_POLICY_URL = 'https://sewahub.com.np/thoppa/privacy-policy';
const HELP_AND_SUPPORT_URL = 'https://sewahub.com.np/thopaa/help-support';
// const REFUND_POLICY_URL = 'https://sewahub.com.np/refund-policy';
const INQUIRY_SUPPORT_EMAIL = 'contact@sewahub.com.np';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+9779851255497';

DateTime todayDate = DateTime(2022, 8, 24);

Country defaultCountry() {
  return Country(
    phoneCode: '977',
    countryCode: 'NP',
    e164Sc: 977,
    geographic: true,
    level: 1,
    name: 'Nepal',
    example: '9123456789',
    displayName: 'Nepal (NP) [+977]',
    displayNameNoCountryCode: 'Nepal (NP)',
    e164Key: '977-NP-0',
    fullExampleWithPlusSign: '+9779123456789',
  );
}

//Chat Module File Upload Configs
const chatFilesAllowedExtensions = [
  'jpg', 'jpeg', 'png', 'gif', 'webp', // Images
  'pdf', 'txt', // Documents
  'mkv', 'mp4', // Video
  'mp3', // Audio
];

const max_acceptable_file_size = 5; //Size in Mb
