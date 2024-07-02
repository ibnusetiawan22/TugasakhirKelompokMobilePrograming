import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:bacaansholat/model/model_dzikir.dart';

class DzikirPage extends StatefulWidget {
  const DzikirPage({Key? key}) : super(key: key);

  @override
  _DzikirPageState createState() => _DzikirPageState();
}

class _DzikirPageState extends State<DzikirPage> {
  Future<List<ModelDzikir>> readJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/data/dzikir.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => ModelDzikir.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dzikir'),
      ),
      backgroundColor: Color.fromARGB(255, 0, 170, 255),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromARGB(255, 174, 215, 241),
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/kalig_rafi.png',
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Kumpulan Dzikir Harian",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Kumpulan dzikir sehari-hari",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                child: FutureBuilder(
                  future: readJsonData(),
                  builder:
                      (context, AsyncSnapshot<List<ModelDzikir>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      var items = snapshot.data!;
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(15),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                title: Text(
                                  items[index].name!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: Text(
                                            items[index].arabic!,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: Text(
                                            "Terjemahan: " +
                                                items[index].terjemahan!,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
