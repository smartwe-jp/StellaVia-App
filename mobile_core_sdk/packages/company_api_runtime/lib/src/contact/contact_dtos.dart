class ContactWeRequestDto {
  const ContactWeRequestDto({
    required this.familyName,
    required this.name,
    required this.furiganaFamilyName,
    required this.furiganaName,
    required this.email,
    required this.questionCategory,
    required this.question,
  });

  final String familyName;
  final String name;
  final String furiganaFamilyName;
  final String furiganaName;
  final String email;
  final String questionCategory;
  final String question;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'familyName': familyName,
      'name': name,
      'furiganaFamilyName': furiganaFamilyName,
      'furiganaName': furiganaName,
      'email': email,
      'questionCategory': questionCategory,
      'question': question,
    };
  }
}
