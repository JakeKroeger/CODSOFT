import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 242, 210),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center items horizontally
          children: <Widget>[
            Image.asset(
              'assets/images/SplashScreenImage.jpg',
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 30),

            // ----------------Title Text----------------
            Text(
              'Manage Your',
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center, // Center text
            ),
            Text(
              'Everyday task list',
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center, // Center text
            ),
            const SizedBox(height: 20),

            // Lorem ipsum Text
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Add padding to sides
              child: Text(
                'lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center, // Center text
              ),
            ),
            const SizedBox(height: 50),

            // ----------------Elevated button----------------
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[200], // Set background color
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15), // Add padding to button
                textStyle: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
