import 'package:flutter/material.dart';
import '../services/user_manager.dart';
import '../services/supabase_service.dart';
import 'sign_in_screen.dart';
import 'home_screen.dart';
import 'RankingScreen.dart';
import 'store_screen.dart';
import 'qrscanscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  int _selectedIndex = 4;
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Perfil',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Avatar y datos del usuario - CONECTADO
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar con imagen
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/perfil_user.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _showEditProfileDialog();
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Etiqueta de estudiante
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Estudiante',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Nombre y email - DATOS REALES
                  Text(
                    UserManager.userName.isNotEmpty ? UserManager.userName : 'Usuario',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    UserManager.userEmail.isNotEmpty ? UserManager.userEmail : 'email@ejemplo.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Saldo actual
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Saldo: ${UserManager.balance.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        'assets/images/luka_moneda.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Opciones del perfil
            _buildProfileOption(
              icon: Icons.language,
              title: 'Idioma',
              subtitle: _selectedLanguage,
              onTap: () => _showLanguageDialog(),
            ),
            
            const SizedBox(height: 16),
            
            _buildProfileOption(
              icon: Icons.dark_mode,
              title: 'Modo Oscuro',
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                activeColor: Colors.blue,
              ),
              onTap: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildProfileOption(
              icon: Icons.account_circle,
              title: 'Información de cuenta',
              subtitle: 'Cuenta #${UserManager.accountNumber}',
              onTap: () => _showAccountInfoDialog(),
            ),
            
            const SizedBox(height: 16),
            
            _buildProfileOption(
              icon: Icons.help_outline,
              title: 'FAQ',
              onTap: () => _showFAQDialog(),
            ),
            
            const SizedBox(height: 40),
            
            // Botón de logout - FUNCIONAL
            GestureDetector(
              onTap: () => _showLogoutDialog(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      
      // Bottom Navigation - FUNCIONAL
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            trailing ?? Icon(
              Icons.chevron_right,
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
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
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if (index == _selectedIndex) return; // No hacer nada si ya estamos en esa pantalla
          
          setState(() {
            _selectedIndex = index;
          });
          
          // Navegación consistente
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
              final result = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (context) => const QRScannerScreen()),
              );
              if (result != null && result > 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡Ganaste $result Luka Points!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
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
            case 4: // Perfil - ya estamos aquí
              break;
          }
        },
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
              color: _selectedIndex == 0 ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/campanas.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
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
              color: _selectedIndex == 3 ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
            ),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/perfil.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 4 ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: const Text('Función de edición de perfil próximamente. Por ahora puedes ver tu información actual.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Español'),
              leading: Radio<String>(
                value: 'Español',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('English (US)'),
              leading: Radio<String>(
                value: 'English (US)',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showAccountInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información de Cuenta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${UserManager.userName}'),
            const SizedBox(height: 8),
            Text('Email: ${UserManager.userEmail}'),
            const SizedBox(height: 8),
            Text('ID Usuario: ${UserManager.userId}'),
            const SizedBox(height: 8),
            Text('Número de Cuenta: ${UserManager.accountNumber}'),
            const SizedBox(height: 8),
            Text('Saldo Actual: ${UserManager.balance.toStringAsFixed(0)} LUKAS'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFAQDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FAQ - Preguntas Frecuentes'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué son los Luka Points?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Los Luka Points son la moneda virtual de la plataforma para realizar compras y participar en campañas.'),
              SizedBox(height: 12),
              Text(
                '¿Cómo puedo ganar puntos?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Puedes ganar puntos escaneando códigos QR, completando misiones y participando en campañas.'),
              SizedBox(height: 12),
              Text(
                '¿Cómo uso los cupones?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Los cupones se pueden usar en la tienda para obtener descuentos en tus compras.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Limpiar datos del usuario
              UserManager.logout();
              
              // Cerrar dialog
              Navigator.pop(context);
              
              // Navegar al login y limpiar stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}