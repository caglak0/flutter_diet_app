import 'package:flutter/material.dart';
import 'package:flutter_diet_app/model/search_model.dart';
import 'package:flutter_diet_app/pages/food_detail_page.dart';
import 'package:flutter_diet_app/service/food_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  final String title;
  const SearchPage({super.key, required this.title});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Future<SearchModel>? _searchResults;
  final Map<String, List<Map<String, dynamic>>> _selectedFoods = {
    'Kahvaltı': [],
    'Ara Öğün': [],
    'Öğle Yemeği': [],
    'Akşam Yemeği': [],
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedFoods();
  }

  Future<void> _loadSelectedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedFoods.forEach((key, value) {
        final String? foodsJson = prefs.getString('${key}Foods');
        if (foodsJson != null) {
          _selectedFoods[key] = List<Map<String, dynamic>>.from(json.decode(foodsJson));
        }
      });
    });
  }

  Future<void> _saveSelectedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFoods.forEach((key, value) {
      prefs.setString('${key}Foods', json.encode(value));
    });
  }

  void _addFood(String mealType, String name, double calories, int quantity) {
    setState(() {
      _selectedFoods[mealType]!.add({'name': name, 'calories': calories, 'quantity': quantity});
      _saveSelectedFoods();
    });
  }

  void _removeFood(String mealType, int index) {
    setState(() {
      _selectedFoods[mealType]!.removeAt(index);
      _saveSelectedFoods();
    });
  }

  void _searchFood() {
    setState(() {
      _searchResults = FatSecretService.foodSearchService(_controller.text);
    });
  }

  void _navigateToFoodDetail(String foodId, String mealType) async {
    final food = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailView(
          foodId: foodId,
          onAddFood: (name, calories, quantity) => _addFood(mealType, name, calories, quantity),
        ),
      ),
    );

    if (food != null && food is Map<String, dynamic>) {
      Navigator.pop(context, food);
    }
  }

  Widget _buildFoodList(String mealType) {
    final foods = _selectedFoods[mealType]!;
    final totalCalories = foods.fold(0.0, (sum, food) {
      if (food['calories'] is num || food['calories'] is String) {
        return sum + (double.parse(food['calories'].toString()));
      }
      return sum;
    });

    return Column(
      children: [
        ListTile(
          title: Text(mealType),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${totalCalories.toStringAsFixed(0)} kcal'),
              const SizedBox(width: 5),
              const Icon(Icons.local_fire_department, color: Colors.orange),
            ],
          ),
        ),
        if (foods.isNotEmpty)
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                final quantity = food['quantity'] ?? 1;
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text('${food['name']}'),
                      subtitle: Text('${food['calories']} kcal'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          quantity > 1 ? Text('$quantity adet') : Container(),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.blue),
                            onPressed: () => _removeFood(mealType, index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Arama yapın',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchFood,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<SearchModel>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data?.foods?.food == null) {
                  return const Center(child: Text('Sonuç bulunamadı'));
                } else {
                  final foods = snapshot.data!.foods!.food!;
                  return ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return SizedBox(
                        height: 110,
                        child: Card(
                          child: ListTile(
                            title: Text(food.foodName!),
                            subtitle: Text(food.foodDescription!),
                            onTap: () => _navigateToFoodDetail(food.foodId!, widget.title),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (_selectedFoods[widget.title]!.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    tileColor: Colors.grey[100],
                    title: _buildFoodList(widget.title),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
