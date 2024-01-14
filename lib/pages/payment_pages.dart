import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PaymentPages extends StatefulWidget {
  const PaymentPages({super.key, required this.total});

  final int total;

  @override
  State<PaymentPages> createState() => _PaymentPagesState();
}

class _PaymentPagesState extends State<PaymentPages> {
  TextEditingController textController = TextEditingController();

  int kembali = 0;

  void _getValue() {
    int payment = int.parse(textController.text);
    if (payment >= widget.total) {
      if (image != null) {
        setState(() {
          kembali = payment - widget.total;
        });
      } else {
        final snackBar = SnackBar(
          duration: Duration(seconds: 5),
          content: Text('Masukkan Bukti Pembayaran Terlebih Dahulu'),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    } else {
      final snackBar = SnackBar(
        duration: Duration(seconds: 5),
        content: Text('Jumlah Pembayaran Tidak Mencukupi'),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  File? image;

  Future<void> uploadFile() async {
    final pickedFile = await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
      return;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment pages',
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: Column(
              children: [
                Text(
                  'Total Transaksi:\n${widget.total.toString()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Jumlah Pembayaran: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 250,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: textController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        helperText: 'Masukkan Jumlah Pembayaran',
                        helperStyle: const TextStyle(fontSize: 12),
                        helperMaxLines: 2,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _getValue();
                    },
                    child: const Text("Submit")),
                const Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: Text(
                    'Kembali',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  kembali.toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Masukan Bukti Pembayaran',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Container(
                            width: 300,
                            height: 100,
                            child: ElevatedButton(
                              onPressed: () => uploadFile(),
                              child: Row(
                                children: [
                                  Icon(Icons.add_rounded),
                                  Text('Add Image')
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
