import 'package:camera/camera.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/Model/DraftImage.dart';
import 'package:glucose_predictor/View/Home/homePage.dart';
import 'package:glucose_predictor/View/Settings/SettingsPage.dart';
import 'package:glucose_predictor/View/CheckMeal/takeImgPage.dart';
import 'package:hive_flutter/adapters.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  // Initializing Hive Database.
  await Hive.initFlutter();
  Hive.registerAdapter(DraftImageAdapter());

  runApp(const GlucoseApp());
}

class GlucoseApp extends StatelessWidget {
  const GlucoseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Predict Glucose'),
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  final screens = [
    const HomePage(),
    const TakeImgPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final itemList = <Widget>[
      const Icon(Icons.home, size: 30,),
      const Icon(Icons.add_circle_outline, size: 30,),
      const Icon(Icons.settings, size: 30,),
    ];

    return Container(
        child:SafeArea(
            top: false,
            child: Scaffold(
              extendBody: true,
              backgroundColor: Colors.white,
              body: screens[index],
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: const IconThemeData(color: Colors.black),
                ), child: CurvedNavigationBar(
                color: const Color(0Xffe6ffe5),
                buttonBackgroundColor: const Color(0Xffe6ffe5),
                backgroundColor: Colors.transparent,
                height: 50,
                items: itemList,
                index: index,
                animationDuration: const Duration(milliseconds: 300),
                onTap: (index) => setState(() {
                  this.index = index;
                }),
              ),),)
        ));
  }

  @override
  void dispose() {
    // Hive.box('DraftImage').compact();
    Hive.close();
    super.dispose();
  }

}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
