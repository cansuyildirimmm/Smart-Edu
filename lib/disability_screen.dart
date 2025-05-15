import 'package:flutter/material.dart';
import 'package:smartedu/result_screen.dart';

void main() => runApp(MaterialApp(home: DisabilityScreen()));

class DisabilityScreen extends StatefulWidget {
  @override
  State<DisabilityScreen> createState() => _DisabilityScreenState();
}

class _DisabilityScreenState extends State<DisabilityScreen> {
  String? selectedOption;

  final List<String> options = [
    "Görme Engeli",
    "İşitme Engeli",
    "Fiziksel Engel",
    "Dikkat Eksikliği / Hiperaktivite",
    "Öğrenme Güçlüğü",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1FF),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF318FFF), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () {},
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Test Soru Ekranı",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Engel Durumunuzu Seçin",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                ...options.map((option) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF318FFF)),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: selectedOption,
                          activeColor: Color(0xFF318FFF),
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen()),
    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF318FFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    elevation: 4,
                  ),
                  child: Text(
                    "Testi Sonlandır",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
