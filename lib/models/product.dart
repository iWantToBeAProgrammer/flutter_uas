class Product {
  String nama;
  int harga;
  String gambar;
  String deskripsi;

  Product(
      {required this.nama,
      required this.gambar,
      required this.deskripsi,
      required this.harga});


  static List<Product> getProduct() {
    List<Product> product = [];

    product.add(
      Product(
          nama: 'Bibit Jambu',
          gambar: 'assets/products/bibit.jpeg',
          deskripsi: "Bibit jambu terbaik fix panen!!!",
          harga: 88000),
    );
    product.add(
      Product(
          nama: 'Bawang Putih',
          gambar: 'assets/products/bawang_putih.jpg',
          deskripsi: "Bawang putih mantep nih, dah paling enak",
          harga: 30000),
    );
    product.add(
      Product(
          nama: 'Bawang Merah',
          gambar: 'assets/products/bawang.jpg',
          deskripsi:
              "Bawang merah juga mantep, tapi jahat dia ama bawang putih",
          harga: 25000),
    );
    product.add(
      Product(
          nama: 'Kopi Asli Indonesia',
          gambar: 'assets/products/kopi.jpg',
          deskripsi: "Kopi asli dipake di starbaks sama kopi kenangan",
          harga: 45000),
    );
    product.add(
      Product(
          nama: 'Pupuk Organik',
          gambar: 'assets/products/pupuk_organik.jpg',
          deskripsi:
              "Pupuk organik, udah pasti subur taneman mah mau nanem apa juga",
          harga: 70000),
    );
    product.add(
      Product(
          nama: 'Pupuk Cair',
          gambar: 'assets/products/pupuk.jpeg',
          deskripsi: "Pupuk cair, penyubur taneman juga nih versi cair",
          harga: 95000),
    );

    return product;
  }
}
