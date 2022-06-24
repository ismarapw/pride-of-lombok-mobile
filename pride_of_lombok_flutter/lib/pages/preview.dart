import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Preview extends StatefulWidget {
  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {

  // Fungsi untuk mengambil info marchendise berdasarkan id pada API
  getMerchendiseById (id) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-marchendise-by-id/"+id.toString()));
    return jsonDecode(response.body);
  }

  // Fungsi untuk menghapus suatu marchendise dengan API
  hapusMarchendiseById(id) async {
    var response = await http.get(Uri.parse("$baseURL/api/delete-marchendise/"+id.toString()));

    return jsonDecode(response.body);  
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data dari paramater data halaman sebelumnya
    var data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Preview Marchendise",
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
                        Text(
                          marchendise['nama'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
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
                            fontWeight: FontWeight.w500,
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
               // Selama belum dapat data dari API, tampilkan loading UI
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
                  height: 45,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/ubahMarchendise', arguments: {'marchendiseId' : data['marchendiseId']});
                    }, 
                    child: Text(
                      "Edit",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
    
              SizedBox(width: 10),
    
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green, width: 1),
                    ),
                    onPressed: () async {
                      // Hapus marcehndise dengan API
                      var response_json = await hapusMarchendiseById(data['marchendiseId']);    

                      // Tampilkan elert jika hapus barang berhasil
                      if(response_json['code'] == 200){
                        Alert(
                          context: context,
                          style: const AlertStyle(
                            animationType: AnimationType.shrink
                          ),
                          type: AlertType.success,
                          title: "Informasi Hapus",
                          desc: "Barang berhasil dihapus",
                          buttons: [
                            DialogButton(
                              color: Colors.green,
                              child: const Text(
                                "Oke",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, "/navbar");
                              } 
                            ),
                          ]
                        ).show();
                      }else {
                        // Tampilkan hapus gagal jika penghapusan gagal
                        Alert(
                          context: context,
                          style: const AlertStyle(
                            animationType: AnimationType.shrink
                          ),
                          type: AlertType.warning,
                          title: "Informasi Hapus",
                          desc: "Barang gagal Dihapus",
                          buttons: [
                            DialogButton(
                              color: Colors.red,
                              child: const Text(
                                "Kembali",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              } 
                            ),
                          ]
                        ).show();
                      }         
                    },        
                    child: Text(
                      "Hapus",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      )
    );    
  }
}