// Doctor Patient Model - Doctor ke liye patient ka data model
class DoctorPatientModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String age;
  final String gender;
  final String bloodGroup;
  final String address;
  final String profileImage;
  final String medicalHistory;

  const DoctorPatientModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.address,
    required this.profileImage,
    required this.medicalHistory,
  });

  // JSON se model create karne ke liye
  factory DoctorPatientModel.fromJson(Map<String, dynamic> json) {
    return DoctorPatientModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      address: json['address'] ?? '',
      profileImage: json['profileImage'] ?? '',
      medicalHistory: json['medicalHistory'] ?? '',
    );
  }

  // Model ko JSON mein convert karne ke liye
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'address': address,
      'profileImage': profileImage,
      'medicalHistory': medicalHistory,
    };
  }
}
