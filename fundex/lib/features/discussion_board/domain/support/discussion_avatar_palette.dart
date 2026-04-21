List<int> discussionAvatarGradientForSeed(int? seed) {
  const palette = <List<int>>[
    <int>[0xFF6366F1, 0xFF8B5CF6],
    <int>[0xFFEC4899, 0xFFF472B6],
    <int>[0xFF10B981, 0xFF34D399],
    <int>[0xFFF59E0B, 0xFFFBBF24],
    <int>[0xFF2563EB, 0xFF60A5FA],
    <int>[0xFF14B8A6, 0xFF2DD4BF],
  ];
  if (seed == null) {
    return palette.first;
  }
  return palette[seed.abs() % palette.length];
}

List<List<int>> get discussionAvatarPresetGradientValues => const <List<int>>[
  <int>[0xFF6366F1, 0xFF8B5CF6],
  <int>[0xFFEC4899, 0xFFF472B6],
  <int>[0xFF10B981, 0xFF34D399],
  <int>[0xFFF59E0B, 0xFFFBBF24],
  <int>[0xFF2563EB, 0xFF60A5FA],
  <int>[0xFF14B8A6, 0xFF2DD4BF],
];
