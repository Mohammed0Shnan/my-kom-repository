class LoginResponse{
 late  String name;
  late String email;
  late String token;
  
  LoginResponse.fromJson(Map<String , dynamic> map){
    this.name = map['user']['name'];
    this.email = map['user']['email'];
    this.token = map['token'];
  }
    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = this.token;
    return data;
  }
}