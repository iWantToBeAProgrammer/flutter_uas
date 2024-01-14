import 'package:flutter/material.dart';
import 'package:my_application/models/product.dart';

class ProductPages extends StatelessWidget {
  final Map? products;

  const ProductPages({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(products!['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                products!['image'],
                width: 300,
                height: 200,
              ),
              Text(
                products!['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  products!['desc'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Harga: Rp.${products!['price']}",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
