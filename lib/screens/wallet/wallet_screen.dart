import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatefulWidget {
  final String token;

  WalletScreen({required this.token});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  bool isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _loadImageWithDelay();
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

  Future<void> _loadImageWithDelay() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isImageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userProfile == null
              ? Center(child: Text('Failed to load profile'))
              : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: Colors.white.withOpacity(0.15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Saldo',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/solana.png', width: 64.0, height: 64.0),
                                    Text(
                                      '${userProfile!['balance']} SOL',
                                      style: TextStyle(fontSize: 54, color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF000080),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        minimumSize: Size(100, 64),
                                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                      ),
                                      icon: Icon(Icons.arrow_upward, color: Colors.white),
                                      label: Text(
                                        'Kirim',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF000080),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        minimumSize: Size(100, 64),
                                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                      ),
                                      icon: Icon(Icons.arrow_downward, color: Colors.white),
                                      label: Text(
                                        'Terima',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(height: 32.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.0),
                        Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(color: Colors.black.withOpacity(0.15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Pemilik',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  userProfile!['name'],
                                  style: TextStyle(fontSize: 32, color: Colors.white),
                                ),
                                SizedBox(height: 16.0),
                                isImageLoaded
                                    ? Image.asset('assets/addres.png', width: 220,)
                                    : CircularProgressIndicator(),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF000080),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    minimumSize: Size(100, 50),
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                  ),
                                  child: Text(
                                    'Copy Alamat Dompet',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
    );
  }
}
