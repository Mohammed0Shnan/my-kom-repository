class LoginResponse{
 late String status_code;
 late String message;
 late String token;

  LoginResponse.fromJson(Map<String , dynamic> map){
    this.status_code = map['status_code'];
    this.message = map['message'];
    this.token = map['token'];
  }
    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = this.token;
    return data;
  }
}