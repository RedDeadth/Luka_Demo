import 'package:flutter/material.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({Key? key}) : super(key: key);

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cupones',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Pasados'),
                Tab(text: 'Activos'),
              ],
            ),
          ),
          
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Cupones Pasados
                _buildCouponsListPast(),
                // Cupones Activos
                _buildCouponsListActive(),
              ],
            ),
          ),
        ],
      ),
      
      // Bottom Navigation
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildCouponsListActive() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildActiveCoupon(
          title: 'Cupon de recoleccion de ropa',
          subtitle: 'Aprovecha este\n02/12/2026\nCodigo\n123456789QF',
          value: '12 LUKAS',
          backgroundColor: Colors.black,
          iconColor: Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildActiveCoupon(
          title: 'Descuento en comida',
          subtitle: 'Válido hasta\n15/01/2026\nCodigo\n987654321AB',
          value: '25 LUKAS',
          backgroundColor: Colors.blue,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildActiveCoupon(
          title: 'Cupón de bebidas',
          subtitle: 'Válido hasta\n20/03/2026\nCodigo\n456789123CD',
          value: '8 LUKAS',
          backgroundColor: Colors.purple,
          iconColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildCouponsListPast() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildPastCoupon(
          title: 'Descuento cafetería',
          subtitle: 'Expirado\n15/11/2024\nCodigo\n111222333DD',
          value: '15 LUKAS',
        ),
        const SizedBox(height: 16),
        _buildPastCoupon(
          title: 'Cupón de transporte',
          subtitle: 'Expirado\n10/10/2024\nCodigo\n444555666EE',
          value: '20 LUKAS',
        ),
        const SizedBox(height: 16),
        _buildPastCoupon(
          title: 'Descuento librería',
          subtitle: 'Expirado\n05/09/2024\nCodigo\n777888999FF',
          value: '30 LUKAS',
        ),
      ],
    );
  }

  Widget _buildActiveCoupon({
    required String title,
    required String subtitle,
    required String value,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Contenido del cupón
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Icono y valor
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_offer,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPastCoupon({
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Contenido del cupón
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Icono y valor (deshabilitado)
          Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_offer,
                  color: Colors.grey.shade600,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
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
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Navegación aquí
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
              color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/campanas.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
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
              child: Image.asset(
                'assets/images/scan.png',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/tienda.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
            ),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/perfil.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 4 ? Colors.blue : Colors.grey,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}