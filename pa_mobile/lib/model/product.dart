class Product {
  String? id;
  int harga;
  String desc;
  String kategori;
  String ekstensi;

  Product(
      {this.id,
      required this.harga,
      required this.desc,
      required this.ekstensi,
      required this.kategori});

  Map<String, dynamic> toMap() {
    return {
      'harga': harga.toString(),
      'deskripsi': desc,
      'kategori': kategori,
      'ekstensi': ekstensi
    };
  }
}
