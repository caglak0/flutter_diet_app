import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_diet_app/screens/bki_screen.dart';
import 'package:flutter_diet_app/service/auth_service.dart';
import 'package:flutter_diet_app/widgets/custom_scaffold.dart';

class SignUpProfileScreen extends StatefulWidget {
  const SignUpProfileScreen({
    super.key,
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
  });

  final String email, password, name, surname;

  @override
  State<SignUpProfileScreen> createState() => _SignUpProfileScreenState();
}

class _SignUpProfileScreenState extends State<SignUpProfileScreen> {
  String? _selectedCinsiyet;
  final _formSignupProfileKey = GlobalKey<FormState>();
  final TextEditingController _kiloController = TextEditingController();
  final TextEditingController _boyController = TextEditingController();
  final TextEditingController _yasController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  late String gender, email, password, name, surname;
  late int kilo, size, age;

  @override
  void dispose() {
    _kiloController.dispose();
    _boyController.dispose();
    _yasController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    email = widget.email;
    password = widget.password;
    name = widget.name;
    surname = widget.surname;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupProfileKey,
                  child: Column(
                    children: [
                      const Text(
                        'Kullanıcı Bilgileri',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 52, 120, 54),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      DropdownButtonFormField<String>(
                        value: _selectedCinsiyet,
                        onSaved: (value) {
                          gender = value!;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Cinsiyet'),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCinsiyet = value;
                          });
                        },
                        items: <String>['Erkek', 'Kadın']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _kiloController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen Kilonuzu Giriniz';
                          } else if (int.tryParse(value) == null ||
                              int.parse(value) > 200) {
                            return 'Kilo maksimum 200 olmalı';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            kilo = int.parse(value);
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Kilo',
                          hintText: 'Kilonuzu giriniz',
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _boyController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen Boyunuzu Giriniz';
                          } else if (int.tryParse(value) == null ||
                              int.parse(value) > 250) {
                            return 'Boy maksimum 250 olmalı';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            size = int.parse(value);
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Boy',
                          hintText: 'Boyunuzu Giriniz',
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _yasController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen Yaşınızı Giriniz';
                          } else if (int.tryParse(value) == null ||
                              int.parse(value) > 100) {
                            return 'Yaş maksimum 100 olmalı';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null && value.isNotEmpty) {
                            age = int.parse(value);
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Yaş',
                          hintText: 'Yaşınızı Giriniz',
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 70,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formSignupProfileKey.currentState!
                                    .validate()) {
                                  _formSignupProfileKey.currentState!.save();
                                  AuthService().signUp(
                                    email,
                                    name,
                                    surname,
                                    password,
                                    gender,
                                    kilo,
                                    size,
                                    age,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BkiScreen(
                                        kilo: kilo,
                                        boy: size,
                                        yas: age,
                                        cinsiyet: _selectedCinsiyet!,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Icon(Icons.arrow_forward_rounded),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
