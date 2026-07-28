import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'translations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pollutionAlerts = false;
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language') ?? 'English';
    setState(() {
      selectedLanguage = savedLang;
      AppTranslations.currentLanguage = savedLang;
    });
  }

  Future<void> _changeLanguage(String? value) async {
    if (value == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    setState(() {
      selectedLanguage = value;
      AppTranslations.currentLanguage = value;
    });
  }

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
        title: Text(
          AppTranslations.t('settings'),
          style: const TextStyle(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.t('enable_gps_alerts'),
                          style: const TextStyle(
                            color: Color(0xFF085041),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          AppTranslations.t('sign_in_subtitle'),
                          style: const TextStyle(
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
                    child: Text(
                      AppTranslations.t('sign_in'),
                      style: const TextStyle(
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
            _buildSectionLabel(AppTranslations.t('language_section')),
            _buildSettingsCard([
              _buildDropdownRow(
                Icons.language,
                AppTranslations.t('app_language'),
                AppTranslations.t('choose_language'),
                selectedLanguage,
                languages,
                _changeLanguage,
              ),
            ]),

            const SizedBox(height: 12),

            // Alerts section
            _buildSectionLabel(AppTranslations.t('alerts_section')),
            _buildSettingsCard([
              _buildToggleRow(
                Icons.air,
                AppTranslations.t('pollution_alerts'),
                AppTranslations.t('pollution_alerts_subtitle'),
                pollutionAlerts,
                (value) => setState(() => pollutionAlerts = value),
              ),
            ]),

            const SizedBox(height: 12),

            // About section
            _buildSectionLabel(AppTranslations.t('about_section')),
            _buildSettingsCard([
              _buildArrowRow(
                Icons.info_outline,
                AppTranslations.t('about_aurasense'),
                '',
              ),
              _buildDivider(),
              _buildArrowRow(
                Icons.shield_outlined,
                AppTranslations.t('privacy_policy'),
                '',
              ),
            ]),

            const SizedBox(height: 12),

            // WAQI Attribution
            Center(
              child: Text(
                AppTranslations.t('waqi_attribution'),
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
                AppTranslations.t('app_version'),
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