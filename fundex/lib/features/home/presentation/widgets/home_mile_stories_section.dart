import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class HomeMileStoriesSection extends StatelessWidget {
  const HomeMileStoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          AppBrandHeading(
            eyebrow: l.benefitsStoriesEn,
            title: l.benefitsStoriesJp,
          ),
          Text(l.benefitsStoriesLead),
          _MileStory(
            label: l.benefitsStory1Label,
            title: l.benefitsStory1Title,
            amount: l.benefitsStory1TagAmount,
            milestones: [
              (
                l.benefitsMonth1Full,
                l.benefitsFundA,
                l.benefitsStory1Step1Action,
                500,
                'REGULAR',
              ),
              (
                l.benefitsMonth6Full,
                l.benefitsStory1Step2Sub,
                l.benefitsStory1Step2Action,
                500,
                'REGULAR',
              ),
              (
                l.benefitsMonth12Full,
                l.benefitsStepEndSub,
                l.benefitsStory1Step3Action,
                500,
                'REGULAR',
              ),
            ],
            total: 6000,
          ),
          _MileStory(
            label: l.benefitsStory2Label,
            title: l.benefitsStory2Title,
            amount: l.benefitsStory2TagAmount,
            milestones: [
              (
                l.benefitsMonth1Full,
                l.benefitsFundA,
                l.benefitsStory1Step1Action,
                500,
                'REGULAR',
              ),
              (
                l.benefitsMonth6Full,
                l.benefitsFundB,
                l.benefitsStory2Step2Action,
                5775,
                'BRONZE',
              ),
              (
                l.benefitsMonth12Full,
                l.benefitsStepEndSub,
                l.benefitsStory2Step3Action,
                5775,
                'BRONZE',
              ),
            ],
            rankUpMonth: l.benefitsMonth6Full,
            total: 37650,
          ),
          Text(l.benefitsStoriesNote, style: context.appTextTheme.caption),
        ],
      ),
    );
  }
}

class _MileStory extends StatelessWidget {
  const _MileStory({
    required this.title,
    required this.label,
    required this.amount,
    this.rankUpMonth,
    required this.milestones,
    required this.total,
  });
  final String label, title, amount;
  final String? rankUpMonth;
  final List<(String, String, String, int, String)> milestones;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final text = context.appTextTheme;
    final number = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(label, style: text.caption),
          Text(title, style: text.bodyStrong),
          Text(amount),
          Text(l.benefitsStoryTerm),
          for (final (month, stage, action, monthlyMiles, rank)
              in milestones) ...[
            const Divider(height: 1),
            Text(month, style: text.caption),
            Text(stage),
            Text(action, style: text.bodyStrong),
            if (month == rankUpMonth)
              Text(l.benefitsStory2RankUp, style: text.bodyStrong),
            Text(
              '${number.format(monthlyMiles)} ${l.benefitsMilesPerMonth} · $rank',
            ),
          ],
          const Divider(height: 1),
          Text(l.benefitsAfter12Months, style: text.caption),
          Text(
            '${l.benefitsTotalMilesLabel}  ${number.format(total)} ${l.benefitsMilesUnit}',
            style: text.numericTitle,
          ),
          Text(l.benefitsResultRankLabel, style: text.caption),
          Text(milestones.last.$5),
          Text(l.benefitsAssetLabel, style: text.caption),
          Text(milestones.last.$3),
        ],
      ),
    );
  }
}
