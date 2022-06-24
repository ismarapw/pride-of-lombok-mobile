import 'package:flutter/material.dart';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/session.dart' as globals;

class Favorit extends StatefulWidget {
  @override
  State<Favorit> createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {

  // fungsi untuk mengambil data user dari API
  getUser(id) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-user/$id"));
    return jsonDecode(response.body);
  }

  // Fungsi untuk mengambil info marchendise berdasarkan id pada API
  getMarchendiseFavorit(idUser) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-marchendise-favorit/"+idUser.toString()));
    return jsonDecode(response.body);
  }

  // Fungsi untuk menghapus data marchendise
  hapusMarchendiseFavorit(idUser, idMarchendise) async{
    var response =  await http.post(Uri.parse("$baseURL/api/delete-marchendise-favorit/"+idUser.toString()+"/"+idMarchendise.toString()));
    return jsonDecode(response.body);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 24,
                            ),
                          );
                        }else {
                          // selama mengambil data dari API, tampilkan loading UI
                           return const Center (
                            child: const CircularProgressIndicator()
                          );
                        }
                      })
                    ),
      
                    const Text(
                      "Langsung Checkout aja, nanti stoknya habis ><",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
      
                const SizedBox(height: 20),
      
                const Text(
                  "Barang Favorit Anda",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 15),

                
                FutureBuilder(
                  // Secara async, ambil data favorit user dengan API
                  future: getMarchendiseFavorit(globals.userId),
                  builder: ((context,snapshot){
                    if(snapshot.hasData){
                      // ambil data marcehnsie favorit
                      var marchendises = (snapshot.data as Map)['data'];

                      // tampilkan data marchendise
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.75,
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
                                print(marchendises);
                                Navigator.pushNamed(context, '/detail', arguments: {'marchendiseId' : marchendises[index]['merch_id']});
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
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    ),
                                  ),
                            
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(7, 15, 0,0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          marchendises[index]['nama'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                            
                                        Text(
                                          marchendises[index]['jenis'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54
                                          ),
                                        ),

                                        Row(
                                          children: <Widget>[                   
                                            Expanded(
                                              child: Text(
                                                "Rp. "+ marchendises[index]['harga'].toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                        
                                            IconButton(
                                              color: Colors.red,
                                              onPressed: () async{
                                                var result = await hapusMarchendiseFavorit(globals.userId, marchendises[index]['merch_id']);
                                                if(result['code'] == 200){
                                                  setState(() {
                                                     ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(result['data']),
                                                      )
                                                    );
                                                  });
                                                }
                                              }, 
                                              icon: const Icon(Icons.delete_forever_rounded),
                                            ),
                                          ]
                                        ),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                      });
                    }else{
                      // tampilkan loading UI selama mengambil data secara async
                      return const Center (
                        child: const CircularProgressIndicator()
                      );
                    }
                  }
                )
                )       
              ],
            ),
          ),
        ),
      ),
    );
  }
}