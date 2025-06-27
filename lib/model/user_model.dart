class UserModel {
  final String id;
  final String name;
  final String age;
  final String phone;
  final String email;

  UserModel( {
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
     this.id = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'phone': phone,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
