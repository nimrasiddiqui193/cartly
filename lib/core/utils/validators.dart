class AppValidators {
  AppValidators._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? name(String? value) {
    final error = required(value, fieldName: 'Name');
    if (error != null) return error;

    final trimmed = value!.trim();

    if (trimmed.length < 2) {
      return 'Name must contain at least 2 characters.';
    }

    if (!RegExp(r"^[a-zA-Z][a-zA-Z\s'.-]*$").hasMatch(trimmed)) {
      return 'Please enter a valid name.';
    }

    return null;
  }

  static String? email(String? value) {
    final error = required(value, fieldName: 'Email');
    if (error != null) return error;

    final email = value!.trim();

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@'
      r'[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
      r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static String? password(String? value) {
    final error = required(value, fieldName: 'Password');
    if (error != null) return error;

    if (value!.length < 6) {
      return 'Password must contain at least 6 characters.';
    }

    return null;
  }

  static String? confirmPassword(
    String? value, {
    required String passwordValue,
  }) {
    final error = required(value, fieldName: 'Confirm password');
    if (error != null) return error;

    if (value != passwordValue) {
      return 'Passwords do not match.';
    }

    return null;
  }

  static String? phone(String? value) {
    final error = required(value, fieldName: 'Phone number');
    if (error != null) return error;

    final digits = value!.replaceAll(RegExp(r'[\s()+-]'), '');

    if (!RegExp(r'^\d{10,15}$').hasMatch(digits)) {
      return 'Please enter a valid phone number.';
    }

    return null;
  }

  static String? address(String? value) {
    final error = required(value, fieldName: 'Address');
    if (error != null) return error;

    if (value!.trim().length < 5) {
      return 'Please enter a complete address.';
    }

    return null;
  }

  static String? city(String? value) {
    final error = required(value, fieldName: 'City');
    if (error != null) return error;

    if (!RegExp(r"^[a-zA-Z][a-zA-Z\s'.-]*$").hasMatch(value!.trim())) {
      return 'Please enter a valid city.';
    }

    return null;
  }

  static String? postalCode(String? value) {
    final error = required(value, fieldName: 'Postal code');
    if (error != null) return error;

    if (!RegExp(r'^[a-zA-Z0-9\s-]{3,10}$').hasMatch(value!.trim())) {
      return 'Please enter a valid postal code.';
    }

    return null;
  }

  static String? number(String? value, {String fieldName = 'Value'}) {
    final error = required(value, fieldName: fieldName);
    if (error != null) return error;

    if (double.tryParse(value!.trim()) == null) {
      return 'Please enter a valid number.';
    }

    return null;
  }

  static String? amount(String? value) {
    final error = number(value, fieldName: 'Amount');
    if (error != null) return error;

    if (double.parse(value!.trim()) <= 0) {
      return 'Amount must be greater than zero.';
    }

    return null;
  }

  static String? optionalText(String? value, {int maxLength = 500}) {
    if (value == null || value.trim().isEmpty) return null;

    if (value.trim().length > maxLength) {
      return 'Maximum $maxLength characters allowed.';
    }

    return null;
  }
}

class Validators {
  Validators._();

  // Existing method names.
  static String? required(String? value, {String fieldName = 'This field'}) {
    return AppValidators.required(value, fieldName: fieldName);
  }

  static String? name(String? value) => AppValidators.name(value);

  static String? email(String? value) => AppValidators.email(value);

  static String? password(String? value) => AppValidators.password(value);

  static String? confirmPassword(
    String? value, {
    required String passwordValue,
  }) {
    return AppValidators.confirmPassword(value, passwordValue: passwordValue);
  }

  static String? phone(String? value) => AppValidators.phone(value);

  static String? address(String? value) => AppValidators.address(value);

  static String? city(String? value) => AppValidators.city(value);

  static String? postalCode(String? value) => AppValidators.postalCode(value);

  static String? number(String? value, {String fieldName = 'Value'}) {
    return AppValidators.number(value, fieldName: fieldName);
  }

  static String? amount(String? value) => AppValidators.amount(value);

  static String? optionalText(String? value, {int maxLength = 500}) {
    return AppValidators.optionalText(value, maxLength: maxLength);
  }

  // Backward-compatible names used by existing screens.
  static String? validateName(String? value) => AppValidators.name(value);

  static String? validateEmail(String? value) => AppValidators.email(value);

  static String? validatePassword(String? value) =>
      AppValidators.password(value);

  static String? validateConfirmPassword(
    String? value, {
    required String password,
  }) {
    return AppValidators.confirmPassword(value, passwordValue: password);
  }
}
