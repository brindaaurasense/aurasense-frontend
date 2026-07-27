class AppTranslations {
  static String currentLanguage = 'English';

  static final Map<String, Map<String, String>> _translations = {
    'English': {
      'app_name': 'AuraSense',
      'good': 'Good',
      'moderate': 'Moderate',
      'poor': 'Poor',
      'air_quality': 'Air Quality',
      'temperature': 'Temperature',
      'humidity': 'Humidity',
      'wind_speed': 'Wind Speed',
      'overall_status': 'Overall Status',
      'live_readings': 'LIVE READINGS',
      'home': 'Home',
      'search': 'Search',
      'settings': 'Settings',
      'right_now': 'right now',
      'what_this_means': 'WHAT THIS MEANS',
      'updated_just_now': 'Updated just now',
    },
    'தமிழ் Tamil': {
      'app_name': 'ஆரா சென்ஸ்',
      'good': 'நல்லது',
      'moderate': 'மிதமானது',
      'poor': 'மோசமானது',
      'air_quality': 'காற்றின் தரம்',
      'temperature': 'வெப்பநிலை',
      'humidity': 'ஈரப்பதம்',
      'wind_speed': 'காற்றின் வேகம்',
      'overall_status': 'ஒட்டுமொத்த நிலை',
      'live_readings': 'நேரடி அளவீடுகள்',
      'home': 'முகப்பு',
      'search': 'தேடல்',
      'settings': 'அமைப்புகள்',
      'right_now': 'இப்போது',
      'what_this_means': 'இதன் அர்த்தம் என்ன',
      'updated_just_now': 'இப்போது புதுப்பிக்கப்பட்டது',
    },
  };

  static String t(String key) {
    return _translations[currentLanguage]?[key] ?? _translations['English']![key] ?? key;
  }
}