class Craft {
  final String id;
  final String name;
  final String price;
  final String desc;
  final String category;
  final String imageUrl;

  Craft({
    required this.id,
    required this.name,
    required this.price,
    required this.desc,
    required this.category,
    required this.imageUrl,
  });

  factory Craft.fromJson(Map<String, dynamic> json) {
    return Craft(
      id: json['id'].toString(),
      name: json['name'] ?? 'Tanpa Nama',
      price: json['price']?.toString() ?? '0',
      desc: json['description'] ?? '',
      category: json['category'] ?? 'Koleksi',
      // Langsung ambil URL dari database. Jika kosong, biarkan string kosong ('')
      imageUrl: json['image_url'] ?? '', 
    );
  }
}