import 'package:flutter/material.dart';
import 'bottom_navigation_widget.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Ranking',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sección de logros con imágenes
            _buildAchievementsSection(),
            
            const SizedBox(height: 24),
            
            // Sección de ranking con estilo lineal
            _buildLinearRankingSection(context),
          ],
        ),
      ),
      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Tus Logros',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildAchievementBadge('assets/images/ConsumidorPromedio.png'),
                _buildAchievementBadge('assets/images/consumidorabismal.png'),
                _buildAchievementBadge('assets/images/geurrero ecologico.png'),
                _buildAchievementBadge('assets/images/Comprador maestro.png'),
              ].map((widget) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: widget,
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge(String imagePath) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLinearRankingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Division diamante',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  _buildRankedUser(
                    position: 1,
                    name: 'estefano',
                    exp: 25,
                    positionColor: const Color(0xFFFFD700),
                    containerColor: const Color(0xFFFFD700).withAlpha(51),
                  ),
                  _buildRankedUser(
                    position: 2,
                    name: 'Santiago camargo',
                    exp: 15,
                    positionColor: const Color(0xFFC0C0C0),
                    containerColor: const Color(0xFFC0C0C0).withAlpha(51),
                  ),
                  _buildRankedUser(
                    position: 3,
                    name: 'Nicol Chero',
                    exp: 5,
                    positionColor: const Color(0xFFCD7F32),
                    containerColor: const Color(0xFFCD7F32).withAlpha(51),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankedUser({
    required int position,
    required String name,
    required int exp,
    required Color positionColor,
    required Color containerColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: positionColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: positionColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              position.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
          textAlign: TextAlign.center,
        ),
        trailing: Text(
          '$exp EXP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: positionColor,
          ),
        ),
      ),
    );
  }
}