class Customer {
  final int id;
  final String firstName;
  final String lastName;

  Customer({required this.id, required this.firstName, required this.lastName});

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
