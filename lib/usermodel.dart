class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  List? stamps;

  UserModel(
      {this.uid, this.email, this.firstName, this.secondName, this.stamps});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      stamps: map['stamps'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'stamps': stamps
    };
  }
}
