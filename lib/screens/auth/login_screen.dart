import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home_screen.dart';
import './register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await authService.login(
        emailController.text,
        passwordController.text,
      );

      // Arahkan ke HomeScreen setelah login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(token: response['token']),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Login', style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity, // Lebar penuh
        height: double.infinity, // Tinggi penuh
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // Gambar dari folder assets
            fit: BoxFit.cover, // Menutupi seluruh layar
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    
                // Text Username
                SizedBox(height: 16),
                Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.white
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8),
                    
                // Email
                Container(
                  padding: EdgeInsets.all(8), // Padding 16px
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                    
                // Text Password
                SizedBox(height: 16),
                Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.white
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8),
                    
                // Password
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
                    
                SizedBox(height: 16),
                isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity, // Lebar penuh (w-full)
                        child: ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 26), // Padding atas dan bawah lebih besar
                            backgroundColor: Color(0xFF000080), // Background putih
                            foregroundColor: Colors.white, // Teks hitam
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50), // Rounded-full
                            ),
                            minimumSize: Size(0, 48), // Menentukan tinggi minimal 48px
                          ),
                          child: Text('Login'),
                        ),
                      ),
                    
                // Text Password
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text('Belum punya akun? Daftar di sini', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                ),
            
                // Image
                SizedBox(height: 8),
                Image.asset('assets/ilustrasi.png', width: 390, height: 390,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
