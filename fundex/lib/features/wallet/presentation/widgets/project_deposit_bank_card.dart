import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../investment/domain/entities/fund_project.dart';
import '../support/wallet_deposit_copy_support.dart';
import 'wallet_deposit_transfer_notice.dart';

enum ProjectDepositBankAccountKind { domestic, overseas }

class ProjectDepositBankCardTexts {
  const ProjectDepositBankCardTexts({
    required this.domesticTitle,
    required this.overseasTitle,
    required this.domesticSegmentLabel,
    required this.overseasSegmentLabel,
    required this.copyLabel,
    required this.copyDoneMessage,
    required this.bankInfoSectionTitle,
    required this.recipientInfoSectionTitle,
    required this.bankNameLabel,
    required this.swiftCodeLabel,
    required this.branchNameLabel,
    required this.branchAddressLabel,
    required this.bankCountryLabel,
    required this.accountNumberLabel,
    required this.accountHolderLabel,
    required this.accountHolderAddressLabel,
    required this.transferNotice,
    required this.transferName,
    required this.transferNameCopyButtonLabel,
  });

  final String domesticTitle;
  final String overseasTitle;
  final String domesticSegmentLabel;
  final String overseasSegmentLabel;
  final String copyLabel;
  final String copyDoneMessage;
  final String bankInfoSectionTitle;
  final String recipientInfoSectionTitle;
  final String bankNameLabel;
  final String swiftCodeLabel;
  final String branchNameLabel;
  final String branchAddressLabel;
  final String bankCountryLabel;
  final String accountNumberLabel;
  final String accountHolderLabel;
  final String accountHolderAddressLabel;
  final String transferNotice;
  final String transferName;
  final String transferNameCopyButtonLabel;
}

class ProjectDepositBankCard extends StatefulWidget {
  const ProjectDepositBankCard({
    super.key,
    required this.liveJapanBank,
    required this.notLiveJapanBank,
    required this.texts,
  });

  final FundProjectLiveJapanBank? liveJapanBank;
  final FundProjectLiveJapanBank? notLiveJapanBank;
  final ProjectDepositBankCardTexts texts;

  @override
  State<ProjectDepositBankCard> createState() => _ProjectDepositBankCardState();
}

class _ProjectDepositBankCardState extends State<ProjectDepositBankCard> {
  ProjectDepositBankAccountKind _selectedKind =
      ProjectDepositBankAccountKind.domestic;

  bool get _hasDomesticAccount => widget.liveJapanBank != null;

  bool get _hasOverseasAccount {
    final bank = widget.notLiveJapanBank;
    return _hasText(bank?.bankName) && _hasText(bank?.bankNumber);
  }

  @override
  void initState() {
    super.initState();
    _selectedKind = _resolveSelectedKind();
  }

  @override
  void didUpdateWidget(covariant ProjectDepositBankCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextKind = _resolveSelectedKind();
    if (nextKind == _selectedKind) {
      return;
    }
    setState(() {
      _selectedKind = nextKind;
    });
  }

