import 'package:flutter/material.dart';
import 'campaign_detail_screen.dart';
import 'bottom_navigation_widget.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({Key? key}) : super(key: key);

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
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
                const Text(
                  '1,500',
                  style: TextStyle(
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
          
          // PRIMERA CAMPAÑA - Donación de Ropa
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CampaignDetailScreen(
                    title: 'Donación de Ropa para Comunidades',
                    logo: 'images (3).jpg',
                    description: 'Ayuda a familias necesitadas donando ropa en buen estado. Tu contribución puede hacer la diferencia en la vida de muchas personas.',
                    targetAmount: '5000',
                    currentAmount: '3200',
                    daysLeft: '15',
                    participants: '127',
                  ),
                ),
              );
            },
            child: _buildCampaignCard(
              'Donación de Ropa para Comunidades',
              'Ayuda a familias necesitadas',
              3200,
              5000,
              15,
              127,
              'images (3).jpg',
              Colors.blue,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // SEGUNDA CAMPAÑA - Limpieza de Playas
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CampaignDetailScreen(
                    title: 'Limpieza de Playas',
                    logo: 'logo OFICIAL azul 2023 (1)_Mesa de trabajo 1 copia 4.png',
                    description: 'Únete a nuestra campaña de limpieza de playas y ayuda a proteger el medio ambiente. Juntos podemos hacer un cambio.',
                    targetAmount: '3000',
                    currentAmount: '1800',
                    daysLeft: '8',
                    participants: '89',
                  ),
                ),
              );
            },
            child: _buildCampaignCard(
              'Limpieza de Playas',
              'Protege el medio ambiente',
              1800,
              3000,
              8,
              89,
              'logo OFICIAL azul 2023 (1)_Mesa de trabajo 1 copia 4.png',
              Colors.green,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // TERCERA CAMPAÑA - Educación para Niños
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CampaignDetailScreen(
                    title: 'Educación para Niños',
                    logo: 'southernPerucuadrado.png',
                    description: 'Apoya la educación de niños en zonas rurales. Tu donación ayudará a comprar materiales escolares y libros.',
                    targetAmount: '8000',
                    currentAmount: '4500',
                    daysLeft: '22',
                    participants: '203',
                  ),
                ),
              );
            },
            child: _buildCampaignCard(
              'Educación para Niños',
              'Materiales escolares',
              4500,
              8000,
              22,
              203,
              'southernPerucuadrado.png',
              Colors.orange,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // CUARTA CAMPAÑA - Reforestación Urbana
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CampaignDetailScreen(
                    title: 'Reforestación Urbana',
                    logo: 'tt.png',
                    description: 'Ayuda a plantar árboles en la ciudad para mejorar la calidad del aire y crear espacios verdes.',
                    targetAmount: '6000',
                    currentAmount: '2100',
                    daysLeft: '30',
                    participants: '156',
                  ),
                ),
              );
            },
            child: _buildCampaignCard(
              'Reforestación Urbana',
              'Planta árboles en la ciudad',
              2100,
              6000,
              30,
              156,
              'tt.png',
              Colors.teal,
            ),
          ),
        ],
      ),
      
      // Bottom Navigation con índice 1 (Campañas)
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
    );
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
    double progress = currentAmount / targetAmount;
    
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
                      subtitle,
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
                  value: progress,
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