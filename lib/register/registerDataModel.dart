class RegisterData {
  final String token_csrf;
  final bool isCompany;
  final String email;
  final String password;
  final String passwordConfirm;
  final String firstName;
  final String lastName;
  final int province;
  final String municipe;
  final String addressLines;
  final String addressLines_1;
  final String phone;
  final bool privacyCheck;

  RegisterData(
      {this.token_csrf,
      this.isCompany,
      this.email,
      this.password,
      this.passwordConfirm,
      this.firstName,
      this.lastName,
      this.province,
      this.municipe,
      this.addressLines,
      this.addressLines_1,
      this.phone,
      this.privacyCheck});

  Map<String, dynamic> toMap() {
    return {
      'token_csrf': this.token_csrf,
      'isCompany': this.isCompany,
      'email': this.email,
      'password': this.password,
      'passwordConfirm': this.passwordConfirm,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'province': this.province,
      'municipe': this.municipe,
      'addressLines': this.addressLines,
      'addressLines_1': this.addressLines_1,
      'phone': this.phone,
      'privacyCheck': this.privacyCheck
    };
  }
}

class RegisterDataForm {
  String email;
  String password;
  String passwordConfirm;
  String token_csrf;
  bool isCompany;
  String firstName;
  String lastName;
  int province;
  String municipe;
  String addressLines;
  String addressLines_1;
  String phone;
  bool privacyCheck;
}
