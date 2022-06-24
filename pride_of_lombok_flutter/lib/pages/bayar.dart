import 'package:flutter/material.dart';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/session.dart' as globals;  
import 'package:rflutter_alert/rflutter_alert.dart';

class Bayar extends StatefulWidget {
  @override
  State<Bayar> createState() => _BayarState();
}

class _BayarState extends State<Bayar> {
   // variabel penampung nilai form
  var jumlahTextController = TextEditingController(text:"0");
  var alamatTextController = TextEditingController();
  var metodePembayaran = '';
  var totalHarga = 0;

  // Fungsi untuk mengambil info marchendise berdasarkan id pada API
  getMerchendiseById(id) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-marchendise-by-id/"+id.toString()));
    return jsonDecode(response.body);
  }

  // Fungsi untuk membuat pesanan ke API
  buatPesanan(idUser, idMarchendise) async {
    // ambil data dari form
    var data = {
      "jumlah" : jumlahTextController.text,
      "alamat": alamatTextController.text,
      "metode" : metodePembayaran
    };

    // Kirim request dengan method Post dari data form
    var response = await http.post(
      Uri.parse("$baseURL/api/bayar/"+idUser.toString()+"/"+idMarchendise.toString()),
      body: json.encode(data),
      headers: {
        'Content-type' : 'application/json',
        'Accept' : 'application/json'
      }
    );

    // Kembalikan nilai json
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    // ambil data dari paramater yang dikirimkan pada halaman sebelumnya
    var data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Pembayaran",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 65.0,
          padding: EdgeInsets.fromLTRB(15, 10, 12, 10),
          width: double.maxFinite,
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () async{
                // ambil json hasil request ke API 
                var response_json = await buatPesanan(globals.userId, data['marchendiseId']);
                
                // jika code adalah 400, maka pengisian form tidak valid
                if(response_json['code'] == 400){
                  // Munculkan alert dengan kesalahan form/validasi dari API
                  Alert(
                    context: context,
                    style: const AlertStyle(
                      animationType: AnimationType.shrink
                    ),
                    type: AlertType.error,
                    title: "Pembayaran Gagal",
                    desc: response_json['data'].values.toList()[0][0],
                    buttons: [
                      DialogButton(
                        color: Colors.red,
                        child: const Text(
                          "Okay",
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ).show();
                }else {
                  // Munculkan alert bahwa pembayaran berhasil dan arahkan ke halaman home
                   Alert(
                    context: context,
                    style: const AlertStyle(
                      animationType: AnimationType.shrink
                    ),
                    type: AlertType.success,
                    title: "Pembayaran Berhasil",
                    desc: "Terima kasih telah membeli",
                    buttons: [
                      DialogButton(
                        color: Colors.green,
                        child: const Text(
                          "Okay",
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: () => Navigator.pushReplacementNamed(context, "/navbar"),
                      )
                    ],
                  ).show();
                }
              }, 
              child: Text(
                "Bayar",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          // secara async ambil data marchendise dari API
          future: getMerchendiseById(data['marchendiseId']),
          builder:((context,snapshot){
            if(snapshot.hasData){
              // Jika ada data yang didapat maka ambil data marchendise
              var marchendise = (snapshot.data as Map)['data'];

              // Tampilkan data marchendise pada halaman
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("$baseURL/images/marchendise/"+marchendise['gambar']),
                          fit: BoxFit.cover,
                        ),
                      )
                    ),

                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        marchendise['nama'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black87
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Rp." + marchendise['harga'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  
          
                    SizedBox(height: 20),
                  
                    Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Jumlah',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()
                            ),
                              keyboardType: TextInputType.number,
                              controller: jumlahTextController,
                              onChanged: (value){
                                if(value == ''){
                                  value = "0";
                                }
                                setState(() {
                                  totalHarga = int.parse(value)*marchendise['harga'] as int;
                                });
                              },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                  
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Alamat',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()
                            ),
                            controller: alamatTextController,
                          ),
            
                          const SizedBox(
                            height: 20,
                          ),
                  
                          DropdownButtonFormField(
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:BorderSide(color: Colors.grey, width: 0.0),
                                ),
                                border: OutlineInputBorder()
                            ),
                            items: const [
                              DropdownMenuItem(
                                child: Text("OVO"),
                                value: "OVO",
                              ),
                              DropdownMenuItem(
                                child: Text("Go-Pay"),
                                value: "Go-Pay",
                              ),
                              DropdownMenuItem(
                                child: Text("Mandiri M-Banking"),
                                value: "Mandiri M-Bangking",
                              ),
                              DropdownMenuItem(
                                child: Text("BRI M-Banking"),
                                value: "BRI M-Banking",
                              )
                            ],
                            hint: const Text("Metode Pembayaran"), 
                            onChanged: (String? value) {
                              setState(() {
                                metodePembayaran = value!;
                              });
                            },
                          ),
            
                          SizedBox(height: 20),
            
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Total Harga: Rp."+ totalHarga.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.deepOrange
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }else {
              // tampilkan loading selama mengambil data marchendise
              return Center (
                  child: CircularProgressIndicator()
              ); 
            }
          })  
        ),
      ),
    );
  }
}