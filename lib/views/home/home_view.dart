import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';
import 'package:yesil_piyasa/views/home/about_view.dart';
import 'package:yesil_piyasa/views/home/add_products.dart';
import 'package:yesil_piyasa/views/home/my_products.dart';
import 'package:yesil_piyasa/views/home/products.dart';
import 'package:yesil_piyasa/views/home/profile_view.dart';
import 'package:yesil_piyasa/views/home/report_view.dart';

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
  int _currentIndex = 1;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const MyProductsView(),
    const ProductsView(),
    const AddProductsView(),
  ];

  final List<Color> _backgroundColors = [
    const Color.fromARGB(255, 0, 254, 73), // Yeşil
    const Color.fromARGB(255, 2, 171, 250), // Mavi
    const Color.fromARGB(255, 249, 159, 2), // Turuncu
  ];

  final List<Color> _titleColors = [
    Colors.white,
    Colors.black,
    Colors.redAccent,
    Colors.deepPurple,
    Colors.deepOrangeAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.indigoAccent,
    Colors.lightGreenAccent,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.yellow,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.green,
    Colors.amberAccent,
    Colors.deepPurpleAccent,
    Colors.black87,
  ];

  Color _titleColor = Colors.white;
  late AnimationController _rotationController;

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

  // Rastgele başlık rengi seçimi
  void _changeTitleColor() {
    final random = Random();
    setState(() {
      _titleColor = _titleColors[random.nextInt(_titleColors.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAnimatedAppBar(),
      drawer: _buildAnimatedDrawer(),
      body: Container(
        color: _backgroundColors[_currentIndex],
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
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Animasyonlu AppBar
  PreferredSizeWidget _buildAnimatedAppBar() {
    return AppBar(
      backgroundColor: _backgroundColors[_currentIndex],
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      )
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .scaleXY(end: 1.1, curve: Curves.easeInOut),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Arama butonuna basıldığında yapılacak işlem (boş fonksiyon)
          },
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scaleXY(end: 1.1, curve: Curves.easeInOut),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundColors[_currentIndex], Colors.green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Animate(
        effects: const [
          SlideEffect(
            duration: Duration(milliseconds: 700),
            begin: Offset(-0.5, 0),
            curve: Curves.easeOut,
          ),
          FadeEffect(duration: Duration(milliseconds: 500))
        ],
        child: Text(
          'Yeşil Piyasa',
          style: GoogleFonts.pacifico(
            textStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _titleColor, // Rastgele renk buradan uygulanacak
            ),
          ),
        ),
      ),
      centerTitle: true,
      elevation: 12,
      shadowColor: Colors.black38,
    );
  }

  // Animasyonlu Drawer
  Widget _buildAnimatedDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
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
              text: 'Profil',
              onTap: () => _navigateTo(context, const ProfileView()),
            ),
            const Divider(color: Colors.white70, thickness: 1),
            _buildDrawerItem(
              icon: Icons.home,
              text: 'Ana Sayfa',
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            _buildDrawerItem(
              icon: Icons.add_circle,
              text: 'Ürün Ekle',
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
            _buildDrawerItem(
              icon: Icons.list,
              text: 'Ürünlerim',
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            const Divider(color: Colors.white70, thickness: 1),
            _buildDrawerItem(
              icon: Icons.info,
              text: 'Hakkımızda',
              onTap: () => _navigateTo(context, const AboutView()),
            ),
            _buildDrawerItem(
              icon: Icons.report,
              text: 'Şikayet Et',
              onTap: () => _navigateTo(context, const ReportView()),
            ),
            const Divider(color: Colors.white70, thickness: 1),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'Çıkış Yap',
              iconColor: Colors.red,
              onTap: () => signOut(context),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slide(begin: const Offset(-1, 0));
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

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return AnimatedBottomNavigationBar(
      icons: const [
        Icons.list,
        Icons.add_circle,
      ],
      activeIndex: _currentIndex == 1
          ? 0
          : _currentIndex == 0
              ? 0
              : 1,
      backgroundColor: _backgroundColors[_currentIndex],
      activeColor: Colors.white,
      inactiveColor: Colors.black,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      iconSize: 28,
      onTap: (index) {
        setState(() {
          _currentIndex = index == 0 ? 0 : 2;
        });
      },
      splashSpeedInMilliseconds: 300,
      leftCornerRadius: 25,
      rightCornerRadius: 25,
    ).animate().fadeIn(duration: 500.ms);
  }

  // Floating Action Button
  Widget _buildFloatingActionButton() {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_rotationController),
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 1;
            _changeTitleColor(); // Yeşil Piyasa yazısının rengini değiştir
          });
          _rotationController.forward(
              from: 0); // 360 derece döndürme animasyonu
        },
        backgroundColor: _backgroundColors[_currentIndex],
        child: Icon(Icons.home, color: _titleColor),
      ),
    );
  }

  Future<bool> signOut(BuildContext context) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    return await userModel.signOut();
  }
}
