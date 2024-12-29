import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  final String token;

  WalletScreen({required this.token});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/user/profile'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          userProfile = json.decode(response.body);
          isLoading = false;
        });
      } else {
        debugPrint('Failed to fetch profile. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch profile');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch profile')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userProfile == null
              ? Center(child: Text('Failed to load profile'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Saldo
                      SizedBox(height: 8),
                      Text(
                        'Saldo',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/solana.png', width: 64.0, height: 64.0,),
                          Text(
                            '${userProfile!['balance']} SOL',
                            style: TextStyle(fontSize: 54, color: Colors.white),
                          ),
                        ],
                      ),

                      // Button kirim dan terima
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Membagi tombol secara merata
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Fungsi untuk tombol Kirim
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF000080), // Warna tombol Kirim
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100), // Sudut bulat
                              ),
                              minimumSize: Size(100, 64), // Ukuran minimal (lebar x tinggi)
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Padding tombol
                            ),
                            child: Text(
                              'Kirim',
                              style: TextStyle(color: Colors.white), // Teks putih
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Fungsi untuk tombol Terima
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF000080), // Warna tombol Terima
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100), // Sudut bulat
                              ),
                              minimumSize: Size(100, 64), // Ukuran minimal (lebar x tinggi)
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Padding tombol
                            ),
                            child: Text(
                              'Terima',
                              style: TextStyle(color: Colors.white), // Teks putih
                            ),
                          ),
                        ],
                      ),

                      // Pemilik dan Addres
                      SizedBox(height: 44),
                      Column(
                        children: [
                          Text(
                            'Pemilik',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            userProfile!['name'],
                            style: TextStyle(fontSize: 32, color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Fungsi untuk tombol Terima
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF000080), // Warna tombol Terima
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100), // Sudut bulat
                              ),
                              minimumSize: Size(100, 50), // Ukuran minimal (lebar x tinggi)
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Padding tombol
                            ),
                            child: Text(
                              'Copy Alamat Dompet',
                              style: TextStyle(color: Colors.white), // Teks putih
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _logout();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Warna tombol Login
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100), // Sudut bulat
                              ),
                              minimumSize: Size(100, 50), // Ukuran minimal (lebar x tinggi)
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Padding tombol
                            ),
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.white), // Teks putih
                            ),
                          ),
                        ],
                      ),
 
                    ],
                  ),
                ),
    );
  }
}
