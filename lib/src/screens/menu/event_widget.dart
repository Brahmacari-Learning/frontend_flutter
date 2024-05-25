import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({super.key});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFDA94FA),
          elevation: 0,
          toolbarHeight: 0,
          bottom: const TabBar(
            labelColor: Colors.white, 
            unselectedLabelColor: Colors.grey, 
            indicatorColor: Colors.white, 
            tabs: [
              Tab(text: "Misi"),
              Tab(text: "Lencana"),
              Tab(text: "Tukar"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Rahian
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.infinity,
                  
                  color: Color(0xFFDA94FA), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rahianmu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        
                      ),
                      Row(
                        children: [
                          Image.asset(
                            fit: BoxFit.fill,
                            'lib/assets/images/star.png',
                            width: 40,
                            height: 40,
                          ),
                          const Text(
                            '25',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Image.asset(
                            fit: BoxFit.fill,
                            'lib/assets/images/medal.png',
                            width: 40,
                            height: 40,
                          ),
                          const Text(
                            '4',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Presensi Harian",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.start
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.62,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF9095A0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "1/20",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700
                                        )
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    fit: BoxFit.fill,
                                    'lib/assets/images/icons/time.png',
                                    width: 60,
                                    height: 60,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),  
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 20),
                          Text(
                            "Misi Harian",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                          Column(
                            children: [
                              for (int i = 0; i < 5 ; i++)
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFDADADA),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      fit: BoxFit.fill,
                                      'lib/assets/images/icons/misi.png',
                                      width: 80,
                                      height: 80,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Selesaikan 15 Kuis",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          height: 32,
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('lib/assets/images/indikator_misi.png'), 
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(right: 20),
                                              child: Text(
                                                "1/ 20",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400
                                                )
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ) 
                ),
              ],
            ),
            // Lencana
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 20 ; i++)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          width: 345,
                          padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFFF1C40F),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, -2),
                                blurRadius: 7,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3), // Border width
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF8504), // Border color
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage('lib/assets/images/icons/misi.png'),
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 170),
                                    child: Text(
                                      "Si Pintar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 200),
                                    child: Text(
                                      "Menyelesaikan Semua Kuis Pada Map 1 asd ads asd ASZ das aSD",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                    ),
                                  ),
                                  
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 50, left: 10),
                                child: Image.asset(
                                  fit: BoxFit.fill,
                                  'lib/assets/images/icons/star.png',
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            //Tukar
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 20 ; i++)
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          width: 345,
                          padding: EdgeInsets.symmetric(vertical: 10 , horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF9BD2FC),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, -2),
                                blurRadius: 7,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3), // Border width
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF8504), // Border color
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage('lib/assets/images/user2.png'),
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 140),
                                    child: Text(
                                      "Kalender Bali asdas asdasdas",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        fit: BoxFit.fill,
                                        'lib/assets/images/star.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                      const Text(
                                        '25',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 15),
                              ElevatedButton(
                                onPressed: ()  {
                                
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  backgroundColor: Color(0xFFF1C40F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Atur radius sudut di sini
                                  ),
                                ),
                                child: Text(
                                  "Tukar",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFFFFFFFF),
                                    fontWeight: FontWeight.w900
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}