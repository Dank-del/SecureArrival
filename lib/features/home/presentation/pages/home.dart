import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/core/data/service/location_service.dart';
import 'package:flutter_appwrite_starter/core/presentation/router/router.dart';
import 'package:flutter_appwrite_starter/features/home/presentation/pages/discover.dart';
import 'package:flutter_appwrite_starter/features/home/presentation/pages/fam_and_friends_screen_page.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  void beginTracking() async {
    var account = await ApiService.instance.account?.get();
    print(account);
    LocationService.instance.startTracking(account!.$id, ['']);
  }

  @override
  void initState() {
    super.initState();
    beginTracking();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Arrival'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.goNamed(AppRoutes.profile),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.map_outlined),
            ),
            Tab(
              icon: Icon(Icons.warning_sharp),
            ),
            Tab(
              icon: Icon(Icons.family_restroom),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Discover(),
          Center(
            child: Text("It's rainy here"),
          ),
          FamAndFriends(),
        ],
      ),
    );
  }
}
