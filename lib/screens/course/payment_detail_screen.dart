import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String courseTitle;
  final double coursePrice;
  final Future<void> Function() onConfirm;

  PaymentScreen({
    required this.courseTitle,
    required this.coursePrice,
    required this.onConfirm,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;

  Future<void> _handleConfirm() async {
    setState(() {
      isLoading = true;
    });
    try {
      await widget.onConfirm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
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
        title: Text('Konfirmasi Pembayaran', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Course Name: ${widget.courseTitle}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Image.asset('assets/solana.png', width: 32, height: 32,),
                Text(
                  '${widget.coursePrice} SOL',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(
              color: Colors.white.withOpacity(0.15), // Warna putih dengan 15% opacity
              thickness: 1, // Ketebalan border (1px)
              height: 1, // Menghilangkan ruang vertikal tambahan
            ),
            SizedBox(height: 16),
            Text(
              'Confirm Purchase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: double.infinity, // Lebar penuh (w-full)
                height: 54, // Tinggi 24px (h-[24px])
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF000080), // Background #000080
                    foregroundColor: Colors.white, // Teks putih
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50), // Rounded-full
                    ),
                    elevation: 0, // Menghilangkan shadow tombol (opsional)
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white, // Warna indikator putih
                            strokeWidth: 2, // Ketebalan garis indikator
                          ),
                        )
                      : Text(
                          'Konfirmasi Pembayaran',
                          style: TextStyle(fontSize: 12), // Ukuran teks sesuai tinggi tombol
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
