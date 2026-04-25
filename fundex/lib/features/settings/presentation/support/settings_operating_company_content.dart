import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../../../app/support/localized_static_document_url.dart';

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

  factory SettingsOperatingCompanyContent.fromJson(
    Map<String, dynamic> json, {
    String? localeTag,
  }) {
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
      links: _listOfMap(json['links'])
          .map(SettingsOperatingCompanyLink.fromJson)
          .map(
            (SettingsOperatingCompanyLink link) => localeTag == null
                ? link
                : link.withUrl(localizedStaticPdfUrl(link.url, localeTag)),
          )
          .toList(growable: false),
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

  String? get electronicInformationUrl =>
      _findLinkUrlBySuffix('electronic_information.pdf');

  String? get termsConditionsUrl =>
      _findLinkUrlBySuffix('terms_conditions.pdf');

  String? get antiSocialRuleUrl => _findLinkUrlBySuffix('antisocialrule.pdf');

  String? get personalInformationUrl =>
      _findLinkUrlBySuffix('personal_information.pdf');

  String? _findLinkUrlBySuffix(String suffix) {
    for (final link in links) {
      final url = link.url.trim();
      if (url.isEmpty) {
        continue;
      }
      if (_canonicalPdfPath(url).endsWith(suffix.toLowerCase())) {
        return url;
      }
    }
    return null;
  }

  String _canonicalPdfPath(String url) {
    final path = Uri.tryParse(url)?.path ?? url;
    return path.toLowerCase().replaceFirst(
      RegExp(r'\.(?:ja|en|zh-hans|zh-hant)\.pdf$', caseSensitive: false),
      '.pdf',
    );
  }

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
        localeTag: localeTag,
      );
    } catch (_) {
      final raw = await rootBundle.loadString(
        'assets/content/settings_operating_company_ja.json',
      );
      return SettingsOperatingCompanyContent.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
        localeTag: 'ja',
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

  SettingsOperatingCompanyLink withUrl(String url) {
    if (url == this.url) {
      return this;
    }
    return SettingsOperatingCompanyLink(title: title, icon: icon, url: url);
  }
}
