import 'package:flutter/material.dart';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/session.dart' as globals;

class Detail extends StatefulWidget {
  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  // Fungsi untuk mengambil info marchendise berdasarkan id pada API
  getMerchendiseById(id) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-marchendise-by-id/"+id.toString()));
    return jsonDecode(response.body);
  }

  // Fungsi untuk menambhkan marchendise menjadi favorit
  tambahFavorit(idUser, idMarchendise) async {
    var response = await http.post(Uri.parse("$baseURL/api/tambah-favorit/"+idUser.toString()+"/"+idMarchendise.toString()));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    // ambil data dari paramater yang dikirimkan pada halaman sebelumnya
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Detail Marchendise",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),

      body:SingleChildScrollView(
        child: FutureBuilder(
          // secara async ambil data marchendise dari API
          future: getMerchendiseById(data['marchendiseId']),
          builder: ((context,snapshot){
            if(snapshot.hasData){
              // Jika ada data yang didapat maka ambil data marchendise
              var marchendise = (snapshot.data as Map)['data'];

              // Tampilkan data marchendise pada halaman
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("$baseURL/images/marchendise/"+marchendise['gambar']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 10,0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                marchendise['nama'],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5),

                        Text(
                          marchendise['jenis'],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black54
                          ),
                        ),

                        SizedBox(height: 10),
                        Text(
                         "Rp." + marchendise['harga'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.deepOrange
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          "Deskripsi",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.green
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          marchendise['deskripsi']+"",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ]
                    )
                  )
                ]
              );
            }else {
              // tampilkan loading selama mengambil data dari API
               return Center (
                  child: CircularProgressIndicator()
              );
            }
          })
        )
      ),

      bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 65.0,
            padding: EdgeInsets.fromLTRB(15, 8, 12, 5),
            width: double.maxFinite,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/bayar', arguments: {'marchendiseId' : data['marchendiseId']});
                    }, 
                    child: Text(
                      "Beli Langsung",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
    
              SizedBox(width: 10),
    
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green, width: 1),
                    ),
                    onPressed: () async{
                      // ambil hasil dari API 
                      var result_json = await tambahFavorit(globals.userId, data['marchendiseId']);

                      // jika mengembalikan code 300, maka artinya data sudah ada di favorit
                      if(result_json['code'] == 300){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Barang sudah ada di favorit"),
                          )
                        );
                      }else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Barang berhasil ditambahkan menjadi favorit"),
                          )
                        );
                      }
                    },        
                    child: Text(
                      "Tambah ke Favorit",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}