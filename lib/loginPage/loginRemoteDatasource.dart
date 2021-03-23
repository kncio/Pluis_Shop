class LoginResponse{
  final String user_id;
  final String name;
  final String email;
  final String token;

  LoginResponse({this.user_id, this.name, this.email, this.token});

  static LoginResponse fromMap(Map<String,dynamic> data){
    return LoginResponse(
      user_id: data['user_id'].toString(),
      name: data['name'].toString(),
      email: data['email'].toString(),
      token: data['token'].toString()
    );
  }
}