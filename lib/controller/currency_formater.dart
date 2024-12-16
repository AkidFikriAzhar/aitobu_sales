
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '0.00');
    }

    // Remove all non-numeric characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Parse the numeric value and format it as currency (e.g., 123 -> 1.23)
    final value = double.parse(digitsOnly) / 100;
    final formattedValue = NumberFormat("0.00").format(value);

    // Return the updated value with the correct cursor position
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
