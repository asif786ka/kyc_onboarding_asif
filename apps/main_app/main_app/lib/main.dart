import 'package:flutter/material.dart';
import 'package:kyc_region_library/kyc_region_library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Region KYC Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RegionSelectionScreen(),
    );
  }
}

class RegionSelectionScreen extends StatelessWidget {
  const RegionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final regions = [
      {'code': 'US', 'name': 'United States'},
      {'code': 'EU', 'name': 'European Union'},
      {'code': 'UK', 'name': 'United Kingdom'},
      {'code': 'AE', 'name': 'United Arab Emirates'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Region'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          final region = regions[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(region['name']!),
              subtitle: Text('Region Code: ${region['code']}'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => KYCScreen(region: region['code']!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
