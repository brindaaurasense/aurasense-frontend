import 'package:flutter/material.dart';
import 'translations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF085041),
        title: Text(
          AppTranslations.t('about_aurasense'),
          style: const TextStyle(
            color: Color(0xFFE1F5EE),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.eco, color: const Color(0xFF085041), size: 48),
                  const SizedBox(height: 8),
                  const Text(
                    'AuraSense',
                    style: TextStyle(
                      color: Color(0xFF085041),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: Color(0xFF0F6E56),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Our Mission',
              'AuraSense is a free air quality and weather monitoring app built for South India. Our goal is to make real-time pollution and weather information accessible to everyone, in their own language.',
            ),
            _buildSection(
              'Features',
              '• Real-time Air Quality Index (AQI) tracking\n'
              '• Live weather data — temperature, humidity, wind speed\n'
              '• GPS-based automatic city detection\n'
              '• Search any city or town\n'
              '• Available in English, Hindi, and major South Indian languages',
            ),
            _buildSection(
              'Data Sources',
              'AuraSense uses data from the World Air Quality Index (WAQI) project, Open-Meteo, and BigDataCloud to bring you accurate, up-to-date information.',
            ),
            _buildSection(
              'Made With Care',
              'AuraSense is built and maintained independently, with the goal of supporting public health awareness across South India. 🌿',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF085041),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}