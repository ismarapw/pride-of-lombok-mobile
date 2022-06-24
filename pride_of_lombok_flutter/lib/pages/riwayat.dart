import 'package:flutter/material.dart';
import 'package:pride_of_lombok_flutter/services/session.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';

class Riwayat extends StatefulWidget {
  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  // Fungsi untuk mengambil data riwayat pembelian user dari API
  getRiwayatBeli(idUser) async {
    var response = await http.get(Uri.parse("$baseURL/api/riwayat-pesanan/$idUser"));
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
                  "Riwayat Pembelian", 
                  style: TextStyle(
                    color:Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)
                  ),

                FutureBuilder(
                   // secara async ambil data pesanan yang masuk dari semua user dengan API
                  future: getRiwayatBeli(globals.userId),
                  builder: ((context,snapshot){
                    if(snapshot.hasData){
                       // Jika ada data yang didapat maka ambil riwayat pesanan
                      var riwayatPembelian = (snapshot.data as Map)['data'];

                      // Tampilkan data riwayat pembelian pada halaman
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: riwayatPembelian.length,
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
                                          "Dibeli pada "+ riwayatPembelian[index]['created_at'],
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
                                              image: NetworkImage("$baseURL/images/marchendise/"+riwayatPembelian[index]['gambar']),
                                              fit: BoxFit.cover,
                                            ),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          )
                                        ),
                              
                                        SizedBox(height: 10),
                              
                                        Text(
                                          riwayatPembelian[index]['nama'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                              
                                        SizedBox(height: 10),
                              
                                        Text(
                                          "Rp." + riwayatPembelian[index]['total_tagihan'].toString() + " (" + riwayatPembelian[index]['jumlah_dibeli'].toString() + " item)" ,
                                           style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.deepOrange
                                          ),
                                        ),
                              
                                        SizedBox(height: 10),
                              
                                        Text(
                                          "Dibayar via "+ riwayatPembelian[index]['metode_bayar'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                              
                                          ),
                                        ),
                              
                                        SizedBox(height: 10),
                              
                                         Text(
                                          "Dikirim ke "+ riwayatPembelian[index]['alamat'],
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
                      // tampilkan loading selama mengambil data secara async
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