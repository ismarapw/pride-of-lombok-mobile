import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pride_of_lombok_flutter/services/session.dart' as session;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pride_of_lombok_flutter/services/baseURL.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // variable untuk nilai form
  var usernameTextController = TextEditingController();
  var passwordTextController = TextEditingController();

   // Fungsi login via API
  login() async {
    // Ambil Data dari setiap field form 
    var data = {
      'username' : usernameTextController.text,
      'password' : passwordTextController.text
    };

    // Kirim request dengan method Post dari data form
    var response = await http.post(
      Uri.parse(baseURL+"/api/login"),
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset : false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:5,horizontal :25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/logo/logo.png",
                  width: 37,
                  height: 32,
                ),

                SizedBox(width: 5),

                Text(
                  "Pride of Lombok",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),

            SizedBox(height:20),

            Text(
              "Login",
              style: TextStyle (
                fontSize: 18,
                color: Colors.black54,
              ),            
            ),

            SizedBox(height:30),

            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Masukkan Username",
                      border: OutlineInputBorder()
                    ),
                    controller: usernameTextController,
                  ),

                  SizedBox(height: 25),

                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText:"Masukkan Password",
                      border: OutlineInputBorder()
                    ),
                    controller: passwordTextController,
                  ),

                  SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async{
                        // ambil hasil json dari fungsi login
                        var response_json = await login();

                        // Jika code 400, artinya ada nilai form yang tidak valid
                        if(response_json['code'] == 400){
                          // Munculkan alert dengan hasil validasi dari API
                          Alert(
                            context: context,
                            style: const AlertStyle(
                              animationType: AnimationType.shrink
                            ),
                            type: AlertType.error,
                            title: "Login Gagal",
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
                          // Munculkan alert bahwa registrasi berhasil dan arahkan ke halaman utama sesuai role user
                          Alert(
                            context: context,
                            style: const AlertStyle(
                              animationType: AnimationType.shrink
                            ),
                            type: AlertType.success,
                            title: "Login Berhasil",
                            desc: "Selamat datang Kembali",
                            buttons: [
                              DialogButton(
                                color: Colors.green,
                                child: const Text(
                                  "Okay",
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                onPressed: () {
                                  // Ambil id, dan role user sebagai session
                                  session.userId = response_json['data']['id'];
                                  session.isAdmin = response_json['data']['is_admin'];

                                  // arahkan ke halaman utama sesuai role user
                                  Navigator.pushReplacementNamed(context, '/navbar');
                                } ,
                              )
                            ],
                          ).show();
                        }


                      }, 
                      child: Text("Login",style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Belum punya akun?",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, "/register");
                        }, 
                        child:  Text(
                          "Daftar",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}