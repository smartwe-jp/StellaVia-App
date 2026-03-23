import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SettingsFaqContent {
  const SettingsFaqContent({required this.heroTitle, required this.sections});

  final String heroTitle;
  final List<SettingsFaqSection> sections;

  static Future<SettingsFaqContent> load(String localeTag) async {
    final candidates = <String>[
      'assets/content/settings_faq_$localeTag.json',
      if (localeTag.startsWith('ja')) 'assets/content/settings_faq_ja.json',
      'assets/content/settings_faq_ja.json',
    ];

    for (final assetPath in candidates.toSet()) {
      try {
        final raw = await rootBundle.loadString(assetPath);
        final json = jsonDecode(raw) as Map<String, dynamic>;
        return SettingsFaqContent.fromJson(json);
      } on FlutterError {
        continue;
      }
    }

    throw FlutterError('Unable to load FAQ content for locale: $localeTag');
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
