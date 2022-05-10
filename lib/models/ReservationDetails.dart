// ignore_for_file: file_names

class ReservationDetails {
  final String id;
  final String client;
  final String reservationPlateNumber;
  final String branch;
  final String branchName;
  final String slot;
  final int price;
  final int startingTime;
  final int duration;
  final bool parked;
  final bool completed;
  final bool expired;

  const ReservationDetails({
    required this.id,
    required this.client,
    required this.reservationPlateNumber,
    required this.branch,
    required this.branchName,
    required this.slot,
    required this.price,
    required this.startingTime,
    required this.duration,
    required this.parked,
    required this.completed,
    required this.expired,
  });

  factory ReservationDetails.fromJson(Map<String, dynamic> json) => ReservationDetails(
    id: json['id'],
    client: json['client'],
    reservationPlateNumber: json['reservationPlateNumber'],
    branch: json['branch'],
    branchName: json['branchName'],
    slot: json['slot'],
    price: json['price'],
    startingTime: json['startingTime'],
    duration: json['duration'],
    parked: json['parked'],
    completed: json['completed'],
    expired: json['expired'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'client': client,
    'reservationPlateNumber': reservationPlateNumber,
    'branch': branch,
    'branchName': branchName,
    'slot': slot,
    'price': price,
    'startingTime': startingTime,
    'duration': duration,
    'parked': parked,
    'completed': completed,
    'expired': expired,
  };
}
