class LoginRequest {
  late String username;
  late String password;
  LoginRequest(this.username, this.password);

  LoginRequest.fromJson(Map<String, dynamic> map) {
    this.username = map['username'];
    this.password = map['password'];
  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic>  map ={};
    map['username'] = this.username;
    map['password'] = this.password;
    return map;
  }
}
