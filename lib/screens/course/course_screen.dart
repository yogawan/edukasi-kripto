import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'payment_detail_screen.dart';
import 'course_detail_screen.dart';

class CourseScreen extends StatefulWidget {
  final String token;

  CourseScreen({required this.token});

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  List<dynamic> courses = [];
  Set<String> purchasedCourses = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/courses'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedCourses = json.decode(response.body);
        setState(() {
          courses = fetchedCourses;
        });
      } else {
        debugPrint('Failed to load courses. Status code: ${response.statusCode}');
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      debugPrint('Error fetching courses: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch courses')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _processPayment(String courseId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/balance/buy'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({'courseId': courseId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          purchasedCourses.add(courseId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course purchased successfully')),
        );
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Insufficient balance')),
        );
        Navigator.pop(context);
      } else {
        debugPrint('Failed to process payment. Status code: ${response.statusCode}');
        throw Exception('Failed to process payment');
      }
    } catch (e) {
      debugPrint('Error processing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment')),
      );
    }
  }

  void _navigateToPaymentScreen(
      String courseId, String courseTitle, double coursePrice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          courseTitle: courseTitle,
          coursePrice: coursePrice,
          onConfirm: () => _processPayment(courseId),
        ),
      ),
    );
  }

  void _viewCourse(String courseId, String courseTitle, String courseDescription) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailScreen(
          courseId: courseId,
          courseTitle: courseTitle,
          courseDescription: courseDescription,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : courses.isEmpty
              ? Center(child: Text('No courses available'))
              : ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final isPurchased = purchasedCourses.contains(course['_id']);
                    return CourseItem(
                      course: course,
                      isPurchased: isPurchased,
                      onBuy: () => _navigateToPaymentScreen(
                        course['_id'],
                        course['title'],
                        (course['price'] ?? 0).toDouble(),
                      ),
                      onView: () => _viewCourse(
                        course['_id'],
                        course['title'],
                        course['description'] ?? 'No description available',
                      ),
                    );
                  },
                ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isPurchased;
  final VoidCallback onBuy;
  final VoidCallback onView;

  const CourseItem({
    Key? key,
    required this.course,
    required this.isPurchased,
    required this.onBuy,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursePrice = course['price'] ?? 0; // Harga course, default 0 jika tidak tersedia
    return Card(
      color: Colors.black, // Background hitam
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // Radius sudut kartu
        side: BorderSide(color: Colors.white.withOpacity(0.15), width: 1), // Border black/15
      ),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title'] ?? 'Untitled Course',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Teks putih
              ),
            ),
            SizedBox(height: 4),
            Text(
              course['description'] ?? 'No description available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7), // Teks putih dengan transparansi
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Image.asset('assets/solana.png', width: 32.0, height: 32,),
                Text(
                  '${coursePrice} SOL',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Teks putih
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity, // Lebar penuh (w-full)
              height: 54, // Tinggi 24px (h-[24px])
              child: ElevatedButton(
                onPressed: isPurchased ? onView : onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF000080), // Background #000080
                  foregroundColor: Colors.white, // Teks putih
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100), // Rounded-full
                  ),
                ),
                child: Text(
                  isPurchased ? 'Lihat Course' : 'Beli Course',
                  style: TextStyle(fontSize: 12), // Teks lebih kecil agar pas
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
