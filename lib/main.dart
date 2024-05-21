import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String apiUrl = 'https://api.openai.com/v1/engines/davinci/completions';
  final String apiKey = 'YOUR_API_KEY'; // Buraya kendi API anahtarınızı ekleyin

  Future<String> fetchCompletion(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['choices'][0]['text'];
    } else {
      throw Exception('Failed to load response');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Butonlar Ekranı'),
        ),
        body: ButtonGrid(),
      ),
    );
  }
}

class ButtonGrid extends StatefulWidget {
  @override
  _ButtonGridState createState() => _ButtonGridState();
}

class _ButtonGridState extends State<ButtonGrid> {
  List<String> buttonNames = [
    'Fizik',
    'Kimya',
    'Biyoloji',
    'Sanat',
    'Spor',
    'Matematik',
    'Edebiyat',
    'Müzik',
    'Tarih',
    'Sosyoloji'
  ];

  Map<String, String> buttonInfo = {
    'Fizik': 'Fizik, madde ve enerjinin doğasını ve özelliklerini inceleyen bir bilim dalıdır.',
    'Kimya': 'Kimya, maddelerin bileşimini, yapısını ve değişimlerini inceleyen bilimdir.',
    'Biyoloji': 'Biyoloji, canlı organizmaların yaşam süreçlerini inceleyen bilim dalıdır.',
    'Sanat': 'Sanat, yaratıcılığı ve hayal gücünü ifade eden bir etkinliktir.',
    'Spor': 'Spor, fiziksel aktiviteler ve oyunlar yoluyla bedensel gelişimi hedefleyen etkinliklerdir.',
    'Matematik': 'Matematik, sayıların, şekillerin ve mantıksal analizlerin bilimidir.',
    'Edebiyat': 'Edebiyat, yazılı eserler aracılığıyla insan deneyimini ifade eden sanattır.',
    'Müzik': 'Müzik, seslerin düzenlenmesi ve birleştirilmesi ile oluşturulan bir sanat dalıdır.',
    'Tarih': 'Tarih, geçmiş olayları ve insanlık deneyimlerini inceleyen bilimdir.',
    'Sosyoloji': 'Sosyoloji, toplumun yapısını, gelişimini ve işleyişini inceleyen bilim dalıdır.'
  };

  String currentSubject = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < buttonNames.length; i += 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentSubject = buttonNames[i];
                        });
                        _showInfoDialog(context, buttonNames[i]);
                      },
                      child: Text(buttonNames[i]),
                    ),
                  ),
                ),
                if (i + 1 < buttonNames.length)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentSubject = buttonNames[i + 1];
                          });
                          _showInfoDialog(context, buttonNames[i + 1]);
                        },
                        child: Text(buttonNames[i + 1]),
                      ),
                    ),
                  ),
              ],
            ),
          SizedBox(height: 20),
          Text(
            'Seçili Konu: $currentSubject',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String subject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(subject),
          content: Text(buttonInfo[subject]!),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Geri'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
