import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_application/pages/payment_pages.dart';

class ShippingPages extends StatefulWidget {
  const ShippingPages({super.key, required this.total, required this.weight});

  final int total;
  final int weight;
  @override
  State<ShippingPages> createState() => _ShippingPagesState();
}

class _ShippingPagesState extends State<ShippingPages> {
  Map<Object, dynamic>? _response;
  Map<Object, dynamic>? _city;
  Map<Object, dynamic>? _cost;
  String _value = '1';
  String _stateValue = 'Pilih Kecamatan:';
  int shipping = 0;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<dynamic>? province = _response?['rajaongkir']['results'].toList();
    List<DropdownMenuItem<String>> menuItems = [];

    province?.map((e) {
      menuItems.add(DropdownMenuItem(
        value: e['province_id'].toString(),
        child: Text(e['province']),
      ));
    }).toList();

    return menuItems;
  }

  List<DropdownMenuItem<String>> get stateItems {
    List<dynamic>? province = _city?['rajaongkir']['results'].toList();
    List<DropdownMenuItem<String>> menuItems = [];

    province?.map((e) {
      menuItems.add(DropdownMenuItem(
        value: e['city_id'].toString(),
        child: Text(e['city_name']),
      ));
    }).toList();

    menuItems.add(DropdownMenuItem(
      value: 'Pilih Kecamatan:',
      child: Text('Pilih Kecamatan:'),
    ));

    return menuItems;
  }

  Future<http.Response> getProvince() async {
    final headers = {'key': 'bffede2313ec61d10965c7d91a9befa2'};

    final response = await http.get(
        Uri.parse('https://api.rajaongkir.com/starter/province'),
        headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        _response = jsonDecode(response.body);
      });
    }
    return response;
  }

  Future<http.Response> getState(String id) async {
    final headers = {'key': 'bffede2313ec61d10965c7d91a9befa2'};

    final response = await http.get(
        Uri.parse('https://api.rajaongkir.com/starter/city?province=$id'),
        headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        _city = jsonDecode(response.body);
      });
    }
    return response;
  }

  Future<void> setOrder() async {
    final uid = _auth.currentUser!.uid;

    await dbRef
        .child('order/$uid')
        .push()
        .set({'price': shipping.toString(), 'status': 'pending'});

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => PaymentPages(total: shipping))));
  }

  Future<http.Response> getCost(String id) async {
    final headers = {'key': 'bffede2313ec61d10965c7d91a9befa2'};

    final response = await http.post(
        Uri.parse('https://api.rajaongkir.com/starter/cost'),
        headers: headers,
        body: {
          'origin': '398',
          'destination': id.toString(),
          'weight': widget.weight.toString(),
          'courier': 'jne'
        });

    if (response.statusCode == 200) {
      setState(() {
        _cost = jsonDecode(response.body);
      });
    }

    return response;
  }

  int? tappedIndex;
  Widget costList({required List cost, required int index}) {
    print(shipping.toString());
    return Ink(
      color: tappedIndex == index ? Colors.blue : Colors.transparent,
      child: ListTile(
        onTap: () {
          setState(() {
            tappedIndex = index;
            shipping = cost[0]['costs'][index]['cost'][0]['value'];
            shipping += widget.total;
          });
        },
        title: Text(cost[0]['costs'][index]['service']),
        subtitle: Text(cost[0]['costs'][index]['description']),
        trailing: Text(cost[0]['costs'][index]['cost'][0]['value'].toString()),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getProvince();
    getState('Pilih Kecamatan:');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tani Ratamba UD',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 18.0),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Masukkan Detail Pengiriman Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70)),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Masukkan provinsi: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownButton(
                          padding: EdgeInsets.all(12),
                          items: dropdownItems,
                          value: _value,
                          onChanged: (value) {
                            getState(value!);

                            setState(() {
                              _value = value;
                            });
                            print('province: $_value');
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Masukkan Kota: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DropdownButton(
                          padding: EdgeInsets.all(12),
                          items: stateItems,
                          value: _stateValue,
                          onChanged: (value) {
                            setState(() {
                              _stateValue = value!;
                            });
                            print('province: $_stateValue');
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Center(
                            child: ElevatedButton(
                              child: Text('Konfirmasi Alamat'),
                              onPressed: () => getCost(_stateValue),
                            ),
                          ),
                        ),
                        Container(
                            height: 200,
                            child: ListView.builder(
                                itemCount: 3,
                                itemBuilder: (((context, index) {
                                  if (_cost != null) {
                                    List cost = _cost?['rajaongkir']['results']
                                        .toList();

                                    return costList(cost: cost, index: index);
                                  }
                                }))))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
                width: 200,
                child: ElevatedButton(
                    onPressed: () => setOrder(), child: Text("Submit"))),
          ),
        ],
      ),
    );
  }
}
