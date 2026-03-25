class PhoneCountryCodeOption {
  const PhoneCountryCodeOption({
    required this.intlTeleCode,
    required this.name,
    required this.shortName,
  });

  final String intlTeleCode;
  final String name;
  final String shortName;

  String get dialLabel => '+$intlTeleCode';
  String get displayLabel => '$name  $shortName';
}

const List<PhoneCountryCodeOption>
phoneCountryCodeOptions = <PhoneCountryCodeOption>[
  PhoneCountryCodeOption(intlTeleCode: '86', name: '中国', shortName: 'CN +86'),
  PhoneCountryCodeOption(intlTeleCode: '81', name: '日本', shortName: 'JP +81'),
  PhoneCountryCodeOption(intlTeleCode: '852', name: '香港', shortName: 'HK +852'),
  PhoneCountryCodeOption(intlTeleCode: '853', name: '澳門', shortName: 'MO +853'),
  PhoneCountryCodeOption(intlTeleCode: '886', name: '台灣', shortName: 'TW +886'),
  PhoneCountryCodeOption(intlTeleCode: '82', name: '대한민국', shortName: 'KR +82'),
  PhoneCountryCodeOption(
    intlTeleCode: '1',
    name: 'United States',
    shortName: 'US +1',
  ),
  PhoneCountryCodeOption(
    intlTeleCode: '44',
    name: 'United Kingdom',
    shortName: 'UK +44',
  ),
  PhoneCountryCodeOption(
    intlTeleCode: '49',
    name: 'Deutschland',
    shortName: 'DE +49',
  ),
  PhoneCountryCodeOption(intlTeleCode: '33', name: 'France', shortName: 'FR +33'),
  PhoneCountryCodeOption(intlTeleCode: '66', name: 'ไทย', shortName: 'TH +66'),
  PhoneCountryCodeOption(
    intlTeleCode: '65',
    name: 'Singapore',
    shortName: 'SG +65',
  ),
  PhoneCountryCodeOption(
    intlTeleCode: '60',
    name: 'Malaysia',
    shortName: 'MY +60',
  ),
  PhoneCountryCodeOption(
    intlTeleCode: '61',
    name: 'Australia',
    shortName: 'AU +61',
  ),
  PhoneCountryCodeOption(intlTeleCode: '420', name: 'Česko', shortName: 'CZ +420'),
];

PhoneCountryCodeOption phoneCountryCodeOptionByCode(String intlCode) {
  for (final option in phoneCountryCodeOptions) {
    if (option.intlTeleCode == intlCode) {
      return option;
    }
  }
  return PhoneCountryCodeOption(
    intlTeleCode: intlCode,
    name: 'Other',
    shortName: '+$intlCode',
  );
}
