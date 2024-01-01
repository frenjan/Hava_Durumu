import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('H A V A - D U R U M U', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: WeatherList(),
      ),
    );
  }
}

class WeatherList extends StatefulWidget {
  @override
  _WeatherListState createState() => _WeatherListState();
}

class _WeatherListState extends State<WeatherList> {
  List<String> cities = [
    'Adana', 'Adiyaman', 'Afyonkarahisar', 'Agri', 'Amasya', 'Ankara', 'Antalya', 'Artvin', 'Aydin', 'Balikesir',
    'Bilecik', 'Bingol', 'Bitlis', 'Bolu', 'Burdur', 'Bursa', 'Canakkale', 'Cankiri', 'Corum', 'Denizli', 'Diyarbakir',
    'Edirne', 'Elazig', 'Erzincan', 'Erzurum', 'Eskisehir', 'Gaziantep', 'Giresun', 'Gumushane', 'Hakkari', 'Hatay',
    'Isparta', 'Mersin', 'Istanbul', 'Izmir', 'Kars', 'Kastamonu', 'Kayseri', 'Kirklareli', 'Kirsehir', 'Kocaeli',
    'Konya', 'Kutahya', 'Malatya', 'Manisa', 'Kahramanmaras', 'Mardin', 'Mugla', 'Mus', 'Nevsehir', 'Nigde', 'Ordu',
    'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop', 'Sivas', 'Tekirdag', 'Tokat', 'Trabzon', 'Tunceli', 'Sanliurfa',
    'Usak', 'Van', 'Yozgat', 'Zonguldak', 'Aksaray', 'Bayburt', 'Karaman', 'Kirikkale', 'Batman', 'Sirnak', 'Bartin',
    'Ardahan', 'Igdir', 'Yalova', 'Karabuk', 'Kilis', 'Osmaniye', 'Duzce',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        return WeatherItem(city: cities[index]);
      },
    );
  }
}

class WeatherItem extends StatefulWidget {
  final String city;

  WeatherItem({required this.city});

  @override
  _WeatherItemState createState() => _WeatherItemState();
}

class _WeatherItemState extends State<WeatherItem> {
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    getWeatherData(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(weatherData?['location']['name'] ?? 'Şehir bulunamadı'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Derece: ${weatherData?['current']['temp_c'] ?? 'N/A'}°C'),
          Text('Hava: ${weatherData?['current']['condition']['text'] ?? 'N/A'}'),
        ],
      ),
      onTap: () {
        _showWeatherDetailsDialog(context);
      },
    );
  }

  Future<void> getWeatherData(String city) async {
    final response = await http.get(
      Uri.parse('https://api.weatherapi.com/v1/current.json?key=68e590bc30b54c6e9c7155310232712&q=Turkey%20$city&aqi=no'),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          weatherData = json.decode(response.body);
        });
      }
    } else {
      throw Exception('Hava durumu verileri alınamıyor');
    }
  }

Future<void> _showWeatherDetailsDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(weatherData?['location']['name'] ?? 'Şehir bulunamadı'),
              if (weatherData?['current']['condition']['icon'] != null)
                Image.network('https:${weatherData?['current']['condition']['icon']}'),
            ],
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Son Güncelleme ${weatherData?['current']['last_updated'] ?? 'N/A'}'),
            Text('Derece: ${weatherData?['current']['temp_c'] ?? 'N/A'}°C'),
            Text('Hava: ${weatherData?['current']['condition']['text'] ?? 'N/A'}'),
            Text('Rüzgar Hızı: ${weatherData?['current']['wind_kph'] ?? 'N/A'} kph'),
            Text('Rüzgar Yönü: ${weatherData?['current']['wind_dir'] ?? 'N/A'}'),
            Text('Basınç: ${weatherData?['current']['pressure_mb'] ?? 'N/A'} mb'),
            Text('Nem Oranı:%${weatherData?['current']['humidity'] ?? 'N/A'} '),
            Text('Hissedilen Sıcaklık: ${weatherData?['current']['feelslike_c'] ?? 'N/A'}°C'),
            Text('Görüş Mesafesi: ${weatherData?['current']['vis_km'] ?? 'N/A'} km'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Kapat'),
          ),
        ],
      );
    },
  );
}

  @override
  void dispose() {
    super.dispose();
  }
}
