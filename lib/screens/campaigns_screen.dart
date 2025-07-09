import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/user_manager.dart';
import 'campaign_detail_screen.dart';
import 'bottom_navigation_widget.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({Key? key}) : super(key: key);

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  List<Map<String, dynamic>> _campaigns = [];
  bool _isLoading = true;
  double _userBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Cargar campañas desde la base de datos
      final campaigns = await SupabaseService.getCampaigns();
      
      // Obtener saldo del usuario
      _userBalance = UserManager.balance;

      setState(() {
        _campaigns = campaigns;
      });
    } catch (e) {
      print('Error cargando campañas: $e');
      // Usar campañas por defecto si falla la conexión
      _loadDefaultCampaigns();
    }

    setState(() => _isLoading = false);
  }

  void _loadDefaultCampaigns() {
    _campaigns = [
      {
        'id': 1,
        'nombre': 'Limpieza de Playas',
        'descripcion': 'Únete a nuestra campaña de limpieza de playas y ayuda a proteger el medio ambiente.',
        'presupuesto': 2000.0,
        'fecha_inicio': '2025-07-15',
        'fecha_fin': '2025-07-30',
        'lugar': 'Playa Costa Verde',
      },
      {
        'id': 2,
        'nombre': 'Reforestación',
        'descripcion': 'Plantación de árboles en el campus universitario.',
        'presupuesto': 1500.0,
        'fecha_inicio': '2025-08-01',
        'fecha_fin': '2025-08-15',
        'lugar': 'Campus TecSup',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
          'Campañas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Saldo disponible
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                const Text(
                  'Tu saldo: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _userBalance.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
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
          ),
          
          const SizedBox(height: 20),
          
          // Lista de campañas de la base de datos
          if (_campaigns.isEmpty)
            const Center(
              child: Text(
                'No hay campañas disponibles',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ..._campaigns.map((campaign) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CampaignDetailScreen(
                        title: campaign['nombre'] ?? 'Campaña',
                        logo: 'images (3).jpg', // Logo por defecto
                        description: campaign['descripcion'] ?? 'Sin descripción',
                        targetAmount: (campaign['presupuesto'] ?? 0).toStringAsFixed(0),
                        currentAmount: _calculateProgress(campaign['presupuesto'] ?? 0),
                        daysLeft: _calculateDaysLeft(campaign['fecha_fin']),
                        participants: '127', // Valor por defecto
                      ),
                    ),
                  );
                },
                child: _buildCampaignCard(
                  campaign['nombre'] ?? 'Campaña',
                  campaign['descripcion'] ?? 'Sin descripción',
                  _getProgressAmount(campaign['presupuesto'] ?? 0),
                  (campaign['presupuesto'] ?? 0).toInt(),
                  int.parse(_calculateDaysLeft(campaign['fecha_fin'])),
                  127, // Participantes por defecto
                  _getCampaignImage(campaign['nombre']),
                  _getCampaignColor(campaign['id'] ?? 1),
                ),
              ),
            )).toList(),
        ],
      ),
      
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 1),
    );
  }

  String _calculateProgress(double budget) {
    // Simular progreso entre 40% y 80%
    final progress = 0.4 + (0.4 * (budget / 5000));
    return (budget * progress).toInt().toString();
  }

  int _getProgressAmount(double budget) {
    final progress = 0.4 + (0.4 * (budget / 5000));
    return (budget * progress).toInt();
  }

  String _calculateDaysLeft(String? endDate) {
    if (endDate == null) return '30';
    
    try {
      final end = DateTime.parse(endDate);
      final now = DateTime.now();
      final difference = end.difference(now).inDays;
      return difference > 0 ? difference.toString() : '0';
    } catch (e) {
      return '30';
    }
  }

  String _getCampaignImage(String? name) {
    if (name == null) return 'images (3).jpg';
    
    final imageMap = {
      'Limpieza de Playas': 'logo OFICIAL azul 2023 (1)_Mesa de trabajo 1 copia 4.png',
      'Reforestación': 'tt.png',
      'Donación de Ropa': 'images (3).jpg',
      'Educación para Niños': 'southernPerucuadrado.png',
    };
    
    return imageMap[name] ?? 'images (3).jpg';
  }

  Color _getCampaignColor(int id) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.teal, Colors.purple];
    return colors[id % colors.length];
  }

  Widget _buildCampaignCard(
    String title,
    String subtitle,
    int currentAmount,
    int targetAmount,
    int daysLeft,
    int participants,
    String imageName,
    Color color,
  ) {
    double progress = targetAmount > 0 ? currentAmount / targetAmount : 0;
    
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
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/$imageName',
                    width: 35,
                    height: 35,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.campaign, color: color, size: 35);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                      subtitle.length > 50 ? '${subtitle.substring(0, 50)}...' : subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$daysLeft días',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '$participants personas',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Barra de progreso
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress > 1.0 ? 1.0 : progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Montos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Recaudado: $currentAmount',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    'assets/images/luka_moneda.png',
                    width: 14,
                    height: 14,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Meta: $targetAmount',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    'assets/images/luka_moneda.png',
                    width: 14,
                    height: 14,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}