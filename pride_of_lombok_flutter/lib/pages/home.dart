import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:pride_of_lombok_flutter/services/session.dart' as globals;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  // variabel penampung nilai field cari
  var cariTextController = TextEditingController();
  
  // fungsi untuk mengambil data user dari API
  getUser(id) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-user/$id"));
    return jsonDecode(response.body);
  }

  // fungsi untuk mengambil data semua marchendise
  getAllMarchendise() async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-all-marchendise"));
    return jsonDecode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                      // Secara async, ambil data user dengan API
                      future: getUser(globals.userId),
                      builder: ((context, snapshot) {
                        if(snapshot.hasData){
                          // jika ada data user yang didapat, maka ambil data usernamenya
                          var username = (snapshot.data as Map)['data']['username'];

                          // tampilkan username pada halaman
                          return  Text(
                            "Hai $username.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 24,
                            ),
                          );
                        }else {
                          // selama mengambil data dari API, tampilkan loading UI
                           return Center (
                            child: CircularProgressIndicator()
                          );
                        }
                      })
                    ),
      
                    Text(
                      "Kuy cari oleh-oleh khas Lombok",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
      
                SizedBox(height: 20),
      
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Cari barang disini",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.green,),
                      onPressed: (){
                        if(cariTextController.text != ''){
                          Navigator.pushNamed(context, '/pencarian', arguments: {'value' : cariTextController.text});
                        }
                      },
                    ),
                  ),
                  controller: cariTextController,
                ),
      
                SizedBox(height: 20),
      
                Text(
                  "Marchendise Terbaru",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 15),

                FutureBuilder(
                  // secara sycn ambil semua data marchendise dengan API
                  future: getAllMarchendise(),
                  builder: ((context,snapshot){
                    if(snapshot.hasData){
                      // jika ada data yang didapat, ambil data marchendise
                      var marchendises = (snapshot.data as Map)['data'];

                      // tampilkan semua data marcehndise dengan grid view
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
                                // print(myProducts[index]['name']);
                                Navigator.pushNamed(context, '/detail', arguments: {'marchendiseId' : marchendises[index]['id']});
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
                      // selama mengambil data, tampilkan loading UI
                      return Center (
                        child: CircularProgressIndicator()
                      );
                    }
                  }
                )
                )               
              ],
            ),
          ),
        ),
      )
    );
  }
}