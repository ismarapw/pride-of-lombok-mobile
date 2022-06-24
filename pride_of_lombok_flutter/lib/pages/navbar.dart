import 'package:flutter/material.dart';
import 'package:pride_of_lombok_flutter/pages/home.dart';
import 'package:pride_of_lombok_flutter/pages/favorit.dart';
import 'package:pride_of_lombok_flutter/pages/riwayat.dart';
import 'package:pride_of_lombok_flutter/pages/profile.dart';
import 'package:pride_of_lombok_flutter/pages/admin.dart';
import 'package:pride_of_lombok_flutter/pages/pesanan.dart';
import 'package:pride_of_lombok_flutter/services/session.dart' as session;

class Navbar extends StatefulWidget {
  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  var currentIndex = 0;

  // Nungsi navbar untuk yang bukan admin (navbar pembeli)
  guestNavbar() {
    return BottomNavigationBar(
      onTap: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded),
          label: 'Fovorit',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin),
          label: 'Profile',
        ),
      ],
    );
  }


  // Fungsi navbar untuk admin
  adminNavbar(){
    return BottomNavigationBar(
      onTap: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_rounded),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin),
          label: 'Profile',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Halaman untuk pembeli
    var guestPages = [
      Home(),
      Favorit(),
      Riwayat(),
      Profile()
    ];

    // Halaman untuk admin
    var adminPages = [
      Admin(),
      Pesanan(),
      Profile()
    ];

    
    return Scaffold(
      // jika role user adalah admin maka akan menggunakan halaman admin, jika tidak maka gunakan halaman pembeli
      body: session.isAdmin == 1 ? adminPages[currentIndex] : guestPages[currentIndex],
      
      // jika role user adalah admin maka akan menggunakan navbar admin, jika tidak maka gunakan navbar pembeli
      bottomNavigationBar: session.isAdmin == 1 ? adminNavbar() : guestNavbar()
    );
  }
}