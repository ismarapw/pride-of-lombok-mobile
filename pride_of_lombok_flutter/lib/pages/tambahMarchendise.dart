import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:image_picker/image_picker.dart';

class TambahMarchendise extends StatefulWidget {
  @override
  State<TambahMarchendise> createState() => _TambahMarchendiseState();
}

class _TambahMarchendiseState extends State<TambahMarchendise> {
  
  // variable untuk nilai form
  var namaMarchendiseTextController = TextEditingController();
  var jenisMarchendiseTextController = TextEditingController();
  var deskripsiMarchendiseTextController = TextEditingController();
  var hargaMarchendiseTextController = TextEditingController();
  var uploadGmabarFile = '';

  // Fungsi untuk tambah marchendise ke API
  tambahMarchendise () async {
    // Ambil path dari file yang akan dikirim
    var filePath = uploadGmabarFile;

    // Definisikan URL dari API
    var uri = Uri.parse('$baseURL/api/tambah-marchendise');

    // Buat request dengan type multipart karena type ini yang dapat mengirimkan file
    var request = http.MultipartRequest('POST' , uri);

    // Jika gambar ada, maka tambahkan field gambar pada request
    if(filePath != ''){
      var multiPartFile = await http.MultipartFile.fromPath('gambar', filePath);
      request.files.add(multiPartFile);
      request.headers.addAll({"content-type" : "multipart/form-data"});
    }

    // Tambahkan field pada request sesuai dengan nama request yang diterima pada API
    request.fields['nama'] = namaMarchendiseTextController.text;
    request.fields['jenis'] = jenisMarchendiseTextController.text;
    request.fields['deskripsi'] = deskripsiMarchendiseTextController.text;
    request.fields['harga'] = hargaMarchendiseTextController.text;

    // kirim request ke API
    var streamedResponse = await request.send();

    // Ambil response dari API
    var response = await http.Response.fromStream(streamedResponse);

    // Kembalikan response dari API
    return jsonDecode(response.body);

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Tambah Marchendise",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 65.0,
          padding: const EdgeInsets.fromLTRB(15, 10, 12, 10),
          width: double.maxFinite,
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () async{
                // Ambil json dari API tambah marchendise
                var response_json = await tambahMarchendise();

                // Jika code 400, artinya ada nilai form yang tidak valid
                if(response_json['code'] == 400){
                  // Munculkan alert dengan hasil validasi dari API
                  Alert(
                    context: context,
                    style: const AlertStyle(
                      animationType: AnimationType.shrink
                    ),
                    type: AlertType.error,
                    title: "Tambah Barang Gagal",
                    desc: response_json['data'].values.toList()[0][0],
                    buttons: [
                      DialogButton(
                        color: Colors.red,
                        child: const Text(
                          "Okay",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ).show();
                }else {
                  // Munculkan alert bahwa tambah barang berhasil dan arahkan ke halaman home sesuai role user
                  Alert(
                    context: context,
                    style: const AlertStyle(
                      animationType: AnimationType.shrink
                    ),
                    type: AlertType.success,
                    title: "Tambah Barang Berhasil",
                    desc: "Marchendise berhasil ditambahkan",
                    buttons: [
                      DialogButton(
                        color: Colors.green,
                        child: const Text(
                          "Okay",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: () => Navigator.pushReplacementNamed(context, "/navbar")
                      )
                    ],
                  ).show();
                }
              }, 
              
              child: const Text(
                "Tambah",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[  
              const SizedBox(height: 15),

              Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nama Marchendise',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()
                      ),
                      controller: namaMarchendiseTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
      
                   TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Jenis (ex. Makanan, aksesoris, dll)',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()
                      ),
                      controller: jenisMarchendiseTextController,
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      controller: deskripsiMarchendiseTextController,
                      maxLines: null,
                    ),


                    const SizedBox(height: 20),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Harga',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()
                      ),
                      keyboardType: TextInputType.number,
                      controller: hargaMarchendiseTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                   

                    Container(
                      height: 48,
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green, width: 1),
                        ),
                        onPressed: () async {
                          // Mengambil file dari gallery
                          final ImagePicker _picker = ImagePicker();
                          final image = await _picker.pickImage(source: ImageSource.gallery);
                          
                          // Jika ada file yang diambil, ambil path dari gambarnya
                          if(image != null) {
                            setState(() {
                              uploadGmabarFile = image.path;
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(Icons.upload_rounded),
                            Text("Upload Gambar",style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
