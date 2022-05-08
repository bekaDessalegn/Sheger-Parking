// ignore_for_file: file_names

class BranchDetails {
  final String id;
  final String name;
  final String location;
  final int capacity;
  final bool onService;
  final int pricePerHour;
  final String description;

  const BranchDetails({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.onService,
    required this.pricePerHour,
    required this.description,
  });

  factory BranchDetails.fromJson(Map<String, dynamic> json) => BranchDetails(
    id: json['id'],
    name: json['name'],
    location: json['location'],
    capacity: json['capacity'],
    onService: json['onService'],
    pricePerHour: json['pricePerHour'],
    description: json['description'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'capacity': capacity,
    'onService': onService,
    'pricePerHour': pricePerHour,
    'description': description,
  };
}
