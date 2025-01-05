import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import './course/course_screen.dart';
import './news/news_screen.dart';
import './wallet/wallet_screen.dart';
import './crypto/crypto_screen.dart';
import './auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      CourseScreen(token: widget.token),
      CryptoScreen(),
      CryptoNewsScreen(),
      WalletScreen(token: widget.token),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edukasi Crypto',
          style: TextStyle(color: Colors.white),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo.png',
            width: 40,
            height: 40,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white.withOpacity(0.5),
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xFF000080),
            gap: 8,
            padding: EdgeInsets.all(16),
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
            tabs: [
              GButton(
                icon: Icons.book,
                text: 'Kursus',
              ),
              GButton(
                icon: Icons.attach_money,
                text: 'Koin',
              ),
              GButton(
                icon: Icons.newspaper,
                text: 'Berita',
              ),
              GButton(
                icon: Icons.account_balance_wallet,
                text: 'Dompet',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
