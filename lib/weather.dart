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
  final WeatherService _weatherService = WeatherService('KENDİ APİ KEYİNİZ');

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
    print("Seçilen Şehir: $city");
    final data = await _weatherService.fetchWeatherData(city);
    print("Gelen Veri: ${data?.toString()}");
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text('Şehir Seçin', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Şehir ara...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredCities = cities
                            .where((city) => city.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.maxFinite,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[50],
                    ),
                    child: ListView(
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      children: filteredCities.map((city) => Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          title: Text(city),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () => Navigator.pop(context, city),
                        ),
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
      fetchWeatherData(newCity);
    }
  }

  // Hava durumu için ikonları belirleyelim
  IconData getWeatherIcon(String? description) {
    if (description == null) return Icons.cloud_queue;
    
    description = description.toLowerCase();
    if (description.contains('açık')) return Icons.wb_sunny;
    if (description.contains('parçalı bulut')) return Icons.wb_cloudy;
    if (description.contains('bulut')) return Icons.cloud;
    if (description.contains('yağmur')) return Icons.grain;
    if (description.contains('kar')) return Icons.ac_unit;
    if (description.contains('fırtına')) return Icons.flash_on;
    
    return Icons.cloud_queue;
  }

  // Hava durumuna göre arka plan rengi belirleyelim
  Color getWeatherColor(String? description) {
    if (description == null) return Colors.blue.shade100;
    
    description = description.toLowerCase();
    if (description.contains('açık')) return Colors.amber.shade100;
    if (description.contains('parçalı bulut')) return Colors.lightBlue.shade100;
    if (description.contains('bulut')) return Colors.blueGrey.shade100;
    if (description.contains('yağmur')) return Colors.indigo.shade100;
    if (description.contains('kar')) return Colors.grey.shade200;
    if (description.contains('fırtına')) return Colors.purple.shade100;
    
    return Colors.blue.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Hava Durumu',
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue.shade800),
            onPressed: () => fetchWeatherData(selectedCity),
          ),
        ],
      ),
      body: weatherData != null
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    InkWell(
                      onTap: selectCity,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: Colors.blue.shade700),
                            SizedBox(width: 8),
                            Text(
                              selectedCity,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    if (weatherData!.result != null && weatherData!.result!.isNotEmpty)
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: weatherData!.result!.length,
                        itemBuilder: (context, index) {
                          final result = weatherData!.result![index];
                          final isToday = index == 0;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isToday
                                    ? getWeatherColor(result.description)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: isToday
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(24),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    result.day ?? "Bugün",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue.shade800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  result.icon != null
                                                      ? Image.network(
                                                          result.icon!,
                                                          width: 80,
                                                          height: 80,
                                                          errorBuilder: (context, error, stackTrace) =>
                                                              Icon(
                                                                getWeatherIcon(result.description),
                                                                size: 80,
                                                                color: Colors.blue.shade800,
                                                              ),
                                                        )
                                                      : Icon(
                                                          getWeatherIcon(result.description),
                                                          size: 80,
                                                          color: Colors.blue.shade800,
                                                        ),
                                                  SizedBox(width: 20),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${result.degree ?? ""}°C',
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blue.shade800,
                                                        ),
                                                      ),
                                                      Text(
                                                        result.description ?? "",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.blue.shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      leading: result.icon != null
                                          ? Image.network(
                                              result.icon!,
                                              width: 40,
                                              height: 40,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Icon(
                                                    getWeatherIcon(result.description),
                                                    size: 40,
                                                    color: Colors.blue.shade600,
                                                  ),
                                            )
                                          : Icon(
                                              getWeatherIcon(result.description),
                                              size: 40,
                                              color: Colors.blue.shade600,
                                            ),
                                      title: Text(
                                        result.day ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                      subtitle: Text(
                                        result.description ?? "",
                                        style: TextStyle(
                                          color: Colors.blue.shade600,
                                        ),
                                      ),
                                      trailing: Text(
                                        '${result.degree ?? ""}°C',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade800,
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Hava durumu bilgileri yükleniyor...",
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
