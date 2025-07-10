class Booking {
  final String id;
  final String futsalName;
  final String futsalAddress;
  final DateTime date;
  final String timeSlot;
  final String status;

  Booking({
    required this.id,
    required this.futsalName,
    required this.futsalAddress,
    required this.date,
    required this.timeSlot,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      futsalName: json['futsal']['name'] ?? 'N/A',
      futsalAddress: json['futsal']['address'] ?? 'N/A',
      date: DateTime.parse(json['date']),
      timeSlot: json['time_slot'],
      status: json['status'],
    );
  }
}
