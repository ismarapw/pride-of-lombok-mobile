import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              "Register",
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
                    decoration: InputDecoration(
                      labelText:"Masukkan Email",
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
                        
                      }, 
                      child: Text("Register",style: TextStyle(fontSize: 16)),
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
                        "Sudah punya akun?",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),

                      TextButton(
                        onPressed: (){
                          Navigator.pushNamed(context, "/");
                        }, 
                        child:  Text(
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