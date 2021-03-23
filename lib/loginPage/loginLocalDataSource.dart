
class UserLoginData{
  final String email;
  final String password;
  final String token_csrf;

  UserLoginData({this.email, this.password, this.token_csrf});

  Map<String, dynamic> toMap(){
    return {
      "token_csrf": "${this.token_csrf}",
      "email": "${this.email}",
      "password": "${this.password}"
    };
  }

}

class LoginDataForm{
   String email;
   String password;
   String token_csrf;


}