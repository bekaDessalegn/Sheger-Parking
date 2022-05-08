// ignore_for_file: file_names

class ReservationDetails {
  final String id;
  final String client;
  final String reservationPlateNumber;
  final String branch;
  final String slot;
  final int price;
  final int startingTime;
  final int duration;
  final bool parked;

  const ReservationDetails({
    required this.id,
    required this.client,
    required this.reservationPlateNumber,
    required this.branch,
    required this.slot,
    required this.price,
    required this.startingTime,
    required this.duration,
    required this.parked,
  });

  factory ReservationDetails.fromJson(Map<String, dynamic> json) => ReservationDetails(
    id: json['id'],
    client: json['client'],
    reservationPlateNumber: json['reservationPlateNumber'],
    branch: json['branch'],
    slot: json['slot'],
    price: json['price'],
    startingTime: json['startingTime'],
    duration: json['duration'],
    parked: json['parked'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'client': client,
    'reservationPlateNumber': reservationPlateNumber,
    'branch': branch,
    'slot': slot,
    'price': price,
    'startingTime': startingTime,
    'duration': duration,
    'parked': parked,
  };
}
