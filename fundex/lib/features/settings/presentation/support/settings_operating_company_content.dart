import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

@immutable
class SettingsOperatingCompanyContent {
  const SettingsOperatingCompanyContent({
    required this.tradeName,
    required this.licenseNumber,
    required this.licenseType,
    required this.representative,
    required this.headOffice,
    required this.tel,
    required this.established,
    required this.business,
    required this.manager,
    required this.copyright,
    required this.links,
  });

  factory SettingsOperatingCompanyContent.fromJson(Map<String, dynamic> json) {
    return SettingsOperatingCompanyContent(
      tradeName: json['tradeName']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString() ?? '',
      licenseType: json['licenseType']?.toString() ?? '',
      representative: json['representative']?.toString() ?? '',
      headOffice: json['headOffice']?.toString() ?? '',
      tel: json['tel']?.toString() ?? '',
      established: json['established']?.toString() ?? '',
      business: json['business']?.toString() ?? '',
      manager: json['manager']?.toString() ?? '',
      copyright: json['copyright']?.toString() ?? '',
      links: _listOfMap(
        json['links'],
      ).map(SettingsOperatingCompanyLink.fromJson).toList(growable: false),
    );
  }

  final String tradeName;
  final String licenseNumber;
  final String licenseType;
  final String representative;
  final String headOffice;
  final String tel;
  final String established;
  final String business;
  final String manager;
  final String copyright;
  final List<SettingsOperatingCompanyLink> links;

  static Future<SettingsOperatingCompanyContent> load(String localeTag) async {
    final normalizedTag = localeTag.replaceAll('_', '-').toLowerCase();
    final normalized = switch (normalizedTag) {
      String tag when tag.startsWith('ja') => 'ja',
      String tag
          when tag.startsWith('zh-hant') ||
              tag.startsWith('zh-tw') ||
              tag.startsWith('zh-hk') ||
              tag.startsWith('zh-mo') =>
        'zh_Hant',
      String tag when tag.startsWith('zh') => 'zh',
      _ => 'en',
    };

    try {
      final raw = await rootBundle.loadString(
        'assets/content/settings_operating_company_$normalized.json',
      );
      return SettingsOperatingCompanyContent.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      final raw = await rootBundle.loadString(
        'assets/content/settings_operating_company_ja.json',
      );
      return SettingsOperatingCompanyContent.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    }
  }

  static List<Map<String, dynamic>> _listOfMap(Object? value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }

    return value
        .whereType<Map>()
        .map((Map item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }
}

@immutable
class SettingsOperatingCompanyLink {
  const SettingsOperatingCompanyLink({
    required this.title,
    required this.icon,
    required this.url,
  });

  factory SettingsOperatingCompanyLink.fromJson(Map<String, dynamic> json) {
    return SettingsOperatingCompanyLink(
      title: json['title']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  final String title;
  final String icon;
  final String url;
}
