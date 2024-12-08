import 'package:flutter/material.dart';
import 'package:mktabte/features/home/presentation/screens/userwishlistscreen.dart';

import '../screens/allcategriesscreen.dart';
import '../screens/cartscreen.dart';
import '../screens/home.dart';
import '../screens/profilescreen.dart';


class MainBar extends StatefulWidget {
  const MainBar({super.key});

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  int _selectedScreenIndex = 0;

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = const HomePpage();
    if (_selectedScreenIndex == 1) {
      activeScreen = const CategryScreen();
    }
    if (_selectedScreenIndex == 2) {
      activeScreen = const CartScreen();
    }
    if (_selectedScreenIndex == 3) {
      activeScreen =  UserWishlist();
    }
    if (_selectedScreenIndex == 4) {
      activeScreen = const ProfileScreen();
    }

    return Scaffold(
      body: Stack(
        children: [
          activeScreen,
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: BottomNavigationBar(
                  onTap: _selectScreen,
                  currentIndex: _selectedScreenIndex,
                  unselectedItemColor: const Color.fromARGB(255, 141, 141, 141),
                  selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
                  backgroundColor: Colors.transparent,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.grid_view),
                      label: 'Categories',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart_outlined),
                      label: 'Cart',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border),
                      label: 'Wishlist',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      label: 'Profile',
                    ),
                  ],
                  type: BottomNavigationBarType.fixed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
