import 'package:flutter/material.dart';
import './login_screen.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void register() async {
    setState(() {
      isLoading = true;
    });

    try {
      await authService.register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
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
        title: Text('Register', style: TextStyle(color: Colors.white),),
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
                // Text Name
                SizedBox(height: 16),
                Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.white
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8),
                    
                // Name
                Container(
                  padding: EdgeInsets.all(8), // Padding 16px
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                    
                // Text Email
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
                  padding: EdgeInsets.all(8), // Padding 16px
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
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 26), // Padding atas dan bawah lebih besar
                            backgroundColor: Color(0xFF000080), // Background putih
                            foregroundColor: Colors.white, // Teks hitam
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50), // Rounded-full
                            ),
                            minimumSize: Size(0, 48), // Menentukan tinggi minimal 48px
                          ),
                          child: Text('Register'),
                        ),
                      ),
                    
                // Text Switch
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: Text('Sudah punya akun? Login di sini', style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                ),
            
                // Image
                SizedBox(height: 8),
                Image.asset('assets/ilustrasi.png')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
