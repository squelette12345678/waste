import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/floating_menu_button.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';
import 'package:flutter_map_example/widgets/first_start_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/imagepath.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List person = [
    {
      "matricule": "30a",
      "nom": "Pomme",
      "Localisation": "Mendong",
      "prix": "25",
    },
    {
      "matricule": "31a",
      "nom": "terre",
      "Localisation": "messassi",
      "prix": "35",
    },
    {
      "matricule": "32b",
      "nom": "foumme",
      "Localisation": "colamme",
      "prix": "98",
    },
    {
      "matricule": "33c",
      "nom": "suimme",
      "Localisation": "bafoussam",
      "prix": "200",
    }
  ];
  List commande = [];

  @override
  void initState() {
    super.initState();
    showIntroDialogIfNeeded();
  }

  showmodal() {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              color: Colors.grey.withOpacity(0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: person.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          showmodaldetail(e);
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(Imagepath.dechet),
                        ),
                        title: Text(e["nom"].toString()),
                        subtitle: Text(e["Localisation"].toString()),
                        trailing: Text(e["prix"].toString()),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ));
  }

  final picker = ImagePicker();
  File? image;

  Future chooseImageCamera(state) async {
    var pickerImage = await picker.pickImage(source: ImageSource.camera);
    if (pickerImage == null) {
      return;
    } else {
      state(() {
        image = File(pickerImage.path);
      });
    }
  }

  showmodaldetail(e) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(builder: (context, state) {
              return Container(
                color: Colors.grey.withOpacity(0.1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 90,
                      ),
                      title: Text(
                        e["nom"].toString(),
                        style: TextStyle(fontSize: 40),
                      ),
                      subtitle: Text(e["Localisation"].toString(),
                          style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          chooseImageCamera(state);
                        },
                        child: Text("importer une image")),
                    SizedBox(
                      height: 5,
                    ),
                    if (image != null)
                      Container(
                        child: Image.file(image!),
                      ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          state((){

                            commande.add(
                                {
                                  "matricule": e["matricule"],
                                  "numero": "690556060",
                                  "Localisation": e["Localisation"],
                                  "image": image!,
                                }
                            );
                            Navigator.pop(context);
                          });

                        },
                        child: Text(
                          "Confirmer",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            }));
  }

  bool select = false;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: const MenuDrawer(HomePage.route),
      body: IndexedStack(
        index: index,
        children: [
          Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: const LatLng(51.5, -0.09),
                  initialZoom: 5,
                  cameraConstraint: CameraConstraint.contain(
                    bounds: LatLngBounds(
                      const LatLng(-90, -180),
                      const LatLng(90, 180),
                    ),
                  ),
                ),
                children: [
                  openStreetMapTileLayer,
                  RichAttributionWidget(
                    popupInitialDisplayDuration: const Duration(seconds: 5),
                    animationConfig: const ScaleRAWA(),
                    showFlutterMapAttribution: false,
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () async => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright'),
                        ),
                      ),
                      const TextSourceAttribution(
                        'This attribution is the same throughout this app, except '
                        'where otherwise specified',
                        prependCopyright: false,
                      ),
                    ],
                  ),
                ],
              ),
              const FloatingMenuButton()
            ],
          ),
          Container(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.green,
                centerTitle: true,
                title: Text(
                  "Liste des Commandes",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              body: ListView(
                padding: EdgeInsets.only(top: 20),
                children: commande.map((e) {
                  return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text("Matricule : ${e["matricule"]}" ),
                              Text("Numero : ${e["numero"]} "),
                              Text("Lieu : ${e["Localisation"]}"),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 90,
                               decoration: BoxDecoration(image: DecorationImage(image: FileImage(File(e["image"].toString())))),
                              ),
                              Text("Poubelle"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: index == 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  image = null;
                  showmodal();
                },
                child: Text(
                  'Commander',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          : SizedBox(),
      bottomNavigationBar: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                select = true;
                index = 0;
              });
              print(select);
            },
            child: Container(
              alignment: Alignment.center,
              height: 75,
              color: select == true ? Colors.green : Colors.white,
              child: ListTile(
                title: Icon(Icons.home),
                subtitle: Text(
                  "Home",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )),
          Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                select = false;
                index = 1;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 75,
              color: select != true ? Colors.green : Colors.white,
              child: ListTile(
                title: Icon(
                  Icons.message,
                  color: select == true ? Colors.green : Colors.white,
                ),
                subtitle: Text(
                  "message",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: select == true ? Colors.green : Colors.white),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  void showIntroDialogIfNeeded() {
    const seenIntroBoxKey = 'seenIntroBox(a)';
    if (kIsWeb && Uri.base.host.trim() == 'demo.fleaflet.dev') {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) async {
          final prefs = await SharedPreferences.getInstance();
          if (prefs.getBool(seenIntroBoxKey) ?? false) return;

          if (!mounted) return;

          await showDialog<void>(
            context: context,
            builder: (context) => const FirstStartDialog(),
          );
          await prefs.setBool(seenIntroBoxKey, true);
        },
      );
    }
  }

  mapview() {
    return;
  }
}
