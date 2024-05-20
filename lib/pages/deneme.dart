import 'package:flutter/material.dart';
import 'package:flutter_diet_app/model/foodbyid_model.dart';
import 'package:flutter_diet_app/service/food_service.dart';

class FoodDetailView extends StatefulWidget {
  final String foodId;

  const FoodDetailView({super.key, required this.foodId});

  @override
  _FoodDetailViewState createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  late Future<FoodByID> _futureFoodDetails;
  final List<Serving> _addedServings = [];

  @override
  void initState() {
    super.initState();
    _futureFoodDetails = FatSecretService.foodDetailService(widget.foodId);
  }

  void _addServing(Serving serving) {
    setState(() {
      _addedServings.add(serving);
    });
  }

  Widget _buildCardWidget(String title, String calories) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 150,
          height: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text('Kalori: $calories kcal'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yiyecek Detayları'),
      ),
      body: FutureBuilder<FoodByID>(
        future: _futureFoodDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.food == null) {
            return const Center(child: Text('Detay bulunamadı'));
          } else {
            final food = snapshot.data!.food!;
            final servings = food.servings?.serving ?? [];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Yiyecek: ${food.foodName}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('Besin Değerleri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: servings.length,
                      itemBuilder: (context, index) {
                        final serving = servings[index];
                        return Card(
                          child: ListTile(
                            title: Text(serving.servingDescription!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kalori: ${serving.calories} kcal'),
                                Text('Karbonhidrat: ${serving.carbohydrate} g'),
                                Text('Protein: ${serving.protein} g'),
                                Text('Yağ: ${serving.fat} g'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                _addServing(serving);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  const Text('Eklenen Yiyecekler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _addedServings.length,
                      itemBuilder: (context, index) {
                        final serving = _addedServings[index];
                        return _buildCardWidget(serving.servingDescription ?? 'Bilinmiyor', serving.calories ?? '0');
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
