enum OwnerPresence { yes, no, unknown }

enum OwnerControl { ownershipOver25, materialInfluence }

class BeneficialOwner {
  const BeneficialOwner({
    required this.name,
    required this.birthdate,
    required this.country,
    required this.address,
    required this.control,
    required this.percentage,
  });
  final String name, birthdate, country, address, percentage;
  final OwnerControl? control;
  bool get complete =>
      control != null &&
      [name, birthdate, country, address].every((v) => v.trim().isNotEmpty);
}
