import 'package:flutter/material.dart';
import 'package:pride_of_lombok_flutter/pages/login.dart';
import 'package:pride_of_lombok_flutter/pages/register.dart';
import 'package:pride_of_lombok_flutter/pages/home.dart';


void main() => runApp(MaterialApp(
  initialRoute: '/',
  
  routes : {
    '/' : (context) => Login(),
    '/register' : (context) => Register(),
    '/home' : (context) => Home()
  },

  theme: ThemeData(
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
  	),
  ),
));

