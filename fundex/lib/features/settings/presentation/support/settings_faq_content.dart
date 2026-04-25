import 'dart:convert';

import 'package:flutter/services.dart';

class SettingsFaqContent {
  const SettingsFaqContent({required this.heroTitle, required this.sections});

  final String heroTitle;
  final List<SettingsFaqSection> sections;

  static Future<SettingsFaqContent> load(String localeTag) async {
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
        'assets/content/settings_faq_$normalized.json',
      );
      return SettingsFaqContent.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      final raw = await rootBundle.loadString(
        'assets/content/settings_faq_ja.json',
      );
      return SettingsFaqContent.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    }
  }

  factory SettingsFaqContent.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List<dynamic>? ?? const [];
    return SettingsFaqContent(
      heroTitle: json['heroTitle'] as String? ?? 'FAQ',
      sections: sectionsJson
          .map(
            (dynamic item) =>
                SettingsFaqSection.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }
}

class SettingsFaqSection {
  const SettingsFaqSection({required this.title, required this.items});

  final String title;
  final List<SettingsFaqItem> items;

  factory SettingsFaqSection.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? const [];
    return SettingsFaqSection(
      title: json['title'] as String? ?? '',
      items: itemsJson
          .map(
            (dynamic item) =>
                SettingsFaqItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }
}

class SettingsFaqItem {
  const SettingsFaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  factory SettingsFaqItem.fromJson(Map<String, dynamic> json) {
    return SettingsFaqItem(
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
    );
  }
}
