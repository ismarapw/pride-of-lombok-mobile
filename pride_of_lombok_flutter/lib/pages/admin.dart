import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:pride_of_lombok_flutter/services/session.dart' as session;

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  // Fungsi untuk mendapatkan info User dari API
  getUser(id) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-user/$id"));
    return jsonDecode(response.body);
  }

  // Fungsi untuk get semua marchendise dari API
  getAllMarchendise() async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-all-marchendise"));
    return jsonDecode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambahMarchendise');
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder(
                       // Bagian pada halaman ini akan dijalankan secara async dalam mengambil data user dari API
                      future: getUser(session.userId),
                      builder: ((context, snapshot) {
                        if(snapshot.hasData){
                          // Jika ada data yang didapat maka tampilkan username dari user
                          var username = (snapshot.data as Map)['data']['username'];
                          return  Text(
                            "Hai $username.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 24,
                            ),
                          );
                        }else {
                          // Selama belum dapat data dari API, tampilkan loading UI
                           return Center (
                            child: CircularProgressIndicator()
                          );
                        }
                      })
                    ),
                   
      
                    Text(
                      "Sebagai Admin mari atur marchendise Mu.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
      
                SizedBox(height: 20),
      
                Text(
                  "Daftar Marchendise",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 15),

                FutureBuilder(
                  // Bagian pada halaman ini akan dijalankan secara async dalam mengambil data marchendise dari API
                  future: getAllMarchendise(),
                  builder: ((context,snapshot){
                    // Jika ada data yang didapat maka tampilkan daftar marchendise
                    if(snapshot.hasData){
                      // ambil data marchendise dari API
                      var marchendises = (snapshot.data as Map)['data'];
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                            mainAxisSpacing: 10,
                        ),
                        itemCount: marchendises.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(.15),
                                width: 1,
                              ),
                            ),
                    
                            child: InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, '/preview', arguments: {'marchendiseId' : marchendises[index]['id']});
                              },
                    
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 110,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage("$baseURL/images/marchendise/"+marchendises[index]['gambar']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    ),
                                  ),
                            
                                  Container(
                                    margin: EdgeInsets.fromLTRB(7, 15, 0,0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          marchendises[index]['nama'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                            
                                        Text(
                                          marchendises[index]['jenis'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54
                                          ),
                                        ),
                            
                                        Text(
                                          "Rp. "+ marchendises[index]['harga'].toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.w600
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                      });
                    }else{
                      // Selama belum dapat data dari API, tampilkan loading UI
                      return Center (
                        child: CircularProgressIndicator()
                      );
                    }
                  })
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}