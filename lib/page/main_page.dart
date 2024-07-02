import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import '../model/prayer_times.dart';
import '../services/prayer_times_service.dart';
import 'package:bacaansholat/page/berita_page.dart';
import 'package:bacaansholat/page/bacaan_sholat_page.dart';
import 'package:bacaansholat/page/niat_sholat_page.dart';
import 'package:bacaansholat/page/dzikir_page.dart';
import 'package:bacaansholat/page/doa_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<PrayerTimes> futurePrayerTimes;
  late Timer _timer;
  DateTime _currentDateTime = DateTime.now();
  late String locationName = 'Tegal'; // Lokasi default
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getLocationAndFetchPrayerTimes();
    _startClock();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startClock() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
  }

  Future<void> _getLocationAndFetchPrayerTimes() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      futurePrayerTimes = PrayerTimesService()
          .fetchPrayerTimes(_locationData.latitude!, _locationData.longitude!);
      locationName =
          'Tegal'; // Ganti dengan nama lokasi yang diperoleh dari layanan geolokasi
    });
  }

  void _refreshLocation() {
    _getLocationAndFetchPrayerTimes();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NiatSholat(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BacaanSholat(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BeritaPage(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DzikirPage(),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoaPage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMMM yyyy').format(_currentDateTime);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text(
            'Sadulur Islam',
            style: TextStyle(
              fontFamily: 'aAwalRamadhan',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed:
                  _refreshLocation, // Panggil fungsi untuk memperbarui lokasi
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Text(
                  'Perbarui Lokasi',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/mosque_vektor.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontFamily: 'aAwalRamadhan',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${_currentDateTime.hour.toString().padLeft(2, '0')}:${_currentDateTime.minute.toString().padLeft(2, '0')}:${_currentDateTime.second.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontFamily: 'TheNextFont',
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(251, 0, 8, 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<PrayerTimes>(
                    future: futurePrayerTimes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Waktu Sholat di $locationName',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'TheNextFont',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 24, 0, 0),
                                  ),
                                ),
                                SizedBox(height: 10),
                                _buildPrayerTimeRow('Fajr', snapshot.data!.fajr,
                                    Icons.wb_sunny),
                                _buildPrayerTimeRow('Dhuhr',
                                    snapshot.data!.dhuhr, Icons.wb_sunny),
                                _buildPrayerTimeRow(
                                    'Asr', snapshot.data!.asr, Icons.wb_sunny),
                                _buildPrayerTimeRow('Maghrib',
                                    snapshot.data!.maghrib, Icons.brightness_2),
                                _buildPrayerTimeRow('Isha', snapshot.data!.isha,
                                    Icons.brightness_3),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Image.asset("assets/images/ic_niat.png", height: 30, width: 30),
            label: 'Niat Sholat',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset("assets/images/ic_doa.png", height: 30, width: 30),
            label: 'Bacaan Sholat',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/ic_bacaan.png",
                height: 30, width: 30),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon:
                Image.asset("assets/images/ic_doa.png", height: 30, width: 30),
            label: 'Dzikir',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildPrayerTimeRow(
      String prayerName, String prayerTime, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: Colors.blueAccent,
              ),
              SizedBox(width: 10),
              Text(
                prayerName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            prayerTime,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Amiri',
            ),
          ),
        ],
      ),
    );
  }
}
