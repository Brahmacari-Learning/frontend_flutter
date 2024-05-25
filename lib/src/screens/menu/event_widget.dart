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
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Misi"),
              Tab(text: "Lencana"),
              Tab(text: "Tukar"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.infinity,
                  height: 100, 
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
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
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
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int i = 0; i < 5 ; i++)
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFDADADA),
                                    width: 1,
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
                                          width: 220,
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
                          ),
                        )
                      ],
                    ),
                  ) 
                ),
              ],
            ),
            Center(child: Text("Lencana")),
            Center(child: Text("Tukar")),
          ],
        ),
      ),
    );
  }
}