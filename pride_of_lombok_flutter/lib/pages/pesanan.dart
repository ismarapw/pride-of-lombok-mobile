import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';

class Pesanan extends StatefulWidget {
  @override
  State<Pesanan> createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  // Fungsi untuk mengambil data pesanan dari API
  getPesananMasuk() async {
    var response = await http.get(Uri.parse("$baseURL/api/pesanan-masuk"));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pesanan Masuk", 
                  style: TextStyle(
                    color:Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)
                  ),

                FutureBuilder(
                  // secara async ambil data pesanan yang masuk dari semua user dengan API
                  future: getPesananMasuk(),
                  builder: ((context,snapshot){
                    if(snapshot.hasData){
                      // Jika ada data yang didapat maka ambil data pesanan
                      var pesananMasuk = (snapshot.data as Map)['data'];

                      // Tampilkan data pesanan pada halaman
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: pesananMasuk.length,
                          itemBuilder: (context,index){
                            return Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.grey.withOpacity(.3),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Text(
                                          pesananMasuk[index]['created_at'] + " (" + pesananMasuk[index]['username'] + " )",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            // color: Colors.black
                                          ),

                                        ),
                                       SizedBox(height: 10),
                                       Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("$baseURL/images/marchendise/"+pesananMasuk[index]['gambar']),
                                              fit: BoxFit.cover,
                                            ),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          )
                                        ),
                              
                                        SizedBox(height: 10),
                              
                                        Text(
                                          pesananMasuk[index]['nama'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                              
                                        SizedBox(height: 10),
                              
                                        Text(
                                          "Rp." + pesananMasuk[index]['total_tagihan'].toString() + " (" + pesananMasuk[index]['jumlah_dibeli'].toString() + " item)" ,
                                           style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.deepOrange
                                          ),
                                        ),
                              
                                        SizedBox(height: 10),
                              
                                        Text(
                                          "Dibayar via "+ pesananMasuk[index]['metode_bayar'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                              
                                          ),
                                        ),
                              
                                        SizedBox(height: 10),
                              
                                         Text(
                                          "Dikirim ke "+ pesananMasuk[index]['alamat'],
                                           style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                              
                                        SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } 
                        );
                    
                    }else {
                      // Selama belum dapat data dari API, tampilkan loading UI
                      return Center (
                        child: CircularProgressIndicator()
                      );
                    }
                  }),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}