import 'package:flutter/material.dart';
import 'dart:async'; // Import dart:async untuk menggunakan Timer
import 'main_screen.dart'; // Import layar utama

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    const duration = Duration(
        milliseconds: 500); // Menggunakan milliseconds untuk interval 0.7 detik
    Timer.periodic(duration, (Timer timer) {
      setState(() {
        if (_progressValue >= 0.5) {
          // Memeriksa jika progress mencapai atau melewati 0.7
          timer.cancel();
          _navigateToMainScreen();
        } else {
          _progressValue +=
              0.2; // Menambah progress sebesar 0.2 setiap 0.7 detik
        }
      });
    });
  }

  void _navigateToMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 130, 219, 1.0),// Warna latar belakang biru
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Image.asset(
                  'images/call3.png', // Path gambar Anda
                  width: 150, // Ukuran gambar
                  height: 150,
                ),
              ),
            ),
            SizedBox(height: 20), // Jarak antara gambar dan teks "Loading..."
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(
                height: 10), // Jarak antara teks "Loading..." dan progress bar
            LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: const Color.fromARGB(
                  255, 39, 134, 211), // Warna latar belakang abu-abu
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 255, 255, 255)), // Warna merah untuk value
            ),
            SizedBox(height: 20), // Jarak tambahan setelah progress bar
          ],
        ),
      ),
    );
  }
}
