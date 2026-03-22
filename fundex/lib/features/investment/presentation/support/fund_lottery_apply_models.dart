class FundLotteryDocumentItem {
  const FundLotteryDocumentItem({
    required this.selectionIndex,
    required this.title,
    required this.subtitle,
    this.onOpen,
  });

  final int selectionIndex;
  final String title;
  final String subtitle;
  final void Function()? onOpen;
}

class FundLotteryDocumentGroup {
  const FundLotteryDocumentGroup({required this.title, required this.items});

  final String title;
  final List<FundLotteryDocumentItem> items;
}

class FundLotterySummaryRow {
  const FundLotterySummaryRow({required this.label, required this.value});

  final String label;
  final String value;
}

class FundLotteryDepositRow {
  const FundLotteryDepositRow({
    required this.label,
    required this.value,
    this.copyable = false,
  });

  final String label;
  final String value;
  final bool copyable;
}
