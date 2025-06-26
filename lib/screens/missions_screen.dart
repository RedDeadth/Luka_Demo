import 'package:flutter/material.dart';
import 'RankingScreen.dart'; // Ajusta esta ruta según tu estructura de archivos
import 'bottom_navigation_widget.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({Key? key}) : super(key: key);

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> with TickerProviderStateMixin {
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
          'Misiones',
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
                Tab(text: 'Completas'),
                Tab(text: 'Incompletas'),
              ],
            ),
          ),
          
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Misiones Completas
                _buildCompletedMissions(),
                // Misiones Incompletas
                _buildIncompleteMissions(),
              ],
            ),
          ),
          
          // Logros section
          _buildAchievementsSection(),
        ],
      ),
      
      // Bottom Navigation con índice 1 (puede ser campañas)
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
    );
  }

  Widget _buildCompletedMissions() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildMissionCard(
          title: 'Compra 1 gaseosa',
          description: 'Porcentaje de la meta alcanzado',
          progress: 1.0,
          reward: '5 XP',
          isCompleted: true,
          icon: Icons.local_drink,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildMissionCard(
          title: 'Donar ropa usada',
          description: 'Meta completada exitosamente',
          progress: 1.0,
          reward: '25 XP',
          isCompleted: true,
          icon: Icons.checkroom,
          iconColor: Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildMissionCard(
          title: 'Reciclar 10 botellas',
          description: 'Misión ecológica completada',
          progress: 1.0,
          reward: '15 XP',
          isCompleted: true,
          icon: Icons.recycling,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildMissionCard(
          title: 'Participar en campaña',
          description: 'Primera participación exitosa',
          progress: 1.0,
          reward: '30 XP',
          isCompleted: true,
          icon: Icons.campaign,
          iconColor: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildIncompleteMissions() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildMissionCard(
          title: 'Compra 2 gaseosa',
          description: 'Estado de la campaña',
          progress: 0.5,
          reward: '10 XP',
          isCompleted: false,
          icon: Icons.local_drink,
          iconColor: Colors.orange,
        ),
        const SizedBox(height: 16),
        _buildMissionCard(
          title: 'Participar en 3 campañas',
          description: 'Progreso: 1/3 campañas',
          progress: 0.33,
          reward: '50 XP',
          isCompleted: false,
          icon: Icons.campaign,
          iconColor: Colors.purple,
        ),
        const SizedBox(height: 16),
        _buildMissionCard(
          title: 'Comprar 5 productos',
          description: 'Progreso: 2/5 productos',
          progress: 0.4,
          reward: '20 XP',
          isCompleted: false,
          icon: Icons.shopping_bag,
          iconColor: Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildMissionCard(
          title: 'Usar 3 cupones',
          description: 'Progreso: 0/3 cupones',
          progress: 0.0,
          reward: '30 XP',
          isCompleted: false,
          icon: Icons.local_offer,
          iconColor: Colors.red,
        ),
        const SizedBox(height: 16),
        _buildMissionCard(
          title: 'Gastar 100 LUKAS',
          description: 'Progreso: 45/100 XP',
          progress: 0.45,
          reward: '25 XP',
          isCompleted: false,
          icon: Icons.monetization_on,
          iconColor: Colors.amber,
        ),
        const SizedBox(height: 16),
        _buildMissionCard(
          title: 'Invitar 2 amigos',
          description: 'Progreso: 0/2 amigos',
          progress: 0.0,
          reward: '40 XP',
          isCompleted: false,
          icon: Icons.person_add,
          iconColor: Colors.pink,
        ),
      ],
    );
  }

  Widget _buildMissionCard({
    required String title,
    required String description,
    required double progress,
    required String reward,
    required bool isCompleted,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icono de la misión
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Información de la misión
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Estado y recompensa
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '✓ Completa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Pendiente',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/xp.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        reward,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            // Barra de progreso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progreso: ${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                  minHeight: 6,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAchievementBadge(
                title: 'Consumidor\npromedio',
                imagePath: 'assets/images/ConsumidorPromedio.png',
                isUnlocked: true,
                
              ),
              _buildAchievementBadge(
                title: 'Consumidor\nAbismal',
                imagePath: 'assets/images/consumidorabismal.png',
                isUnlocked: true,
              ),
              _buildAchievementBadge(
                title: 'Eco\nWarrior',
                imagePath: 'assets/images/geurrero ecologico.png',
                isUnlocked: true,
              ),
              _buildAchievementBadge(
                title: 'Master\nBuyer',
                imagePath: 'assets/images/Comprador maestro.png',
                isUnlocked: true,
              ),
            ],
          ),
        
        ],
      ),
    );
  }

  Widget _buildAchievementBadge({
    required String title,
    required String imagePath,
    required bool isUnlocked,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (isUnlocked)
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColorFiltered(
              colorFilter: isUnlocked 
                ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isUnlocked ? Colors.black87 : Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}