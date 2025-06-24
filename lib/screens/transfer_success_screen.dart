import 'package:flutter/material.dart';

class TransferSuccessScreen extends StatelessWidget {
  final String title;
  final String amount;
  final String description;

  const TransferSuccessScreen({
    Key? key,
    required this.title,
    required this.amount,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPositive = amount.startsWith('+');
    final Color amountColor = isPositive ? Colors.green : Colors.red;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaccion Hoy a las 9:40',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          
          // Ilustración principal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Image.asset(
              'assets/images/transferencia.png',
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Título de la campaña/transacción
          Text(
            description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 30),
          
          // Monto con ícono
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/images/luka_moneda.png',
                width: 28,
                height: 28,
              ),
            ],
          ),
          
          const Spacer(),
          
          // Bottom Navigation (igual al del home)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomNavItem(
                      'assets/images/home.png',
                      'Home',
                      Colors.blue,
                      () => Navigator.popUntil(context, (route) => route.isFirst),
                    ),
                    _buildBottomNavItem(
                      'assets/images/campanas.png',
                      'Campañas',
                      Colors.grey,
                      () {},
                    ),
                    _buildBottomNavCenterItem(),
                    _buildBottomNavItem(
                      'assets/images/tienda.png',
                      'Tienda',
                      Colors.grey,
                      () {},
                    ),
                    _buildBottomNavItem(
                      'assets/images/perfil.png',
                      'Perfil',
                      Colors.grey,
                      () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(String iconPath, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavCenterItem() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          'assets/images/scan.png',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}