import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <-- 1. Import library Supabase
import 'formPrediksi.dart';
import 'historyPage.dart';
import 'infoDataset.dart';

void main() async {
  // 2. Pastikan binding Flutter siap sebelum proses async running
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Inisialisasi Supabase menggunakan credentials kelompokmu
  await Supabase.initialize(
    url: 'https://nevlyovrnwfwktdqtmqg.supabase.co',
    anonKey: 'sb_publishable_xwy01rlsAWFE2e4CcpOz5w_JpG2Ry_-',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS ML Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8FAFA),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai tab yang dipilih
  final List<Widget> _pages = [
    PredictPage(),
    HistoryPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF26A69A),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Predict'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Info'),
        ],
      ),
    );
  }
}