import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import './course/course_screen.dart';
import './news/news_screen.dart';
import './wallet/wallet_screen.dart';
import './crypto/crypto_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Daftar halaman untuk setiap tab
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      CourseScreen(token: widget.token),
      WalletScreen(token: widget.token),
      CryptoScreen(),
      CryptoNewsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Edukasi Crypto',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // Menghilangkan shadow
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black, // Latar belakang navigasi
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white.withOpacity(0.5), // Warna ikon tidak aktif
            activeColor: Colors.white, // Warna ikon aktif
            tabBackgroundColor: Color(0xFF000080), // Latar belakang tab aktif
            gap: 8, // Jarak antara ikon dan teks
            padding: EdgeInsets.all(16), // Padding tab
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped, // Ganti tab saat dipilih
            tabs: [
              GButton(
                icon: Icons.book,
                text: 'Kursus',
              ),
              GButton(
                icon: Icons.account_balance_wallet,
                text: 'Dompet',
              ),
              GButton(
                icon: Icons.attach_money,
                text: 'Koin',
              ),
              GButton(
                icon: Icons.newspaper,
                text: 'Berita',
              ),
            ],
          ),
        ),
      ),
    );
  }
}