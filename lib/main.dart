import 'package:big_red_hacks_2022/firebase_helpers.dart';
import 'package:big_red_hacks_2022/map_page.dart';
import 'package:big_red_hacks_2022/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fountain.dart';
import 'list_page.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: LoginPage(),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
        create: (context) => CurrentUserInfo());
  }
}

enum Pages { map, list }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPageIndex = 0;
  bool isBottomSheetOpen = false;

  void selectPage(int index) {
    if (isBottomSheetOpen) {
      Navigator.of(context).pop();
    }
    setState(() {
      selectedPageIndex = index;
      isBottomSheetOpen = false;
    });
  }

  void openBottomSheet(bool isOpen) {
    setState(() {
      isBottomSheetOpen = isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder<List<Fountain>>(
        future: Helpers.getAllFountains(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('get all fountains error ' + snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            print('get all fountains no data');
            return Center(child: CircularProgressIndicator());
          }
          List<Fountain>? fountains = snapshot.data;
          fountains!.sort((a, b) =>
              (getAvgRating(b.reviews) - getAvgRating(a.reviews)).toInt());
          return Scaffold(
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title),
                automaticallyImplyLeading: false),
            body: selectedPageIndex == Pages.map.index
                ? MapPage(fountains, openBottomSheet)
                : ListPage(fountains),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
              ],
              currentIndex: selectedPageIndex,
              onTap: selectPage,
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     // TODO: implement creating fountain
            //   },
            //   child: const Icon(Icons.add),
            // ),
          );
        });
  }
}
