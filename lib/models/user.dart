class User {
    String userId;
    String userName;
    String userEmail;
    String userPhone;

    User({
        this.userId,
        this.userName,
        this.userEmail,
        this.userPhone,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userPhone: json["user_phone"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_phone": userPhone,
    };
}
