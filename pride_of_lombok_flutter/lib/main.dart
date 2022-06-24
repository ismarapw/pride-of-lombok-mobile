import 'package:flutter/material.dart';
import 'package:pride_of_lombok_flutter/pages/login.dart';
import 'package:pride_of_lombok_flutter/pages/navbar.dart';
import 'package:pride_of_lombok_flutter/pages/register.dart';
import 'package:pride_of_lombok_flutter/pages/detail.dart';
import 'package:pride_of_lombok_flutter/pages/tambahMarchendise.dart';
import 'package:pride_of_lombok_flutter/pages/ubahMarchendise.dart';
import 'package:pride_of_lombok_flutter/pages/bayar.dart';
import 'package:pride_of_lombok_flutter/pages/preview.dart';
import 'package:pride_of_lombok_flutter/pages/pencarian.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  
  routes : {
    '/' : (context) => Login(),
    '/navbar' : (context) => Navbar(),
    '/register' : (context) => Register(),
    '/detail' : (context) => Detail(),
    '/tambahMarchendise' : (context) => TambahMarchendise(),
    '/ubahMarchendise' : (context) => UbahMarchendise(),
    '/bayar' : (context) => Bayar(),
    '/preview' : (context) => Preview(),
    '/pencarian' : (context) => Pencarian(),    
  },

  theme: ThemeData(
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.green,
  	),
    scaffoldBackgroundColor: Colors.white
  ),
));

