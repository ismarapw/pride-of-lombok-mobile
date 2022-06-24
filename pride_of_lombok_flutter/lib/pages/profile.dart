import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';
import 'package:pride_of_lombok_flutter/services/session.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // variable untuk nilai form
  var usernameTextController = TextEditingController();
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();

  // Fungsi untuk mengambil data user dengan API
  getUser(id) async {
    var response =  await http.get(Uri.parse("$baseURL/api/get-user/$id"));
    return jsonDecode(response.body);
  }

  // Fungsi untuk mengubah data user dengan API
  editProfile(idUser) async {
    // Ambil Data dari setiap field form 
    var data = {
      "username" : usernameTextController.text,
      "email": emailTextController.text,
      "password" : passwordTextController.text
    };

    // Kirim request dengan method Post dari data form
    var response = await http.post(
      Uri.parse("$baseURL/api/edit-profile/"+idUser.toString()),
      body: json.encode(data),
      headers: {
        'Content-type' : 'application/json',
        'Accept' : 'application/json'
      }
    );

    // Kembalikan nilai json
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: (
                    Text(
                      "Edit Profile", 
                      style: TextStyle(
                        color:Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                      )
                    )
                  ),
                ),
        
                SizedBox(height: 20),
        
                FutureBuilder(
                  // Ambil data user dengan async pada API
                  future: getUser(globals.userId),
                  builder: ((context,snapshot){
                    if(snapshot.hasData){
                      // Jika ada data user yang didapat, maka ambil data user
                      var user = (snapshot.data as Map)['data'];

                      // isi nilai pada form sesuai dengan data user dari DB/API
                      usernameTextController = TextEditingController(text: user['username']);
                      emailTextController = TextEditingController(text: user['email']);
                      passwordTextController = TextEditingController(text: '');

                      // tampilkan form user
                      return Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 55,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                                  ),
                                  border: OutlineInputBorder()
                                ),
                                controller: usernameTextController,
                              ),
                            ),
                          
                            const SizedBox(
                              height: 20,
                            ),
                            
                            Container(
                              height: 55,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                                  ),
                                  border: OutlineInputBorder()
                                ),
                                controller: emailTextController,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          
                            Container(
                              height: 55,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                controller: passwordTextController, 
                                obscureText: true,
                              ),
                              
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    }else{
                      // tampilkan loading selama proses pengambilan data dari API
                      return Center (
                        child: CircularProgressIndicator()
                      );
                    }
                  }),
                ),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: ()async
                          {
                            // edit profile dari user dengan API
                            var response_json = await editProfile(globals.userId); 

                             // Jika code 400, artinya ada nilai form yang tidak valid
                            if(response_json['code'] == 400){
                              // Munculkan alert dengan hasil validasi dari API
                              Alert(
                                context: context,
                                style: const AlertStyle(
                                  animationType: AnimationType.shrink
                                ),
                                type: AlertType.error,
                                title: "Edit Profile Gagal",
                                desc: response_json['data'].values.toList()[0][0],
                                buttons: [
                                  DialogButton(
                                    color: Colors.red,
                                    child: const Text(
                                      "Okay",
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ).show();
                            }else {
                              // Munculkan alert bahwa registrasi berhasil dan refresh halaman edit profile
                              Alert(
                                context: context,
                                style: const AlertStyle(
                                  animationType: AnimationType.shrink
                                ),
                                type: AlertType.success,
                                title: "Edit Profile Berhasil",
                                desc: "Data kamu sudah diperbaharui",
                                buttons: [
                                  DialogButton(
                                    color: Colors.green,
                                    child: const Text(
                                      "Okay",
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
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
              
                    SizedBox(width: 10),  
              
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red
                          ),
                          onPressed: (){
                            Alert(
                                context: context,
                                style: const AlertStyle(
                                  animationType: AnimationType.shrink
                                ),
                                type: AlertType.warning,
                                title: "Konfirmasi Logout",
                                desc: "Kamu yakin mau keluar?",
                                buttons: [
                                  DialogButton(
                                    color: Colors.red,
                                    child: const Text(
                                      "Yakin",
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context, "/");;
                                    },
                                  ),
                                  DialogButton(
                                    color: Colors.grey,
                                    child: const Text(
                                      "Batal",
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ).show();
                            
                          }, 
                          child: Text(
                            "Logout",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
