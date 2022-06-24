import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pride_of_lombok_flutter/services/baseURL.dart';



class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // variable untuk nilai form
  var usernameTextController = TextEditingController();
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();

  // Fungsi registrasi via API
  register () async {
    // Ambil Data dari setiap field form 
    var data = {
      'username' : usernameTextController.text,
      'email' : emailTextController.text,
      'password' : passwordTextController.text
    };

    // Kirim request dengan method Post dari data form
    var response = await http.post(
      Uri.parse(baseURL+"/api/register"),
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

                const SizedBox(width: 5),

                const Text(
                  "Pride of Lombok",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),

            const SizedBox(height:20),

            const Text(
              "Register",
              style: TextStyle (
                fontSize: 18,
                color: Colors.black54,
              ),            
            ),

            const SizedBox(height:30),

            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Masukkan Username",
                      border: OutlineInputBorder()
                    ),
                    controller: usernameTextController,
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText:"Masukkan Email",
                      border: OutlineInputBorder()
                    ),
                    controller: emailTextController,
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText:"Masukkan Password",
                      border: OutlineInputBorder()
                    ),
                    controller: passwordTextController,
                  ),

                  const SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: ()async{
                        // ambil hasil json dari fungsi register
                        var response_json = await register();

                        // Jika code 400, artinya ada nilai form yang tidak valid
                        if(response_json['code'] == 400){
                          // Munculkan alert dengan hasil validasi dari API
                          Alert(
                            context: context,
                            style: const AlertStyle(
                              animationType: AnimationType.shrink
                            ),
                            type: AlertType.error,
                            title: "Registrasi Gagal",
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
                          // Munculkan alert bahwa registrasi berhasil dan arahkan ke halaman login
                          Alert(
                            context: context,
                            style: const AlertStyle(
                              animationType: AnimationType.shrink
                            ),
                            type: AlertType.success,
                            title: "Registrasi Berhasil",
                            desc: "Silahkan login terlebih dahulu",
                            buttons: [
                              DialogButton(
                                color: Colors.green,
                                child: const Text(
                                  "Okay",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                // arahkan ke halaman login
                                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                              )
                            ],
                          ).show();
                        }
                    
                      }, 
                      child: const Text("Register",style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Sudah punya akun?",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, "/");
                        }, 
                        child:  const Text(
                          "Login",
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