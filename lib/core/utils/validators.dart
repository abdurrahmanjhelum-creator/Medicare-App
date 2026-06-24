import '../constants/app_strings.dart';

/// Validation utility class for form inputs
class Validators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.enterValidEmail;
    }
    
    return null;
  }

  /// Validate password (minimum 6 characters)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  /// Validate confirm password matches password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    
    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    
    return null;
  }

  /// Validate name (not empty)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequired;
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Validate CNIC (Pakistani format: XXXXX-XXXXXXX-X)
  static String? validateCNIC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.cnicRequired;
    }
    
    final cnicRegex = RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]$');
    if (!cnicRegex.hasMatch(value.trim())) {
      return 'Please enter a valid CNIC (XXXXX-XXXXXXX-X)';
    }
    
    return null;
  }

  /// Validate fee amount
  static String? validateFee(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.feeRequired;
    }
    
    final fee = double.tryParse(value);
    if (fee == null || fee <= 0) {
      return 'Please enter a valid fee amount';
    }
    
    return null;
  }

  /// Validate license number
  static String? validateLicense(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.licenseRequired;
    }
    
    if (value.trim().length < 5) {
      return 'License number must be at least 5 characters';
    }
    
    return null;
  }

  /// Validate date of birth (user must be at least 18 years old)
  static String? validateDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }
    
    try {
      final dob = DateTime.parse(value);
      final now = DateTime.now();
      final age = now.year - dob.year;
      
      if (age < 18 || (age == 18 && now.month < dob.month)) {
        return 'You must be at least 18 years old';
      }
      
      if (dob.isAfter(now)) {
        return 'Date of birth cannot be in the future';
      }
    } catch (e) {
      return 'Please enter a valid date';
    }
    
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName is required' : 'This field is required';
    }
    return null;
  }
}
