import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Detail Marchendise",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),

      body:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("/images/marchendise/anyaman_ketak.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 10),

            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 10,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Anyaman Ketak",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: (){}, 
                        icon: Icon(Icons.favorite_border)
                      )
                    ],
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Anyaman",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black54
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Deskripsi",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.green
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Kamu mempunyai masalah dengan berat badan, kamu yakin tidak mau operasi perut, gas operasi sebelum terlambat, sakit itu g enak looo, sekarang banyak diskon gede-gedean hingga 99.999%. Buruan jangan sampai terlewat ",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),          
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 65.0,
          padding: EdgeInsets.fromLTRB(15, 8, 12, 5),
          width: double.maxFinite,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Rp.450.000",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepOrange
                  ),
                ),
              ),

              SizedBox(
                width: 155,
                height: 45,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/bayar');
                  }, 
                  child: Text(
                    "Beli Langsung",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}