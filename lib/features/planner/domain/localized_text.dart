/// Bilingual domain content (crop names, notes, strategy copy).
class LocalizedText {
  const LocalizedText({required this.en, required this.ar});

  final String en;
  final String ar;

  String resolve(String languageCode) => languageCode == 'ar' ? ar : en;
}
