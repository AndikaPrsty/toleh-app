import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:toleh/screens/home.dart';
import 'package:toleh/screens/map.dart';
import 'package:toleh/screens/akun.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Beranda(),
              MapPage(),
              Akun(),
            ]),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 85),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border(top: BorderSide(color: Colors.black))),
        child: TabBar(
          indicatorColor: Colors.transparent,
          isScrollable: false,
          labelColor: Colors.black,
          automaticIndicatorColorAdjustment: false,
          enableFeedback: true,
          tabs: [
            Tab(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: _tabController.index == 0
                        ? Colors.grey[350]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.home,
                  color: _tabController.index == 0 ? Colors.blue : Colors.black,
                ),
              ),
            ),
            Tab(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: _tabController.index == 1
                        ? Colors.grey[350]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.explore,
                  color: _tabController.index == 1 ? Colors.blue : Colors.black,
                ),
              ),
            ),
            Tab(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    color: _tabController.index == 2
                        ? Colors.grey[350]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.account_circle,
                  color: _tabController.index == 2 ? Colors.blue : Colors.black,
                ),
              ),
            )
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