  ProjectDepositBankAccountKind _resolveSelectedKind() {
    if (!_hasDomesticAccount && _hasOverseasAccount) {
      return ProjectDepositBankAccountKind.overseas;
    }
    if (!_hasOverseasAccount &&
        _selectedKind == ProjectDepositBankAccountKind.overseas) {
      return ProjectDepositBankAccountKind.domestic;
    }
    return _selectedKind;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    final showSegment = _hasDomesticAccount && _hasOverseasAccount;
    final showOverseas =
        _selectedKind == ProjectDepositBankAccountKind.overseas &&
        _hasOverseasAccount;
    final title = showOverseas
        ? widget.texts.overseasTitle
        : widget.texts.domesticTitle;
    final rows = showOverseas
        ? _buildOverseasRows(widget.notLiveJapanBank)
        : _buildDomesticRows(widget.liveJapanBank);
    final fullCopyText = _formatCopyRows(rows);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.account_balance_outlined,
                      color: colors.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: appText.sectionTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                AppCopyButton(
                  label: widget.texts.copyLabel,
                  onPressed: fullCopyText.isEmpty
                      ? null
                      : () => _copy(context, fullCopyText),
                  textStyle: appText.caption,
                ),
              ],
            ),
            if (showSegment) ...<Widget>[
              const SizedBox(height: 16),
              _ProjectDepositBankSegmentedControl(
                selectedKind: _selectedKind,
                domesticLabel: widget.texts.domesticSegmentLabel,
                overseasLabel: widget.texts.overseasSegmentLabel,
                onChanged: (ProjectDepositBankAccountKind value) {
                  setState(() {
                    _selectedKind = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 18),
            if (showOverseas)
              _OverseasDepositRows(
                rows: rows,
                bankInfoTitle: widget.texts.bankInfoSectionTitle,
                recipientInfoTitle: widget.texts.recipientInfoSectionTitle,
                copyLabel: widget.texts.copyLabel,
                onCopy: (String value) => _copy(context, value),
              )
            else
              _DomesticDepositRows(
                rows: rows,
                copyLabel: widget.texts.copyLabel,
                onCopy: (String value) => _copy(context, value),
              ),
            const SizedBox(height: 12),
            WalletDepositTransferNotice(
              message: widget.texts.transferNotice,
              transferName: widget.texts.transferName,
              copyButtonLabel: widget.texts.transferNameCopyButtonLabel,
              copyDoneMessage: widget.texts.copyDoneMessage,
            ),
          ],
        ),
      ),
    );
  }

  List<_DepositBankRowData> _buildDomesticRows(FundProjectLiveJapanBank? bank) {
    return <_DepositBankRowData>[
      _DepositBankRowData(
        label: widget.texts.bankNameLabel,
        value: bank?.bankName,
        copyable: false,
      ),
      _DepositBankRowData(
        label: widget.texts.branchNameLabel,
        value: bank?.branchBankName,
        copyValue: resolveWalletDepositBranchCopyValue(bank?.branchBankName),
      ),
      _DepositBankRowData(
        label: widget.texts.accountNumberLabel,
        value: bank?.bankNumber,
        copyValue: resolveWalletDepositAccountNumberCopyValue(bank?.bankNumber),
      ),
      _DepositBankRowData(
        label: widget.texts.accountHolderLabel,
        value: bank?.bankAccountOwnerName,
        copyable: false,
      ),
    ];
  }

  List<_DepositBankRowData> _buildOverseasRows(FundProjectLiveJapanBank? bank) {
    return <_DepositBankRowData>[
      _DepositBankRowData(
        label: widget.texts.bankNameLabel,
        value: bank?.bankName,
        section: _DepositBankRowSection.bank,
      ),
      _DepositBankRowData(
        label: widget.texts.swiftCodeLabel,
        value: bank?.bankAccountSwiftCode,
        section: _DepositBankRowSection.bank,
      ),
      _DepositBankRowData(
        label: widget.texts.branchNameLabel,
        value: bank?.branchBankName,
        section: _DepositBankRowSection.bank,
      ),
      _DepositBankRowData(
        label: widget.texts.branchAddressLabel,
        value: bank?.branchBankAddress,
        section: _DepositBankRowSection.bank,
      ),
      _DepositBankRowData(
        label: widget.texts.bankCountryLabel,
        value: bank?.bankCountry,
        copyable: false,
        section: _DepositBankRowSection.bank,
      ),
      _DepositBankRowData(
        label: widget.texts.accountNumberLabel,
        value: bank?.bankNumber,
        section: _DepositBankRowSection.recipient,
      ),
      _DepositBankRowData(
        label: widget.texts.accountHolderLabel,
        value: bank?.bankAccountOwnerName,
        section: _DepositBankRowSection.recipient,
      ),
      _DepositBankRowData(
        label: widget.texts.accountHolderAddressLabel,
        value: bank?.bankAccountOwnerAddress,
        section: _DepositBankRowSection.recipient,
      ),
    ];
  }

  Future<void> _copy(BuildContext context, String value) async {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: normalized));
    if (context.mounted) {
      AppNotice.show(context, message: widget.texts.copyDoneMessage);
    }
  }
}

class _ProjectDepositBankSegmentedControl extends StatelessWidget {
  const _ProjectDepositBankSegmentedControl({
    required this.selectedKind,
    required this.domesticLabel,
    required this.overseasLabel,
    required this.onChanged,
  });

