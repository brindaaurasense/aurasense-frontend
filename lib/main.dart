import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'loading_screen.dart';
import 'location_service.dart';
import 'translations.dart';

void main() {
  runApp(const AuraSenseApp());
}

class AuraSenseApp extends StatelessWidget {
  const AuraSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF085041),
        ),
        useMaterial3: true,
      ),
      home: LoadingScreen(nextScreen: const HomeScreen()),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? cityData;
  bool isLoading = true;
  String errorMessage = '';
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final position = await LocationService.getCurrentLocation();

      final Uri url;
      if (position != null) {
        url = Uri.parse(
          'https://aurasense-backend-4ye4.onrender.com/pollution-by-coords'
          '?lat=${position.latitude}&lon=${position.longitude}',
        );
      } else {
        url = Uri.parse(
          'https://aurasense-backend-4ye4.onrender.com/pollution/Madurai',
        );
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('error')) {
          // Station not found for exact GPS location — try nearest known city
          String fallbackCity = 'Chennai';

          if (position != null) {
            final detectedCity = await LocationService.getCityName(position);
            debugPrint('DEBUG: detected city = $detectedCity');
            if (detectedCity != null) {
              final nearest = getNearestMajorCity(detectedCity);
              debugPrint('DEBUG: nearest match = $nearest');
              if (nearest != null) {
                fallbackCity = nearest;
              }
            }
          }

          final fallback = await http.get(Uri.parse(
            'https://aurasense-backend-4ye4.onrender.com/pollution/$fallbackCity',
          ));
          setState(() {
            cityData  = json.decode(fallback.body);
            isLoading = false;
          });
        } else {
          setState(() {
            cityData  = data;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error!';
          isLoading    = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'No internet connection. Please check your network and try again.';
        isLoading    = false;
      });
    }
  }

