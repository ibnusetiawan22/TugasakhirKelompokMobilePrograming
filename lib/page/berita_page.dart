import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BeritaPage(),
    );
  }
}

class Berita {
  String judul;
  String deskripsi;
  bool disukai;
  String? catatan; // Menambahkan field catatan

  Berita(this.judul, this.deskripsi, this.disukai, {this.catatan});
}

class BeritaPage extends StatefulWidget {
  const BeritaPage({Key? key}) : super(key: key);

  @override
  _BeritaPageState createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  List<Berita> _listBerita = [
    Berita(
      "Sholat: Pilar Utama Kehidupan Muslim",
      "Sholat merupakan tiang agama Islam yang menghubungkan hamba dengan Tuhannya. Dilaksanakan lima kali sehari, sholat menanamkan disiplin, ketenangan, dan spiritualitas dalam kehidupan sehari-hari. Sebagaimana disebutkan dalam hadis, \"Sholat adalah tiang agama\" (HR. Ahmad).",
      false,
    ),
    Berita(
      "Makna dan Hikmah Sholat dalam Islam",
      "Sholat adalah ibadah wajib yang mengandung berbagai hikmah, termasuk ketenangan jiwa, kedisiplinan, dan peningkatan kualitas spiritual. Allah berfirman, \"Dan dirikanlah sholat untuk mengingat-Ku\" (QS. Thaha: 14).",
      false,
    ),
    Berita(
      "Sholat: Jalan Menuju Kedamaian Batin",
      "Sholat lima waktu merupakan sumber ketenangan dan kedamaian batin bagi setiap Muslim. Ibadah ini membantu merenungi kebesaran Allah, memperbaiki diri, dan mengurangi stres kehidupan sehari-hari. Allah berfirman, \"Sesungguhnya sholat itu mencegah dari perbuatan keji dan mungkar\" (QS. Al-Ankabut: 45).",
      false,
    ),
    Berita(
      "Sholat sebagai Refleksi Diri dan Kebersihan Hati",
      "Melalui sholat, umat Islam diajak untuk merenung dan membersihkan hati. Ibadah ini mengingatkan pentingnya introspeksi diri, keikhlasan, dan meningkatkan kedekatan dengan Sang Pencipta. Sebagaimana firman Allah, \"Sesungguhnya beruntunglah orang-orang yang beriman, yaitu orang-orang yang khusyu’ dalam sholatnya\" (QS. Al-Mu’minun: 1-2).",
      false,
    ),
    Berita(
      "Disiplin dan Kebersamaan dalam Sholat Berjamaah",
      "Sholat berjamaah di masjid mempererat tali silaturahmi dan membangun kebersamaan. Selain meningkatkan disiplin waktu, sholat berjamaah juga mengajarkan pentingnya kebersamaan dan kekompakan dalam beribadah. Rasulullah SAW bersabda, \"Sholat berjamaah lebih utama dari sholat sendirian dengan 27 derajat\" (HR. Bukhari dan Muslim).",
      false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _listBerita.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                color: Colors.transparent, // Set card color to transparent
                elevation: 0.0, // Remove elevation to avoid shadow
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                        0.7), // Set a background color with opacity
                    borderRadius:
                        BorderRadius.circular(8.0), // Add rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        title: Text(
                          _listBerita[index].judul,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(_listBerita[index].deskripsi),
                              SizedBox(height: 8.0),
                              if (_listBerita[index].catatan != null)
                                Text(
                                  "Catatan: ${_listBerita[index].catatan}",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite),
                            color: _listBerita[index].disukai
                                ? Colors.red
                                : Colors.grey,
                            onPressed: () {
                              setState(() {
                                _listBerita[index].disukai =
                                    !_listBerita[index].disukai;
                              });
                            },
                          ),
                          if (_listBerita[index].catatan == null)
                            IconButton(
                              icon: Icon(Icons.note_add),
                              onPressed: () {
                                _tambahCatatan(context, index);
                              },
                            ),
                          if (_listBerita[index].catatan != null)
                            IconButton(
                              icon: Icon(Icons.edit_attributes),
                              onPressed: () {
                                _editCatatan(context, index);
                              },
                            ),
                          if (_listBerita[index].catatan != null)
                            IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: () {
                                _hapusCatatan(index);
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _tambahCatatan(BuildContext context, int index) async {
    String? catatanBaru = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahCatatanPage()),
    );
    if (catatanBaru != null && catatanBaru.isNotEmpty) {
      setState(() {
        _listBerita[index].catatan = catatanBaru;
      });
    }
  }

  void _editCatatan(BuildContext context, int index) async {
    String? catatanLama = _listBerita[index].catatan;
    String? catatanBaru = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditCatatanPage(catatan: catatanLama)),
    );
    if (catatanBaru != null) {
      setState(() {
        _listBerita[index].catatan = catatanBaru;
      });
    }
  }

  void _hapusCatatan(int index) {
    setState(() {
      _listBerita[index].catatan = null;
    });
  }
}

class TambahCatatanPage extends StatefulWidget {
  @override
  _TambahCatatanPageState createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _controllerCatatan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controllerCatatan,
              decoration: InputDecoration(
                labelText: 'Catatan',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String catatanBaru = _controllerCatatan.text;
                Navigator.pop(context, catatanBaru);
              },
              child: Text('Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerCatatan.dispose();
    super.dispose();
  }
}

class EditCatatanPage extends StatefulWidget {
  final String? catatan;

  const EditCatatanPage({Key? key, required this.catatan}) : super(key: key);

  @override
  _EditCatatanPageState createState() => _EditCatatanPageState();
}

class _EditCatatanPageState extends State<EditCatatanPage> {
  late TextEditingController _controllerCatatan;

  @override
  void initState() {
    super.initState();
    _controllerCatatan = TextEditingController(text: widget.catatan ?? "");
  }

  @override
  void dispose() {
    _controllerCatatan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controllerCatatan,
              decoration: InputDecoration(
                labelText: 'Catatan',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String catatanBaru = _controllerCatatan.text;
                Navigator.pop(context, catatanBaru);
              },
              child: Text('Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}