  final ProjectDepositBankAccountKind selectedKind;
  final String domesticLabel;
  final String overseasLabel;
  final ValueChanged<ProjectDepositBankAccountKind> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: <Widget>[
            _SegmentButton(
              label: domesticLabel,
              selected: selectedKind == ProjectDepositBankAccountKind.domestic,
              textStyle: appText.bodyStrong,
              onTap: () => onChanged(ProjectDepositBankAccountKind.domestic),
            ),
            _SegmentButton(
              label: overseasLabel,
              selected: selectedKind == ProjectDepositBankAccountKind.overseas,
              textStyle: appText.bodyStrong,
              onTap: () => onChanged(ProjectDepositBankAccountKind.overseas),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.textStyle,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final TextStyle textStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Expanded(
      child: Material(
        color: selected ? colors.highlightGold : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle.copyWith(
                color: selected ? colors.onDark : colors.textSecondary.withValues(alpha: 0.6),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DomesticDepositRows extends StatelessWidget {
  const _DomesticDepositRows({
    required this.rows,
    required this.copyLabel,
    required this.onCopy,
  });

  final List<_DepositBankRowData> rows;
  final String copyLabel;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
        children: <Widget>[
          ...List<Widget>.generate(rows.length, (int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: <Widget>[
                  _DepositBankInfoRow(
                    row: rows[index],
                    copyLabel: copyLabel,
                    onCopy: onCopy,
                  ),
                  if (index < rows.length - 1)
                    Divider(height: 1, thickness: 1, color: colors.border),
                ],
              ),
            );
          }),
        ],
      
    );
  }
}

class _OverseasDepositRows extends StatelessWidget {
  const _OverseasDepositRows({
    required this.rows,
    required this.bankInfoTitle,
    required this.recipientInfoTitle,
    required this.copyLabel,
    required this.onCopy,
  });

  final List<_DepositBankRowData> rows;
  final String bankInfoTitle;
  final String recipientInfoTitle;
  final String copyLabel;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    final bankRows = rows
        .where((row) => row.section == _DepositBankRowSection.bank)
        .toList(growable: false);
    final recipientRows = rows
        .where((row) => row.section == _DepositBankRowSection.recipient)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SectionTitle(title: bankInfoTitle, textStyle: appText.bodyStrong),
        const SizedBox(height: 8),
        ...bankRows.map(
          (row) => _DepositBankInfoRow(
            row: row,
            copyLabel: copyLabel,
            onCopy: onCopy,
            emphasizeValue: true,
          ),
        ),
        Divider(height: 24, thickness: 1, color: colors.border),
        _SectionTitle(title: recipientInfoTitle, textStyle: appText.bodyStrong),
        const SizedBox(height: 8),
        ...recipientRows.map(
          (row) => _DepositBankInfoRow(
            row: row,
            copyLabel: copyLabel,
            onCopy: onCopy,
            emphasizeValue: true,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.textStyle});

  final String title;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Text(
      title,
      style: textStyle.copyWith(
        color: colors.primary,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _DepositBankInfoRow extends StatelessWidget {
  const _DepositBankInfoRow({
    required this.row,
    required this.copyLabel,
    required this.onCopy,
    this.emphasizeValue = false,
  });

  final _DepositBankRowData row;
  final String copyLabel;
  final ValueChanged<String> onCopy;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;
    final value = row.value?.trim();
    final copyValue = row.copyValue?.trim() ?? value ?? '';
    final hasCopy = row.copyable && copyValue.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 92,
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                row.label,
                style: appText.caption.copyWith(color: colors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value == null || value.isEmpty ? '--' : value,
              textAlign: TextAlign.end,
              style: (emphasizeValue ? appText.bodyStrong : appText.body)
                  .copyWith(color: colors.textPrimary, height: 1.45),
            ),
          ),
          if (hasCopy) ...<Widget>[
            const SizedBox(width: 8),
            AppCopyButton(
              label: copyLabel,
              onPressed: () => onCopy(copyValue),
              textStyle: appText.caption,
            ),
          ],
        ],
      ),
    );
  }
}

enum _DepositBankRowSection { bank, recipient }

class _DepositBankRowData {
  const _DepositBankRowData({
    required this.label,
    required this.value,
    this.copyValue,
    this.copyable = true,
    this.section = _DepositBankRowSection.bank,
  });

  final String label;
  final String? value;
  final String? copyValue;
  final bool copyable;
  final _DepositBankRowSection section;
}

bool _hasText(String? value) => value?.trim().isNotEmpty ?? false;

String _formatCopyRows(List<_DepositBankRowData> rows) {
  return rows
      .map((row) {
        final value = row.copyValue?.trim() ?? row.value?.trim() ?? '';
        if (value.isEmpty) {
          return '';
        }
        return '${row.label}: $value';
      })
      .where((line) => line.isNotEmpty)
      .join('\n');
}
