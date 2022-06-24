import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:pride_of_lombok_flutter/services/session.dart' as globals;

class Pencarian extends StatefulWidget {
  @override
  State<Pencarian> createState() => _PencarianState();
}

class _PencarianState extends State<Pencarian> {

  // Fungsi cari berdasarkan input ke API
  getMarchendiseBySearch(value) async {
    var response = await http.get(Uri.parse("$baseURL/api/cari-marchendise/$value"));
    return jsonDecode(response.body);
  }



  @override
  Widget build(BuildContext context) {
    // Ambil data dari paramater data halaman sebelumnya
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Hasil Pencarian",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        
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
                    Text(
                      "Hasil pencarian untuk " + "'"+ data['value'] + "'",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
      
              
                SizedBox(height: 15),

                FutureBuilder(
                  // jalankan fungsi cari secara asycn
                  future: getMarchendiseBySearch( data['value']),
                  builder: ((context,snapshot){
                    if(snapshot.hasData){
                      // ambil data yang didapat
                      var marchendises = (snapshot.data as Map)['data'];

                      // tampilkan data yang didapat
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
                      // loading selama async
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