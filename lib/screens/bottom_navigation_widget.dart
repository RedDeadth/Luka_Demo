import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'campaigns_screen.dart';
import 'store_screen.dart';
import 'profile_screen.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final bool isDarkMode;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _handleNavigation(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: isDarkMode ? Colors.grey.shade400 : Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home.png',
              width: 24,
              height: 24,
              color: currentIndex == 0 ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/campanas.png',
              width: 24,
              height: 24,
              color: currentIndex == 1 ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
            ),
            label: 'Campañas',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 24,
              ),
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/tienda.png',
              width: 24,
              height: 24,
              color: currentIndex == 3 ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
            ),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/perfil.png',
              width: 24,
              height: 24,
              color: currentIndex == 4 ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currentIndex != 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
        break;
      case 1:
        if (currentIndex != 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CampaignsScreen()),
          );
        }
        break;
      case 2:
        // QR Scanner - próximamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR Scanner - Próximamente'),
            duration: Duration(seconds: 1),
          ),
        );
        break;
      case 3:
        if (currentIndex != 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StoreScreen()),
          );
        }
        break;
      case 4:
        if (currentIndex != 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
        break;
    }
  }
}