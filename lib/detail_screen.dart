import 'package:flutter/material.dart';
import 'translations.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String value;
  final String condition;
  final String meaning;
  final String healthTip;
  final Color color;
  final IconData icon;
  final String cityName;

  const DetailScreen({
    super.key,
    required this.title,
    required this.value,
    required this.condition,
    required this.meaning,
    required this.healthTip,
    required this.color,
    required this.icon,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F6F1),
      appBar: AppBar(
        backgroundColor: color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE1F5EE)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE1F5EE),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          Icon(Icons.share, color: Color(0xFF9FE1CB)),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Hero card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon, color: const Color(0xFF9FE1CB), size: 28),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          condition,
                          style: const TextStyle(
                            color: Color(0xFFE1F5EE),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFFE1F5EE),
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppTranslations.t('updated_just_now')} · ${AppTranslations.city(cityName)}',
                    style: const TextStyle(
                      color: Color(0xFF9FE1CB),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // What this means
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD0E8E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.t('what_this_means'),
                    style: const TextStyle(
                      color: Color(0xFF0F6E56),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meaning,
                    style: const TextStyle(
                      color: Color(0xFF2C2C2C),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Health tip
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5EE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF9FE1CB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb,
                      color: Color(0xFF085041), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      healthTip,
                      style: const TextStyle(
                        color: Color(0xFF085041),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Other states
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD0E8E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.t('conditions_other_states'),
                    style: const TextStyle(
                      color: Color(0xFF0F6E56),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildStateRow(AppTranslations.city('Tamil Nadu'),  '🟢 ${AppTranslations.t('good')}'),
                  _buildStateRow(AppTranslations.city('Kerala'),      '🟢 ${AppTranslations.t('good')}'),
                  _buildStateRow(AppTranslations.city('Karnataka'),   '🔵 ${AppTranslations.t('moderate')}'),
                  _buildStateRow(AppTranslations.city('Andhra'),      '🟠 ${AppTranslations.t('poor')}'),
                  _buildStateRow(AppTranslations.city('Telangana'),   '🔵 ${AppTranslations.t('moderate')}'),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // View map button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF085041),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, color: Color(0xFFE1F5EE), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'View all India map',
                    style: TextStyle(
                      color: Color(0xFFE1F5EE),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateRow(String state, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            state,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF085041),
            ),
          ),
          Text(
            status,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF0F6E56),
            ),
          ),
        ],
      ),
    );
  }
}