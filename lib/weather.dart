import 'package:flutter/material.dart';
import 'package:denemeapiler/servis.dart';
import 'model.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String apiKey = 'KENDİ APİ KEYİNİZ';
  String selectedCity = 'Ankara'; // Başlangıçta Ankara seçili
  Havalar? weatherData;
  final WeatherService _weatherService = WeatherService('apikey 0s8S4hKgKTgSXXK1aI71r5:4lbdstEdzT2wdzsWlb3Xxw');

  List<String> cities = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Amasya', 'Ankara', 'Antalya', 'Artvin', 'Aydın', 'Balıkesir',
    'Bilecik', 'Bingöl', 'Bitlis', 'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli',
    'Diyarbakır', 'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir', 'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkâri',
    'Hatay', 'Isparta', 'Mersin', 'İstanbul', 'İzmir', 'Kars', 'Kastamonu', 'Kayseri', 'Kırklareli', 'Kırşehir',
    'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa', 'Kahramanmaraş', 'Mardin', 'Muğla', 'Muş', 'Nevşehir',
    'Niğde', 'Ordu', 'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop', 'Sivas', 'Tekirdağ', 'Tokat',
    'Trabzon', 'Tunceli', 'Şanlıurfa', 'Uşak', 'Van', 'Yozgat', 'Zonguldak', 'Aksaray', 'Bayburt', 'Karaman',
    'Kırıkkale', 'Batman', 'Şırnak', 'Bartın', 'Ardahan', 'Iğdır', 'Yalova', 'Karabük', 'Kilis', 'Osmaniye', 'Düzce'
  ];

  @override
  void initState() {
    super.initState();
    fetchWeatherData(selectedCity);
  }

  Future<void> fetchWeatherData(String city) async {
    print("Seçilen Şehir: $cities");  // Hangi şehrin alındığını kontrol et
    final data = await _weatherService.fetchWeatherData(city);
    print("Gelen Veri: ${data?.toString()}"); // API'den ne döndüğünü kontrol et
    setState(() {
      weatherData = data;
    });
  }

  void selectCity() async {
    TextEditingController searchController = TextEditingController();
    List<String> filteredCities = List.from(cities);

    String? newCity = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Şehir Seçin'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(hintText: 'Şehir ara...'),
                    onChanged: (value) {
                      setState(() {
                        filteredCities = cities
                            .where((city) => city.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    height: 300,
                    child: ListView(
                      shrinkWrap: true,
                      children: filteredCities.map((city) => ListTile(
                        title: Text(city),
                        onTap: () => Navigator.pop(context, city),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (newCity != null && newCity != selectedCity) {
      setState(() {
        selectedCity = newCity;
        weatherData = null;
      });
      print("Yeni Seçilen Şehir: $selectedCity"); // Seçilen şehri ekrana yazdır
      fetchWeatherData(newCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hava Durumu'),
      ),
      body: Center(
        child: weatherData != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: selectCity,
              child: Text('Şehir: $selectedCity', style: TextStyle(fontSize: 30)),
            ),
            SizedBox(height: 10),
            if (weatherData!.result != null && weatherData!.result!.isNotEmpty)
              Column(
                children: weatherData!.result!.map((result) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: ListTile(
                      leading: result.icon != null
                          ? Image.network(result.icon!, width: 50, height: 50)
                          : null,
                      title: Text(result.day ?? ''),
                      subtitle: Text(result.description ?? ''),
                      trailing: Text('${result.degree}°C',style: TextStyle(fontSize: 20),),
                    ),
                  );
                }).toList(),
              ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
