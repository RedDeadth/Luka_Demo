import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/user_manager.dart';
import 'bottom_navigation_widget.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({Key? key}) : super(key: key);

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _missions = [];
  Map<String, int> _userProgress = {};
  bool _isLoading = true;
  bool _hasNewCompletedMissions = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMissions() async {
    setState(() => _isLoading = true);

    try {
      // Crear misiones por defecto si no existen
      await SupabaseService.createDefaultMissions();

      // Cargar progreso del usuario
      _userProgress = await SupabaseService.getUserProgress(UserManager.userId);

      // Verificar y completar misiones automáticamente
      final newCompletedMissions =
          await SupabaseService.checkAndCompleteMissions(UserManager.userId);

      if (newCompletedMissions.isNotEmpty) {
        setState(() => _hasNewCompletedMissions = true);
        _showMissionCompletedDialog(newCompletedMissions);
      }

      // Cargar misiones actualizadas
      final missions = await SupabaseService.getMissions();

      setState(() {
        _missions = missions;
      });
    } catch (e) {
      print('Error cargando misiones: $e');
      _loadDefaultMissions();
    }

    setState(() => _isLoading = false);
  }

  void _loadDefaultMissions() {
    _missions = [
      {
        'id': 1,
        'nombre': 'Primera Compra',
        'descripcion': 'Realiza tu primera compra en la tienda',
        'puntos': 100,
        'completada': _userProgress['purchases']! >= 1,
      },
      {
        'id': 2,
        'nombre': 'Compra 2 bebidas',
        'descripcion': 'Compra 2 bebidas en la tienda',
        'puntos': 150,
        'completada': _userProgress['drinks']! >= 2,
      },
      {
        'id': 3,
        'nombre': 'Comprar 5 productos',
        'descripcion': 'Realiza 5 compras diferentes',
        'puntos': 200,
        'completada': _userProgress['purchases']! >= 5,
      },
      {
        'id': 4,
        'nombre': 'Gastar 100 LUKAS',
        'descripcion': 'Gasta un total de 100 LUKAS',
        'puntos': 250,
        'completada': _userProgress['total_spent']! >= 100,
      },
      {
        'id': 5,
        'nombre': 'Participar en 3 campañas',
        'descripcion': 'Únete a 3 campañas diferentes',
        'puntos': 300,
        'completada': _userProgress['campaigns']! >= 3,
      },
      {
        'id': 6,
        'nombre': 'Usar 3 cupones',
        'descripcion': 'Utiliza 3 cupones diferentes',
        'puntos': 200,
        'completada': _userProgress['coupons']! >= 3,
      },
    ];
  }

  void _showMissionCompletedDialog(
    List<Map<String, dynamic>> completedMissions,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text('¡Misión Completada!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Felicidades, has completado:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                ...completedMissions
                    .map(
                      (mission) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mission['nombre'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/luka_moneda.png',
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '+${mission['puntos']} puntos',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() => _hasNewCompletedMissions = false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('¡Genial!'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadMissions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Información del progreso del usuario
          Container(
            margin: const EdgeInsets.all(16),
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
                const Text(
                  'Tu Progreso',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildProgressItem(
                      'Compras',
                      _userProgress['purchases']?.toString() ?? '0',
                      Icons.shopping_bag,
                      Colors.blue,
                    ),
                    _buildProgressItem(
                      'Gastado',
                      '${_userProgress['total_spent'] ?? 0}',
                      Icons.monetization_on,
                      Colors.green,
                    ),
                    _buildProgressItem(
                      'Bebidas',
                      _userProgress['drinks']?.toString() ?? '0',
                      Icons.local_drink,
                      Colors.orange,
                    ),
                    _buildProgressItem(
                      'Campañas',
                      _userProgress['campaigns']?.toString() ?? '0',
                      Icons.campaign,
                      Colors.purple,
                    ),
                  ],
                ),
              ],
            ),
          ),

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
              tabs: const [Tab(text: 'Pendientes'), Tab(text: 'Completadas')],
            ),
          ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildPendingMissions(), _buildCompletedMissions()],
            ),
          ),

          // Logros section
          _buildAchievementsSection(),
        ],
      ),

      bottomNavigationBar: buildBottomNavigation(context, 1),
    );
  }

  Widget _buildProgressItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 10, color: color.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingMissions() {
    final pendingMissions =
        _missions.where((m) => m['completada'] != true).toList();

    if (pendingMissions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              '¡Felicidades!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Has completado todas las misiones',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: pendingMissions.length,
      itemBuilder: (context, index) {
        final mission = pendingMissions[index];
        return _buildMissionCard(mission, isCompleted: false);
      },
    );
  }

  Widget _buildCompletedMissions() {
    final completedMissions =
        _missions.where((m) => m['completada'] == true).toList();

    if (completedMissions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay misiones completadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Completa misiones para verlas aquí',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: completedMissions.length,
      itemBuilder: (context, index) {
        final mission = completedMissions[index];
        return _buildMissionCard(mission, isCompleted: true);
      },
    );
  }

  Widget _buildMissionCard(
    Map<String, dynamic> mission, {
    required bool isCompleted,
  }) {
    final progress = _calculateProgress(mission);
    final icon = _getMissionIcon(mission['nombre']);
    final color = _getMissionColor(mission['nombre']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isCompleted
                ? Border.all(color: Colors.green.shade200, width: 2)
                : null,
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
                  color:
                      isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : icon,
                  color: isCompleted ? Colors.green : color,
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
                      mission['nombre'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.green : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mission['descripcion'],
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                        'assets/images/luka_moneda.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${mission['puntos']} pts',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? Colors.green : Colors.orange,
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
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Text(
                  _getProgressText(mission),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  double _calculateProgress(Map<String, dynamic> mission) {
    final name = mission['nombre'];

    switch (name) {
      case 'Primera Compra':
      case 'Primera compra':
        return _userProgress['purchases']! >= 1 ? 1.0 : 0.0;
      case 'Compra 2 bebidas':
        return (_userProgress['drinks']! / 2).clamp(0.0, 1.0);
      case 'Comprar 5 productos':
        return (_userProgress['purchases']! / 5).clamp(0.0, 1.0);
      case 'Gastar 100 LUKAS':
        return (_userProgress['total_spent']! / 100).clamp(0.0, 1.0);
      case 'Participar en 3 campañas':
        return (_userProgress['campaigns']! / 3).clamp(0.0, 1.0);
      case 'Usar 3 cupones':
        return (_userProgress['coupons']! / 3).clamp(0.0, 1.0);
      default:
        return 0.0;
    }
  }

  String _getProgressText(Map<String, dynamic> mission) {
    final name = mission['nombre'];

    switch (name) {
      case 'Primera Compra':
      case 'Primera compra':
        return _userProgress['purchases']! >= 1
            ? 'Completada'
            : 'Realiza tu primera compra';
      case 'Compra 2 bebidas':
        return '${_userProgress['drinks']}/2 bebidas';
      case 'Comprar 5 productos':
        return '${_userProgress['purchases']}/5 productos';
      case 'Gastar 100 LUKAS':
        return '${_userProgress['total_spent']}/100 LUKAS';
      case 'Participar en 3 campañas':
        return '${_userProgress['campaigns']}/3 campañas';
      case 'Usar 3 cupones':
        return '${_userProgress['coupons']}/3 cupones';
      default:
        return '';
    }
  }

  IconData _getMissionIcon(String missionName) {
    switch (missionName) {
      case 'Primera Compra':
      case 'Primera compra':
        return Icons.shopping_bag;
      case 'Compra 2 bebidas':
        return Icons.local_drink;
      case 'Comprar 5 productos':
        return Icons.shopping_cart;
      case 'Gastar 100 LUKAS':
        return Icons.monetization_on;
      case 'Participar en 3 campañas':
        return Icons.campaign;
      case 'Usar 3 cupones':
        return Icons.local_offer;
      default:
        return Icons.star;
    }
  }

  Color _getMissionColor(String missionName) {
    switch (missionName) {
      case 'Primera Compra':
      case 'Primera compra':
        return Colors.green;
      case 'Compra 2 bebidas':
        return Colors.orange;
      case 'Comprar 5 productos':
        return Colors.blue;
      case 'Gastar 100 LUKAS':
        return Colors.amber;
      case 'Participar en 3 campañas':
        return Colors.purple;
      case 'Usar 3 cupones':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildAchievementsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logros Desbloqueados',
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
                title: 'Consumidor\nPromedio',
                imagePath: 'assets/images/ConsumidorPromedio.png',
                isUnlocked: _userProgress['purchases']! >= 1,
              ),
              _buildAchievementBadge(
                title: 'Consumidor\nAbismal',
                imagePath: 'assets/images/consumidorabismal.png',
                isUnlocked: _userProgress['purchases']! >= 5,
              ),
              _buildAchievementBadge(
                title: 'Eco\nWarrior',
                imagePath: 'assets/images/geurrero ecologico.png',
                isUnlocked: _userProgress['campaigns']! >= 1,
              ),
              _buildAchievementBadge(
                title: 'Master\nBuyer',
                imagePath: 'assets/images/Comprador maestro.png',
                isUnlocked: _userProgress['total_spent']! >= 100,
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
    return GestureDetector(
      onTap: () {
        _showAchievementDetails(title, isUnlocked);
      },
      child: Column(
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
              child: Stack(
                children: [
                  ColorFiltered(
                    colorFilter:
                        isUnlocked
                            ? const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.multiply,
                            )
                            : const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            ),
                    child: Image.asset(
                      imagePath,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (!isUnlocked)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                ],
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
      ),
    );
  }

  void _showAchievementDetails(String title, bool isUnlocked) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  isUnlocked ? Icons.stars : Icons.lock,
                  color: isUnlocked ? Colors.amber : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(title.replaceAll('\n', ' ')),
              ],
            ),
            content: Text(
              isUnlocked
                  ? '¡Felicidades! Has desbloqueado este logro.'
                  : 'Este logro aún no está desbloqueado. Continúa completando misiones para obtenerlo.',
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
}
