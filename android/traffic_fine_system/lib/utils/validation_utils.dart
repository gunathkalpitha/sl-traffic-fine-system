class ValidationUtils {
  // Username validation - alphanumeric and underscores, 3-20 characters
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (value.length > 20) {
      return 'Username cannot exceed 20 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  // Password validation - minimum 8 characters, at least one uppercase, one number, one special character
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};:",./<>?\\|`~]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  // Fine reference number validation - alphanumeric, typically 8-12 characters
  static String? validateFineReference(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fine reference number is required';
    }
    if (value.length < 8) {
      return 'Fine reference number is too short';
    }
    if (value.length > 20) {
      return 'Fine reference number is too long';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Fine reference number can only contain letters and numbers';
    }
    return null;
  }

  // Card number validation - 16 digits
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    final digits = value.replaceAll(' ', '');
    if (digits.length != 16) {
      return 'Card number must be 16 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(digits)) {
      return 'Card number can only contain numbers';
    }
    // Luhn algorithm validation
    if (!_luhnCheck(digits)) {
      return 'Invalid card number';
    }
    return null;
  }

  // Cardholder name validation
  static String? validateCardHolder(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cardholder name is required';
    }
    if (value.length < 3) {
      return 'Cardholder name must be at least 3 characters';
    }
    if (value.length > 50) {
      return 'Cardholder name is too long';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Cardholder name can only contain letters and spaces';
    }
    return null;
  }

  // Expiry date validation - MM/YY format
  static String? validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Expiry date must be in MM/YY format';
    }
    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return 'Invalid month';
    }

    if (year == null) {
      return 'Invalid year';
    }

    // Check if card is expired
    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYear) {
      return 'Card has expired';
    }
    if (year == currentYear && month < currentMonth) {
      return 'Card has expired';
    }

    return null;
  }

  // CVV validation - 3 or 4 digits
  static String? validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    if (!RegExp(r'^[0-9]{3,4}$').hasMatch(value)) {
      return 'CVV must be 3 or 4 digits';
    }
    return null;
  }

  // Luhn algorithm for card number validation
  static bool _luhnCheck(String cardNum) {
    int sum = 0;
    int isSecond = 0;
    for (int i = cardNum.length - 1; i >= 0; i--) {
      int n = int.parse(cardNum[i]);
      if (isSecond == 1) {
        n = n * 2;
        if (n > 9) {
          n = n - 9;
        }
      }
      sum += n;
      isSecond = 1 - isSecond;
    }
    return sum % 10 == 0;
  }
}
