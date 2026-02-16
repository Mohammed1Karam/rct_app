String convertArabicNumbersToEnglish(String input) {
  const arabicToEnglishNumbers = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  // Map Arabic numbers to English numbers
  return input.split('').map((char) {
    return arabicToEnglishNumbers[char] ??
        char; // Replace or keep the character
  }).join();
}
