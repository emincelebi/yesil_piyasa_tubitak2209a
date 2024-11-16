import 'package:animations/animations.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';
import 'package:yesil_piyasa/views/home/add_products.dart';
import 'package:yesil_piyasa/views/home/drawer_views/about_view.dart';
import 'package:yesil_piyasa/views/home/drawer_views/favorites_view.dart';
import 'package:yesil_piyasa/views/home/drawer_views/report_view.dart';
import 'package:yesil_piyasa/views/home/drawer_views/settings_view.dart';
import 'package:yesil_piyasa/views/home/drawer_views/truck_drivers_view.dart';
import 'package:yesil_piyasa/views/home/my_products.dart';
import 'package:yesil_piyasa/views/home/products.dart';
import 'package:yesil_piyasa/views/home/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.user,
  });

  final MyUser? user;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const MyProductsView(),
    const ProductsView(),
    const AddProductsView(),
  ];
  late AnimationController _rotationController;

  final List<Color> _backgroundColors = [
    Colors.blueAccent, // Background for List
    Colors.greenAccent, // Background for Home
    Colors.orangeAccent, // Background for Add
  ];

  Color _currentBackgroundColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAnimatedAppBar(),
      drawer: _buildDrawer(),
      body: Container(
        color: _currentBackgroundColor,
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 700),
          reverse: _currentIndex != 1,
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: _buildAnimatedBottomNavigationBar(),
    );
  }

  // AppBar with animation
  PreferredSizeWidget _buildAnimatedAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [Image.asset('assets/images/logo.png')],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _currentIndex == 0
                  ? Colors.blue
                  : (_currentIndex == 1 ? Colors.green : Colors.orange),
              Colors.grey
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text(
        'Yeşil Piyasa',
        style: GoogleFonts.pacifico(
          textStyle: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 12,
      shadowColor: Colors.black38,
    );
  }

  // Animated BottomNavigationBar as a method in HomeView
  Widget _buildAnimatedBottomNavigationBar() {
    return CurvedNavigationBar(
      height: 75,
      color: _currentIndex == 0
          ? Colors.blue
          : (_currentIndex == 1 ? Colors.green : Colors.orange),
      backgroundColor: Colors.white,
      items: <Widget>[
        ClayContainer(
          spread: 1,
          borderRadius: 25,
          color: _currentIndex == 0 ? Colors.blue : Colors.white,
          height: 50,
          width: 50,
          child: const Icon(Icons.list, size: 30),
        ),
        ClayContainer(
          spread: 1,
          borderRadius: 25,
          color: _currentIndex == 1 ? Colors.green : Colors.white,
          height: 50,
          width: 50,
          child: const Icon(Icons.home, size: 30),
        ),
        ClayContainer(
          spread: 1,
          borderRadius: 25,
          color: _currentIndex == 2 ? Colors.orange : Colors.white,
          height: 50,
          width: 50,
          child: const Icon(Icons.add, size: 30),
        ),
      ],
      onTap: (index) async {
        setState(() {
          _currentIndex = index;
          _currentBackgroundColor = _backgroundColors[index];
        });
      },
    );
  }

  // Drawer without animation
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _currentIndex == 0
                  ? Colors.blue
                  : (_currentIndex == 1 ? Colors.green : Colors.orange),
              Colors.grey
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/doga.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.person,
              text: "profile".tr(),
              onTap: () => _navigateTo(context, const ProfileView()),
            ),
            const Divider(color: Colors.white70, thickness: 1),
            _buildDrawerItem(
              icon: Icons.local_shipping,
              text: 'cargo_transport'.tr(),
              onTap: () => _navigateTo(context, const TruckDriversView()),
            ),
            _buildDrawerItem(
              icon: Icons.favorite,
              text: 'favorites'.tr(),
              onTap: () => _navigateTo(context, const FavoritesView()),
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'settings'.tr(),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsView(),
                  ),
                );
                if (true) {
                  print('Dönen değer: $result');
                  setState(() {
                    // state değişikliklerini burada uygulayın.
                  });
                }
              },
            ),
            const Divider(color: Colors.white70, thickness: 1),
            _buildDrawerItem(
              icon: Icons.info,
              text: 'about'.tr(),
              onTap: () => _navigateTo(context, const AboutView()),
            ),
            _buildDrawerItem(
              icon: Icons.report,
              text: 'report'.tr(),
              onTap: () => _navigateTo(context, const ReportView()),
            ),
            const Divider(color: Colors.white70, thickness: 1),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'logout'.tr(),
              iconColor: Colors.red,
              onTap: () => signOut(context),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer item widget
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = Colors.black,
    Color textColor = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text, style: TextStyle(color: textColor)),
      onTap: onTap,
    ).animate().slideX(curve: Curves.easeInOut, delay: 100.ms);
  }

  void _navigateTo(BuildContext context, Widget view) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => view));
  }

  Future<bool> signOut(BuildContext context) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    return await userModel.signOut();
  }
}
