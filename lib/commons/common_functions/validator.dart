var regEx = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
RegExp numReg = RegExp(r".*[0-9].*");
RegExp phoneNumReg =
    RegExp(r"^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$");
RegExp letterReg = RegExp(r".*[A-Za-z].*");

String? emailValidator(String? value) {
  if (!regEx.hasMatch(value!)) {
    return 'Enter a valid email address';
  }
  return null;
}


String? isValidInstagramHandle(String? handle) {
  RegExp regex = RegExp(r'^[a-zA-Z0-9._]{1,30}$');
  if (!regex.hasMatch(handle!)) {
    return 'Enter a valid email address';
  }
  return null;
}


String? uNameValidator(String? value) {
  if (value!.isEmpty) {
    return 'Enter your name';
  }
  if (value.length > 15) {
    return 'Exceeded 15 characters';
  }
  return null;
}

String? validateUsername(String? username) {
  if ( username!.isEmpty) {
    return 'Username is required';
  }

  if (username.length < 3) {
    return 'Username must be at least 3 characters long';
  }

  if (username.length > 15) {
    return 'Username must be at most 15 characters long';
  }

  if (username.trim().contains(' ')) {
    return 'Username should not contain spaces';
  }

  return null; // Return null if validation passes
}

String? countryValidator(String? value) {
  if (value!.isEmpty) {
    return 'Enter your country';
  }
  return null;
}

String? sectionValidator(String? value) {
  if (value!.isEmpty) {
    return 'Can\'t be empty';
  }
  return null;
}

String? cityValidator(String? value) {
  if (value!.isEmpty) {
    return 'Enter your City';
  }
  return null;
}

String? addressValidator(String? value) {
  if (value!.isEmpty) {
    return 'Enter a Valid Address';
  }
  return null;
}

String? passValidator(String? value) {
  if (value!.length < 6) {
    return 'can not have less than 6 characters';
  }
  return null;
}

String? phoneValidator(String? value) {
  // if (!phoneNumReg.hasMatch(value!)) {
  //   return 'Enter a valid phone number';
  // } else
  if (value!.length > 12 || value.length < 8) {
    return 'Enter at least 8 numbers!';
  }
  return null;
}
