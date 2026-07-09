String? validateInput(String? input) {
  if (input == null || input.isEmpty) {
    return 'This field is required';
  }
  // You can add more validation logic here, such as checking for specific formats, lengths, etc.
  // For example:
  // if (!isValidFormat(input)) {
  //   return 'Invalid format';
  // }

  return null; // Return null if validation succeeds
}