String? getNearestMajorCity(String cityName) {
    final Map<String, String> nearestCityMap = {
      // Tamil Nadu
      'srivilliputtur' : 'Madurai',
      'srivilliputhur' : 'Madurai',
      'virudhunagar'   : 'Madurai',
      'rajapalayam'    : 'Madurai',
      'tenkasi'        : 'Madurai',
      'tirunelveli'    : 'Madurai',
      'tuticorin'      : 'Madurai',
      'thoothukudi'    : 'Madurai',
      'dindigul'       : 'Madurai',
      'theni'          : 'Madurai',
      'karur'          : 'Coimbatore',
      'erode'          : 'Coimbatore',
      'tiruppur'       : 'Coimbatore',
      'ooty'           : 'Coimbatore',
      'vellore'        : 'Chennai',
      'kanchipuram'    : 'Chennai',
      'pondicherry'    : 'Chennai',
      'cuddalore'      : 'Chennai',
      'thanjavur'      : 'Madurai',
      'trichy'         : 'Madurai',
      'nagapattinam'   : 'Madurai',
      'salem'          : 'Coimbatore',
      'namakkal'       : 'Coimbatore',
      'krishnagiri'    : 'Chennai',
      'dharmapuri'     : 'Chennai',
      // Kerala
      'thrissur'       : 'Kochi',
      'palakkad'       : 'Kochi',
      'kozhikode'      : 'Kochi',
      'kannur'         : 'Kochi',
      'kollam'         : 'Thiruvananthapuram',
      'alappuzha'      : 'Kochi',
      'malappuram'     : 'Kochi',
      'wayanad'        : 'Kochi',
      // Karnataka
      'mysuru'         : 'Bengaluru',
      'mangaluru'      : 'Bengaluru',
      'hubli'          : 'Bengaluru',
      'belgaum'        : 'Bengaluru',
      'tumkur'         : 'Bengaluru',
      'davangere'      : 'Bengaluru',
      'shimoga'        : 'Bengaluru',
      // Andhra
      'vijayawada'     : 'Hyderabad',
      'visakhapatnam'  : 'Hyderabad',
      'tirupati'       : 'Hyderabad',
      'guntur'         : 'Hyderabad',
      'nellore'        : 'Hyderabad',
      // Telangana
      'warangal'       : 'Hyderabad',
      'nizamabad'      : 'Hyderabad',
    };
    return nearestCityMap[cityName.toLowerCase()];
  }

  Color getConditionColor(String? condition) {
    if (condition == null) return const Color(0xFF085041);
    if (condition.contains('Good'))      return const Color(0xFF27500A);
    if (condition.contains('Moderate'))  return const Color(0xFF0C447C);
    if (condition.contains('Poor'))      return const Color(0xFF7A3205);
    if (condition.contains('Hazardous')) return const Color(0xFF501313);
    if (condition.contains('Pleasant'))  return const Color(0xFF27500A);
    if (condition.contains('Warm'))      return const Color(0xFF0C447C);
    if (condition.contains('Hot'))       return const Color(0xFF7A3205);
    if (condition.contains('Unbearable'))return const Color(0xFF7A3205);
    if (condition.contains('Comfortable'))return const Color(0xFF27500A);
    if (condition.contains('Humid'))     return const Color(0xFF7A3205);
    if (condition.contains('Very Humid'))return const Color(0xFF501313);
    return const Color(0xFF085041);
  }

  String getOverallMessage(String? condition) {
    if (condition == null) return 'Checking today\'s air quality...';
    if (condition.contains('Good')) {
      return 'Enjoy outdoor activities. The air quality is healthy today.';
    } else if (condition.contains('Moderate')) {
      return 'Most people are safe. Sensitive individuals should reduce prolonged outdoor activity.';
    } else if (condition.contains('Poor')) {
      return 'Avoid prolonged outdoor exposure. Consider wearing a mask.';
    } else if (condition.contains('Hazardous')) {
      return 'Stay indoors as much as possible. Air quality is unhealthy for everyone.';
    }
    return 'Fresh air, happy day — here\'s your quick health snapshot 🌿';
  }

  @override
  Widget build(BuildContext context) {
    final aqi     = cityData?['aqi'];
    final weather = cityData?['weather'];

    final aqiValue      = aqi?['value']?.toString() ?? '--';
    final displayCity   = cityData?['city']?.toString() ?? 'Unknown';
    final aqiCondition  = aqi?['condition'] ?? 'Loading...';
    final temp          = weather?['temperature']?.toString() ?? '--';
    final tempCondition = weather?['temp_condition'] ?? '';
    final humidity      = weather?['humidity']?.toString() ?? '--';
    final humCondition  = weather?['humidity_condition'] ?? '';
    final wind          = weather?['wind_speed']?.toString() ?? '--';
    final overallColor  = getConditionColor(aqiCondition);
    
    return Scaffold(
      backgroundColor: const Color(0xFFE8F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF085041),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AuraSense',
              style: TextStyle(
                color: Color(0xFFE1F5EE),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (AppTranslations.currentLanguage == 'தமிழ் Tamil')
              Text(
                AppTranslations.t('app_name'),
                style: const TextStyle(
                  color: Color(0xFFA8D5C8),
                  fontSize: 11,
                ),
              ),
            Text(
              cityData?['city'] != null
                  ? AppTranslations.city(cityData!['city'])
                  : 'Unable to detect location',
              style: const TextStyle(
                color: Color(0xFF9FE1CB),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          if (!isLoading)
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF9FE1CB)),
              onPressed: () {
                setState(() => isLoading = true);
                fetchData();
              },
            ),
          const Icon(Icons.notifications, color: Color(0xFF9FE1CB)),
          const SizedBox(width: 16),
          const Icon(Icons.person,        color: Color(0xFF9FE1CB)),
          const SizedBox(width: 16),
        ],
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF085041)),
                  SizedBox(height: 16),
                  Text(
                    'Fetching live data...',
                    style: TextStyle(color: Color(0xFF085041)),
                  ),
                ],
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Color(0xFFA32D2D), size: 48),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Color(0xFFA32D2D)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => isLoading = true);
                          fetchData();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      // Status banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: overallColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aqiCondition.replaceAll(
                                      RegExp(r'[^\x00-\x7F]'), '').trim(),
                                  style: const TextStyle(
                                    color: Color(0xFFE1F5EE),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'AQI: $aqiValue — right now',
                                  style: const TextStyle(
                                    color: Color(0xFF9FE1CB),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.eco,
                              color: Color(0xFF9FE1CB),
                              size: 36,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppTranslations.t('live_readings'),
                          style: const TextStyle(
                            color: Color(0xFF0F6E56),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Tiles grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.0,
                        children: [
                          _buildTile(
                            context,
                            AppTranslations.t('air_quality'),
                            aqiCondition.replaceAll(
                                RegExp(r'[^\x00-\x7F]'), '').trim(),
                            'AQI $aqiValue',
                            Icons.air,
                            getConditionColor(aqiCondition),
                            AppTranslations.t('aqi_meaning'),
                            AppTranslations.t('aqi_tip'),
                            displayCity,
                            extraMessage: getOverallMessage(aqiCondition),
                          ),
                          _buildTile(
                            context,
                            AppTranslations.t('temperature'),
                            '$temp°C',
                            tempCondition.replaceAll(
                                RegExp(r'[^\x00-\x7F]'), '').trim(),
                            Icons.thermostat,
                            getConditionColor(tempCondition),
                            AppTranslations.t('temp_meaning'),
                            AppTranslations.t('temp_tip'),
                            displayCity,
                          ),
                          _buildTile(
                            context,
                            AppTranslations.t('humidity'),
                            '$humidity%',
                            humCondition.replaceAll(
                                RegExp(r'[^\x00-\x7F]'), '').trim(),
                            Icons.water_drop,
                            getConditionColor(humCondition),
                            AppTranslations.t('humidity_meaning'),
                            AppTranslations.t('humidity_tip'),
                            displayCity,
                          ),
                          _buildTile(
                            context,
                            AppTranslations.t('wind_speed'),
                            '$wind km/h',
                            'Current wind',
                            Icons.air,
                            const Color(0xFF085041),
                            AppTranslations.t('wind_meaning'),
                            AppTranslations.t('wind_tip'),
                            displayCity,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Overall status tile
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: overallColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle,
                                color: Color(0xFFE1F5EE), size: 20),
                            const SizedBox(height: 4),
                            const Text(
                              'Overall Status',
                              style: TextStyle(
                                color: Color(0xFF9FE1CB),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              aqiCondition.replaceAll(
                                  RegExp(r'[^\x00-\x7F]'), '').trim(),
                              style: const TextStyle(
                                color: Color(0xFFE1F5EE),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              getOverallMessage(aqiCondition),
                              style: const TextStyle(
                                color: Color(0xFF9FE1CB),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF085041),
        selectedItemColor: const Color(0xFFE1F5EE),
        unselectedItemColor: const Color(0xFF5DCAA5),
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          } else {
            setState(() => currentIndex = index);
          }
        },
       items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppTranslations.t('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: AppTranslations.t('search'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppTranslations.t('settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    String meaning,
    String healthTip,
    String cityName, {
    String? extraMessage,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title     : label,
              value     : value,
              condition : subtitle,
              meaning   : meaning,
              healthTip : healthTip,
              color     : color,
              icon      : icon,
              cityName  : cityName,
              extraMessage: extraMessage,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: const Color(0xFF9FE1CB), size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF9FE1CB),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFFE1F5EE),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF5DCAA5),
                    fontSize: 10,
                  ),
                ),
                if (extraMessage != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    extraMessage,
                    style: const TextStyle(
                      color: Color(0xFF5DCAA5),
                      fontSize: 9,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}