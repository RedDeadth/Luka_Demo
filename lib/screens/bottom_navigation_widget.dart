import 'package:flutter/material.dart';
import '../services/user_manager.dart';
import '../screens/home_screen.dart';
import '../screens/RankingScreen.dart';
import '../screens/store_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/qrscanscreen.dart';

class SimpleBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final bool isDarkMode;

  const SimpleBottomNavigation({
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
        onTap: (index) => _navigateToScreen(context, index),
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
            label: 'Ranking',
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

  void _navigateToScreen(BuildContext context, int index) {
    // No hacer nada si ya estamos en la pantalla actual
    if (index == currentIndex) return;

    switch (index) {
      case 0: // Home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;
        
      case 1: // Ranking
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RankingScreen()),
        );
        break;
        
      case 2: // QR Scanner
        _handleQRScan(context);
        break;
        
      case 3: // Tienda
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StoreScreen(
              initialBalance: UserManager.balance,
            ),
          ),
        );
        break;
        
      case 4: // Perfil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  void _handleQRScan(BuildContext context) async {
    try {
      final result = await Navigator.push<int>(
        context,
        MaterialPageRoute(builder: (context) => const QRScannerScreen()),
      );

      if (result != null && result > 0) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Image.asset(
                  'assets/images/luka_moneda.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text('¡Ganaste $result Luka Points!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Manejar errores del QR scanner
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al abrir el escáner QR'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Función helper para usar en cualquier pantalla
Widget buildBottomNavigation(BuildContext context, int currentIndex, {bool isDarkMode = false}) {
  return SimpleBottomNavigation(
    currentIndex: currentIndex,
    isDarkMode: isDarkMode,
  );
}