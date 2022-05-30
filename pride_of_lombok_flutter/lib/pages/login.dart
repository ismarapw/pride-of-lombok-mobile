import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
                  "/images/logo/logo.png",
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
                  ),

                  SizedBox(height: 25),

                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText:"Masukkan Password",
                      border: OutlineInputBorder()
                    ),
                  ),

                  SizedBox(height: 25),

                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context,'/home');
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