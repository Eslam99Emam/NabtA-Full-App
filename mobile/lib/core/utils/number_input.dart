/// Forgiving parsing for numbers typed or pasted by people, in Latin or
/// Arabic-Indic digits, with "." "٫" or "," as the decimal separator.
abstract final class NumberInput {
  static const int _arabicZero = 0x0660;
  static const int _persianZero = 0x06F0;
  static const String _arabicDecimal = '٫'; // ٫
  static const String _arabicThousands = '٬'; // ٬
  static const String _arabicComma = '،'; // ،
  static const String _minusSign = '−'; // −
  static const Set<int> _invisibleMarks = {0x200E, 0x200F, 0x061C, 0x202A, 0x202B, 0x202C, 0x202D, 0x202E};

  /// Converts Arabic-Indic/Persian digits to ASCII, maps "٫" to "." and
  /// "٬" to ",", and drops bidi control marks.
  static String normalizeDigits(String raw) {
    final buffer = StringBuffer();
    for (final rune in raw.runes) {
      if (rune >= _arabicZero && rune <= _arabicZero + 9) {
        buffer.writeCharCode(0x30 + rune - _arabicZero);
      } else if (rune >= _persianZero && rune <= _persianZero + 9) {
        buffer.writeCharCode(0x30 + rune - _persianZero);
      } else if (_invisibleMarks.contains(rune)) {
        continue;
      } else {
        final char = String.fromCharCode(rune);
        buffer.write(switch (char) {
          _arabicDecimal => '.',
          _arabicThousands => ',',
          _minusSign => '-',
          _ => char,
        });
      }
    }
    return buffer.toString();
  }

  static final RegExp _plainNumber = RegExp(r'^[+-]?(\d+\.?\d*|\.\d+)$');
  static final RegExp _grouped = RegExp(r'^\d{1,3}(,\d{3})+(\.\d+)?$');

  /// Parses a single number. With [allowGrouping], "1,000" means one
  /// thousand; otherwise a comma is read as a decimal separator.
  static double? parse(String raw, {bool allowGrouping = false}) {
    var text = normalizeDigits(raw).replaceAll(' ', '').trim();
    if (text.isEmpty) return null;
    if (allowGrouping && _grouped.hasMatch(text)) {
      text = text.replaceAll(',', '');
    } else {
      text = text.replaceAll(',', '.');
    }
    if (!_plainNumber.hasMatch(text)) return null;
    return double.tryParse(text);
  }

  static final RegExp _pair = RegExp(
    r'^([+-]?\d+(?:\.\d+)?)(\s*[,;]\s*|\s+)([+-]?\d+(?:\.\d+)?)$',
  );

  /// Detects a pasted "lat, lng" pair such as "30.0444, 31.2357".
  /// "30,5" (no space, no dots) is treated as a decimal, not a pair.
  static (double, double)? parseCoordinatePair(String raw) {
    final text = normalizeDigits(raw).replaceAll(_arabicComma, ',').trim();
    final match = _pair.firstMatch(text);
    if (match == null) return null;
    final first = match.group(1) ?? '';
    final separator = match.group(2) ?? '';
    final second = match.group(3) ?? '';
    final ambiguousComma = separator == ',' && !first.contains('.') && !second.contains('.');
    if (ambiguousComma) return null;
    final a = double.tryParse(first);
    final b = double.tryParse(second);
    if (a == null || b == null) return null;
    return (a, b);
  }

  /// Short, editable ASCII form of a coordinate (max 6 decimals, no
  /// trailing zeros).
  static String compact(double value) {
    var text = value.toStringAsFixed(6);
    if (text.contains('.')) {
      text = text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    }
    return text;
  }

  /// Rounds to [decimals] places without binary-float noise.
  static double roundTo(double value, int decimals) =>
      double.parse(value.toStringAsFixed(decimals));
}
