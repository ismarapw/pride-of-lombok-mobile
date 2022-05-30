import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map> myProducts =
      List.generate(10, (index) => {"id": index, "name": "Product $index"})
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hai Ismar.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
      
                    Text(
                      "Kuy cari oleh-oleh khas Lombok",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
      
                SizedBox(height: 20),
      
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Cari barang disini",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: (){},
                    ),
                  ),
                ),
      
                SizedBox(height: 20),
      
                Text(
                  "Marchendise Terbaru",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 15),

                
                GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.9,
                      mainAxisSpacing: 10
                  ),
                  itemCount: myProducts.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: (){print(myProducts[index]['name']);},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 95,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("/images/marchendise/anyaman_ketak.jpg"),
                                  fit: BoxFit.cover,
                                ),
                                 borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                            ),
                      
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 5, 0,0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    myProducts[index]['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                      
                                  Text(
                                    "anyaman",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54
                                    ),
                                  ),
                      
                                  Text(
                                    "Rp.200.000",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.w600
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                }),
              ],
            ),
          ),
        ),
      ),

       bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Fovorit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              label: 'Pembelian',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: 'Profile',
            ),
          ],
      ),
    );
  }
}