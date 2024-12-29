import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format harga
import 'package:app/services/api_service.dart';

class CryptoScreen extends StatefulWidget {
  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _cryptoList = [];
  bool _isLoading = true;

  // Fungsi untuk memformat angka ke format dolar
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US', // Format untuk US
      symbol: '\$',    // Simbol dolar
      decimalDigits: 0, // Tidak ada angka desimal
    );
    return formatter.format(amount);
  }

  @override
  void initState() {
    super.initState();
    _fetchCryptoData();
  }

  Future<void> _fetchCryptoData() async {
    final data = await _apiService.fetchCryptoListings();
    setState(() {
      _cryptoList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cryptoList.length,
              itemBuilder: (context, index) {
                final crypto = _cryptoList[index];
                final rank = crypto['cmc_rank']; // Ambil rank
                final symbol = crypto['symbol']; // Ambil symbol
                final name = crypto['name'];     // Ambil name
                final price = crypto['quote']['USD']['price']; // Ambil harga asli
                final formattedPrice = formatCurrency(price); // Format harga

                return ListTile(
                  leading: Image.asset('assets/solana.png', width: 32, height: 32,),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '$symbol ($name)', // Menampilkan simbol dan nama
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Price: $formattedPrice', // Menampilkan harga
                            style: const TextStyle( color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        'Rank $rank', // Menampilkan rank
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold, color: Colors.white
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
