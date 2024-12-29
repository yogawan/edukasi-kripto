import 'package:flutter/material.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  final String courseTitle;
  final String courseDescription;

  CourseDetailScreen({
    required this.courseId,
    required this.courseTitle,
    required this.courseDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(courseTitle, style: TextStyle(color: Colors.white),),
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
              'Course Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              courseTitle,
              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.75)),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              courseDescription,
              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.75)),
            ),
          ],
        ),
      ),
    );
  }
}
