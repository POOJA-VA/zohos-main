class Login {
  final int? usrId;
  final String usrName;
  final String usrPassword;

  Login({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
  });

  factory Login.fromMap(Map<String, dynamic> json) => Login(
        usrId: json["usrId"],
        usrName: json["usrName"],
        usrPassword: json["usrPassword"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "usrName": usrName,
        "usrPassword": usrPassword,
      };
}