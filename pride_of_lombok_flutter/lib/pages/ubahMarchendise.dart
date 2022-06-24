import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:image_picker/image_picker.dart';

class UbahMarchendise extends StatefulWidget {
  @override
  State<UbahMarchendise> createState() => _UbahMarchendiseState();
}

class _UbahMarchendiseState extends State<UbahMarchendise> {

  // variable untuk nilai form
  var namaMarchendiseTextController = TextEditingController();
  var jenisMarchendiseTextController = TextEditingController();
  var deskripsiMarchendiseTextController = TextEditingController();
  var hargaMarchendiseTextController = TextEditingController();
  var uploadGmabarFile = '';

  // Fungsi untuk mengambil info marchendise berdasarkan id pada API
  getMerchendiseById (id) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-marchendise-by-id/"+id.toString()));
    return jsonDecode(response.body);
  }

  // Fungsi untuk mengubah suatu marchendise dengan API
  editMarchendise (id) async {
    // Ambil path dari file yang akan dikirim
    var filePath = uploadGmabarFile;

    // definisikan URL dari API
    var uri = Uri.parse('$baseURL/api/edit-marchendise/'+id.toString());

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
    // Ambil data dari paramater data halaman sebelumnya
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Marchendise",
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
              onPressed: () async {
                // Ambil json dari API edit marchendise
                var response_json = await editMarchendise(data['marchendiseId']);

                // Jika code 400, artinya ada nilai form yang tidak valid
                if(response_json['code'] == 400){
                  // Munculkan alert dengan hasil validasi dari API
                  Alert(
                    context: context,
                    style: const AlertStyle(
                      animationType: AnimationType.shrink
                    ),
                    type: AlertType.error,
                    title: "Update Barang Gagal",
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
                  // Munculkan alert bahwa edit barang berhasil dan arahkan ke halaman home sesuai role user
                  Alert(
                    context: context,
                    style: const AlertStyle(
                      animationType: AnimationType.shrink
                    ),
                    type: AlertType.success,
                    title: "Ubah Barang Berhasil",
                    desc: "Marchendise baru saja diupdate",
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
              child: Text(
                "Edit",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          // Bagian pada halaman ini akan dijalankan secara async dalam mengambil data marchendise dari API
          future: getMerchendiseById(data['marchendiseId']),
          builder: ((context,snapshot){
            if(snapshot.hasData){
              // Jika ada data yang didapat maka ambil data marchendise
              var marchendise = (snapshot.data as Map)['data'];

              // isi nilai field berdasarkan data marchendise
              namaMarchendiseTextController = TextEditingController(text: marchendise['nama']);
              jenisMarchendiseTextController = TextEditingController(text: marchendise['jenis']);
              deskripsiMarchendiseTextController = TextEditingController(text: marchendise['deskripsi']);
              hargaMarchendiseTextController = TextEditingController(text: marchendise['harga'].toString());
              
              // Tampilkan data marchendise saat ini pada halaman
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[      
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("$baseURL/images/marchendise/"+marchendise['gambar']),
                          fit: BoxFit.cover,
                        ),
                      )
                    ),
                  
                    SizedBox(height: 20),
            
                    Container(
                      height: 45,
                      child: OutlinedButton.icon(
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
            
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.0, color: Colors.green),
                        ),
                        
                        icon: Icon(
                          Icons.upload_rounded,
                          size: 24.0,
                        ),
                        label: Text('Upload Gambar'), // <-- Text
                      ),
                    ),
            
                    SizedBox(height: 20),
                  
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
                            controller: namaMarchendiseTextController
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                  
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Jenis',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()
                            ),
                            controller: jenisMarchendiseTextController
                          ),
            
                          SizedBox(height: 20),
            
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Deskripsi',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()
                            ),
                            controller: deskripsiMarchendiseTextController
                          ),
            
            
                          SizedBox(height: 20),
            
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Harga',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()
                            ),
                            controller: hargaMarchendiseTextController,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
