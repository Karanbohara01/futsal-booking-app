class Futsal {
  final String id;
  final String name;
  final String address;
  final int pricePerHour;
  final List<String> images;
  final String owner;
  final DateTime createdAt;

  Futsal({
    required this.id,
    required this.name,
    required this.address,
    required this.pricePerHour,
    required this.images,
    required this.owner,
    required this.createdAt,
  });

  factory Futsal.fromJson(Map<String, dynamic> json) {
    return Futsal(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      pricePerHour: json['price_per_hour'],
      // Convert the list of images from dynamic to String
      images: List<String>.from(json['images']),
      owner: json['owner'],
      // Parse the date string into a DateTime object
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
