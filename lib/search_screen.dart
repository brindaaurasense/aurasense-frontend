import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? searchResult;
  bool isLoading      = false;
  bool hasSearched    = false;
  String errorMessage = '';
  bool nearestCityUsed = false;
  String nearestCityName = '';

final List<String> recentSearches = [
  'Chennai',
  'Madurai',
  'Coimbatore',
];

final List<String> popularCities = [
  'Chennai',
  'Madurai',
  'Coimbatore',
  'Bengaluru',
  'Kochi',
  'Hyderabad',
  'Thiruvananthapuram',
  'Mysuru',
  'Visakhapatnam',
  'Vijayawada',
  'London',
  'Dubai',
  'Singapore',
];

  String? getNearestCity(String cityName) {
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
      // International
      'london'         : 'London',
      'new york'       : 'New York',
      'dubai'          : 'Dubai',
      'singapore'      : 'Singapore',
      'sydney'         : 'Sydney',
      'toronto'        : 'Toronto',
      'paris'          : 'Paris',
      'berlin'         : 'Berlin',
      'tokyo'          : 'Tokyo',
      'kuala lumpur'   : 'Kuala Lumpur',
      'colombo'        : 'Colombo',
    };
    return nearestCityMap[cityName.toLowerCase()];
  }

  Future<void> searchCity(String cityName) async {
    setState(() {
      isLoading    = true;
      hasSearched  = true;
      errorMessage = '';
      searchResult = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://aurasense-backend-4ye4.onrender.com/pollution/$cityName'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('error')) {
          // Try nearest major city
          final nearestCity = getNearestCity(cityName);
          if (nearestCity != null) {
            setState(() {
              nearestCityUsed = true;
              nearestCityName = nearestCity;
            });
            searchCity(nearestCity);
          } else {
            setState(() {
              errorMessage = 'City not found! Try another city.';
              isLoading    = false;
            });
          }
        } else {
          setState(() {
            searchResult = data;
            isLoading    = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error! Please try again.';
          isLoading    = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Could not connect to server!';
        isLoading    = false;
      });
    }
  }

  Color getConditionColor(String? condition) {
    if (condition == null) return const Color(0xFF085041);
    if (condition.contains('Good'))       return const Color(0xFF27500A);
    if (condition.contains('Moderate'))   return const Color(0xFF0C447C);
    if (condition.contains('Poor'))       return const Color(0xFF7A3205);
    if (condition.contains('Hazardous'))  return const Color(0xFF501313);
    if (condition.contains('Pleasant'))   return const Color(0xFF27500A);
    if (condition.contains('Warm'))       return const Color(0xFF0C447C);
    if (condition.contains('Hot'))        return const Color(0xFF7A3205);
    if (condition.contains('Unbearable')) return const Color(0xFF7A3205);
    return const Color(0xFF085041);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F6F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF085041),
        title: const Text(
          'Search Location',
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF9FE1CB)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search,
                      color: Color(0xFF9FE1CB), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search city or town...',
                        hintStyle: TextStyle(
                          color: Color(0xFF9FE1CB),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          searchCity(value);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic,
                        color: Color(0xFF9FE1CB), size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (isLoading)
              const Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                        color: Color(0xFF085041)),
                    SizedBox(height: 12),
                    Text('Searching...',
                        style: TextStyle(color: Color(0xFF085041))),
                  ],
                ),
              )
            else if (errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEBEB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFA32D2D), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(errorMessage,
                          style: const TextStyle(
                              color: Color(0xFFA32D2D), fontSize: 13)),
                    ),
                  ],
                ),
              )
            else if (searchResult != null) ...[
              // Show nearest city notice if applicable
              if (nearestCityUsed)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5EE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF9FE1CB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFF085041), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No station found nearby — showing data for $nearestCityName',
                          style: const TextStyle(
                            color: Color(0xFF085041),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              _buildSearchResult(searchResult!),
            ] else ...[
              const Text(
                'RECENTLY SEARCHED',
                style: TextStyle(
                  color: Color(0xFF0F6E56),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              ...recentSearches.map((city) =>
                  _buildCityChip(city, Icons.history)),
              const SizedBox(height: 16),
              const Text(
                'POPULAR IN SOUTH INDIA',
                style: TextStyle(
                  color: Color(0xFF0F6E56),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              ...popularCities.map((city) =>
                  _buildCityChip(city, Icons.location_on)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCityChip(String city, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() => nearestCityUsed = false);
        searchCity(city);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE1F5EE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0F6E56), size: 16),
            const SizedBox(width: 10),
            Expanded(
              child: Text(city,
                  style: const TextStyle(
                      color: Color(0xFF085041), fontSize: 13)),
            ),
            const Icon(Icons.arrow_forward,
                color: Color(0xFF0F6E56), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResult(Map<String, dynamic> data) {
    final aqi     = data['aqi'];
    final weather = data['weather'];

    final aqiValue      = aqi?['value']?.toString() ?? '--';
    final aqiCondition  = aqi?['condition'] ?? '--';
    final temp          = weather?['temperature']?.toString() ?? '--';
    final tempCondition = weather?['temp_condition'] ?? '';
    final humidity      = weather?['humidity']?.toString() ?? '--';
    final wind          = weather?['wind_speed']?.toString() ?? '--';
    final cityName      = data['city'] ?? 'Unknown';
    final color         = getConditionColor(aqiCondition);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SEARCH RESULT',
          style: TextStyle(
            color: Color(0xFF0F6E56),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cityName,
                      style: const TextStyle(
                          color: Color(0xFFE1F5EE),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.location_on,
                      color: Color(0xFF9FE1CB), size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildResultTile('AQI', aqiValue,
                      aqiCondition.replaceAll(
                          RegExp(r'[^\x00-\x7F]'), '').trim()),
                  const SizedBox(width: 8),
                  _buildResultTile('Temp', '$temp°C',
                      tempCondition.replaceAll(
                          RegExp(r'[^\x00-\x7F]'), '').trim()),
                  const SizedBox(width: 8),
                  _buildResultTile('Humidity', '$humidity%', ''),
                  const SizedBox(width: 8),
                  _buildResultTile('Wind', '$wind km/h', ''),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultTile(
      String label, String value, String condition) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF9FE1CB), fontSize: 10)),
            Text(value,
                style: const TextStyle(
                    color: Color(0xFFE1F5EE),
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            if (condition.isNotEmpty)
              Text(condition,
                  style: const TextStyle(
                      color: Color(0xFF9FE1CB), fontSize: 9)),
          ],
        ),
      ),
    );
  }
}