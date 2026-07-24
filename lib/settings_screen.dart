import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pollutionAlerts = false;
  bool heatAlerts      = false;
  bool waterAlerts     = false;
  bool darkMode        = false;
  String selectedLanguage = 'English';

  final List<String> languages = [
    'English',
    'தமிழ் Tamil',
    'తెలుగు Telugu',
    'ಕನ್ನಡ Kannada',
    'മലയാളം Malayalam',
    'हिन्दी Hindi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF085041),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFFE1F5EE),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Sign in banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_off,
                      color: Color(0xFF085041), size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enable GPS alerts',
                          style: TextStyle(
                            color: Color(0xFF085041),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Sign in with phone to get live alerts',
                          style: TextStyle(
                            color: Color(0xFF0F6E56),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF085041),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Color(0xFFE1F5EE),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Language section
            _buildSectionLabel('LANGUAGE'),
            _buildSettingsCard([
              _buildDropdownRow(
                Icons.language,
                'App language',
                'Choose your preferred language',
                selectedLanguage,
                languages,
                (value) {
                  setState(() => selectedLanguage = value!);
                },
              ),
            ]),

            const SizedBox(height: 12),

            // Alerts section
            _buildSectionLabel('ALERTS'),
            _buildSettingsCard([
              _buildToggleRow(
                Icons.air,
                'Pollution alerts',
                'Notify when AQI is poor',
                pollutionAlerts,
                (value) => setState(() => pollutionAlerts = value),
              ),
              _buildDivider(),
              _buildToggleRow(
                Icons.wb_sunny,
                'Heat alerts',
                'Notify when heat is unbearable',
                heatAlerts,
                (value) => setState(() => heatAlerts = value),
              ),
              _buildDivider(),
              _buildToggleRow(
                Icons.water_drop,
                'Water alerts',
                'Notify when water is unsafe',
                waterAlerts,
                (value) => setState(() => waterAlerts = value),
              ),
            ]),

            const SizedBox(height: 12),

            // Display section
            _buildSectionLabel('DISPLAY'),
            _buildSettingsCard([
              _buildToggleRow(
                Icons.dark_mode,
                'Dark mode',
                'Easy on eyes at night',
                darkMode,
                (value) => setState(() => darkMode = value),
              ),
            ]),

            const SizedBox(height: 12),

            // About section
            _buildSectionLabel('ABOUT'),
            _buildSettingsCard([
              _buildArrowRow(
                Icons.info_outline,
                'About AuraSense',
                '',
              ),
              _buildDivider(),
              _buildArrowRow(
                Icons.shield_outlined,
                'Privacy policy',
                '',
              ),
            ]),

            const SizedBox(height: 12),

            // WAQI Attribution
            Center(
              child: Text(
                'Air quality data provided by the World Air Quality\nIndex project (waqi.info)',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF0F6E56),
                  fontSize: 10,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Version
            Center(
              child: Text(
                'AuraSense v1.0.0 · Made for South India 🌿',
                style: const TextStyle(
                  color: Color(0xFF0F6E56),
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0F6E56),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD0E8E0)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleRow(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF085041), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF085041),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF0F6E56),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF1D9E75),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(
    IconData icon,
    String title,
    String subtitle,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF085041), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF085041),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF0F6E56),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            style: const TextStyle(
              color: Color(0xFF085041),
              fontSize: 12,
            ),
            items: items.map((lang) {
              return DropdownMenuItem(
                value: lang,
                child: Text(lang),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowRow(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF085041), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF085041),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward,
              color: Color(0xFF9FE1CB), size: 18),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Color(0xFFE8F4F0),
      indent: 58,
    );
  }
}