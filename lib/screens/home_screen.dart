import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/user_manager.dart';
import 'RankingScreen.dart';
import 'campaigns_screen.dart';
import 'accounts_screen.dart';
import 'transactions_screen.dart';
import 'transfer_success_screen.dart';
import 'coupons_screen.dart';
import 'store_screen.dart';
import 'missions_screen.dart';
import 'profile_screen.dart';
import 'qrscanscreen.dart';
import 'GenerateQrScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _notificationCount = 4;
  double _lukaPoints = 0.0; // Ahora viene de la base de datos
  List<TransactionData> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      // Obtener saldo actual del usuario
      if (UserManager.isLoggedIn) {
        final account = await SupabaseService.getUserAccount(UserManager.userId);
        if (account != null) {
          UserManager.setAccount(account);
          setState(() {
            _lukaPoints = UserManager.balance;
          });
        }

        // Cargar transacciones recientes
        final transactions = await SupabaseService.getRecentTransactions(UserManager.userId);
        _updateTransactionsList(transactions);
      }
    } catch (e) {
      print('Error cargando datos: $e');
      // Cargar datos por defecto si falla la conexión
      _initializeDefaultTransactions();
    }

    setState(() => _isLoading = false);
  }

  void _updateTransactionsList(List<Map<String, dynamic>> transactions) {
    setState(() {
      _transactions = transactions.map((t) {
        final isPositive = (t['total'] as num) > 0;
        return TransactionData(
          icon: isPositive ? 'ingreso.png' : 'egreso.png',
          title: isPositive ? 'Ingreso' : 'Compra realizada',
          time: _formatDateTime(t['fecha_venta']),
          amount: '${isPositive ? '+' : '-'}${(t['total'] as num).abs().toStringAsFixed(0)}',
          color: isPositive ? Colors.green : Colors.red,
          description: 'Transacción #${t['id']}',
        );
      }).toList();
    });
  }

  void _initializeDefaultTransactions() {
    _transactions = [
      TransactionData(
        icon: 'egreso.png',
        title: 'Compra uniformes',
        time: 'Ayer - 08:30am',
        amount: '-5',
        color: Colors.red,
        description: 'Campaña de Donación Solarinos',
      ),
      TransactionData(
        icon: 'egreso.png',
        title: 'Alquiler de oficina',
        time: 'Ayer - 05:30pm',
        amount: '-8',
        color: Colors.red,
        description: 'Pago mensual de oficina',
      ),
      TransactionData(
        icon: 'ingreso.png',
        title: 'Transferencia Recibida',
        time: 'Hoy - 09:30am',
        amount: '+18',
        color: Colors.green,
        description: 'Pago recibido de cliente',
      ),
    ];
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null) return 'Hoy';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;
      
      if (difference == 0) return 'Hoy - ${_formatTime(date)}';
      if (difference == 1) return 'Ayer - ${_formatTime(date)}';
      return '${date.day}/${date.month} - ${_formatTime(date)}';
    } catch (e) {
      return 'Hoy';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final amPm = hour >= 12 ? 'pm' : 'am';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}$amPm';
  }

  // Método para actualizar saldo después de compras/escaneos
  Future<void> _updateBalance(double newBalance) async {
    try {
      // Actualizar en la base de datos
      await SupabaseService.updateAccountBalance(UserManager.accountId, newBalance);
      
      // Actualizar localmente
      UserManager.updateBalance(newBalance);
      
      setState(() {
        _lukaPoints = newBalance;
      });
    } catch (e) {
      print('Error actualizando saldo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F8F8),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con perfil y notificación - DATOS REALES
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Avatar y info del usuario
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: const AssetImage('assets/images/person.jpg'),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserManager.userName.isNotEmpty ? UserManager.userName : 'Usuario',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'ID: ${UserManager.userId}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Botón de notificaciones con badge
                    GestureDetector(
                      onTap: () {
                        _showNotificationsModal();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/notificacion.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            if (_notificationCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    _notificationCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Iconos de categorías con navegación
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CampaignsScreen(),
                          ),
                        );
                      },
                      child: _buildCategoryIcon('Campañas', 'campanas123.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GenerateQrCodeScreen(),
                          ),
                        );
                      },
                      child: _buildCategoryIcon(
                        'Emitir Lukitas',
                        'emitir_lukitas.png',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MissionsScreen(),
                          ),
                        );
                      },
                      child: _buildCategoryIcon('Misiones', 'misiones.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CouponsScreen(),
                          ),
                        );
                      },
                      child: _buildCategoryIcon('Cupones', 'cupon.png'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Saldo actual - CONECTADO A LA BASE DE DATOS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LUKA POINTS',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _formatLukaPoints(_lukaPoints),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/luka_moneda.png',
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Mis Cuentas con navegación
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountsScreen(),
                    ),
                  );
                },
                child: _buildSectionHeader('Mis Cuentas', 'Ver todo'),
              ),

              // Información de cuenta real
              _buildAccountCard(
                'tecsup.png',
                'Cuenta: ${UserManager.accountNumber}',
                'Saldo actual',
                _lukaPoints.toStringAsFixed(0),
                Colors.blue,
              ),

              // Tarjeta adicional (puedes personalizar o quitar)
              _buildAccountCard(
                'cerro_verde.png',
                'Estado de la campaña',
                '',
                '3',
                Colors.green,
              ),

              const SizedBox(height: 20),

              // Últimas Transacciones - DATOS REALES
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionsScreen(),
                    ),
                  );
                },
                child: _buildSectionHeader('Últimas Transacciones', 'Ver todo'),
              ),

              // Lista de transacciones de la base de datos
              if (_transactions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'No hay transacciones recientes',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ..._transactions.map((transaction) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransferSuccessScreen(
                          title: transaction.title,
                          amount: transaction.amount,
                          description: transaction.description,
                        ),
                      ),
                    );
                  },
                  child: _buildTransactionItem(
                    transaction.icon,
                    transaction.title,
                    transaction.time,
                    transaction.amount,
                    transaction.color,
                  ),
                )).toList(),

              const SizedBox(height: 100), // Espacio para el bottom navigation
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar - ACTUALIZADO CON CALLBACK
      bottomNavigationBar: Container(
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
          onTap: (index) async {
            setState(() {
              _selectedIndex = index;
            });

            // Navegación del bottom navigation
            switch (index) {
              case 0:
                // Ya estamos en Home
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RankingScreen(),
                  ),
                );
                break;
              case 2:
                // QR Scanner - CON CALLBACK DE ACTUALIZACIÓN
                final result = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ),
                );

                if (result != null && result > 0) {
                  final newBalance = _lukaPoints + result;
                  await _updateBalance(newBalance);
                  _addQRTransaction(result);

                  if (mounted) {
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
                }
                break;
              case 3:
                // Tienda - CON CALLBACK DE ACTUALIZACIÓN
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreScreen(
                      initialBalance: _lukaPoints,
                      onBalanceUpdated: (newBalance) async {
                        await _updateBalance(newBalance);
                        final amountSpent = _lukaPoints - newBalance;
                        if (amountSpent > 0) {
                          _addPurchaseTransaction(
                            amountSpent,
                            'Productos de la tienda',
                          );
                        }
                      },
                    ),
                  ),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
                break;
            }
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
      ),
    );
  }

  // Métodos para manejar los puntos
  void _addLukaPoints(double points) {
    setState(() {
      _lukaPoints += points;
    });
  }

  String _formatLukaPoints(double points) {
    if (points >= 1000000) {
      return '${(points / 1000000).toStringAsFixed(1)}M';
    } else if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}K';
    } else {
      return points.toStringAsFixed(0);
    }
  }

  void _addQRTransaction(int pointsEarned) async {
  final now = DateTime.now();
  final timeFormat = _formatTime(now);

  setState(() {
    // Agregar la nueva transacción al inicio de la lista
    _transactions.insert(
      0,
      TransactionData(
        icon: 'ingreso.png',
        title: 'QR Escaneado',
        time: timeFormat,
        amount: '+$pointsEarned',
        color: Colors.green,
        description: 'Puntos obtenidos por escanear QR',
      ),
    );

    // Incrementar notificaciones
    _notificationCount++;
  });

  // NUEVA FUNCIONALIDAD: Verificar misiones después de escanear QR
  try {
    await SupabaseService.onQRScanned(UserManager.userId, pointsEarned);
  } catch (e) {
    print('Error verificando misiones después de QR: $e');
  }
}

void _updateLukaPoints(double newBalance) {
  setState(() {
    _lukaPoints = newBalance;
  });
}

void _addPurchaseTransaction(double amount, String description) async {
  final now = DateTime.now();
  final timeFormat = _formatTime(now);

  setState(() {
    // Agregar la nueva transacción al inicio de la lista
    _transactions.insert(
      0,
      TransactionData(
        icon: 'egreso.png',
        title: 'Compra en Tienda',
        time: timeFormat,
        amount: '-${amount.toStringAsFixed(0)}',
        color: Colors.red,
        description: description,
      ),
    );

    // Incrementar notificaciones
    _notificationCount++;
  });

  // NUEVA FUNCIONALIDAD: Verificar misiones después de compra
  try {
    final completedMissions = await SupabaseService.checkAndCompleteMissions(UserManager.userId);
    
    // Mostrar notificación si se completaron misiones
    if (completedMissions.isNotEmpty) {
      _showMissionCompletedSnackBar(completedMissions);
    }
  } catch (e) {
    print('Error verificando misiones después de compra: $e');
  }
}

// Agregar este método también al home_screen.dart
void _showMissionCompletedSnackBar(List<Map<String, dynamic>> completedMissions) {
  if (completedMissions.isEmpty) return;
  
  final totalPoints = completedMissions.fold<int>(
    0, 
    (sum, mission) => sum + (mission['puntos'] as int? ?? 0)
  );
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '¡Misión completada! +$totalPoints puntos',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Ver',
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MissionsScreen(),
            ),
          );
        },
      ),
    ),
  );
}

  // Resto de métodos existentes...
  void _showNotificationsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              if (_notificationCount > 0)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text(
                    '$_notificationCount new notifications',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _getNotifications().length,
                  itemBuilder: (context, index) {
                    final notification = _getNotifications()[index];
                    return _buildNotificationCardModal(notification);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<NotificationItemData> _getNotifications() {
    return [
      NotificationItemData(
        title: 'Compra cafetería',
        description:
            'You just made a transfer of 45.00 to Trevor Philips on November 18, 2024 at 09:31 AM. If you did not do this, please call 11223344 immediately.',
        time: 'Today • 09:31 AM',
        type: NotificationType.purchase,
        isNew: true,
      ),
      NotificationItemData(
        title: 'Compra menu',
        description:
            'You just made a purchase \$15.00 of Figma Professional on November 18, 2024 at 08:52 AM. If you did not do this, please call 11223344 immediately.',
        time: 'Today • 08:52 AM',
        type: NotificationType.purchase,
        isNew: true,
      ),
      NotificationItemData(
        title: 'Compra cafetería',
        description:
            'You just made a purchase \$9.99 of Youtube Premium on November 18, 2024 at 08:15 AM. If you did not do this, please call 11223344 immediately.',
        time: 'Today • 08:15 AM',
        type: NotificationType.purchase,
        isNew: true,
      ),
      NotificationItemData(
        title: 'Gracias por tu apoyo :)',
        description:
            'Add 10 lukitas to your Bank account from IT Company MediaTech on November 18, 2024 at 00:00 AM.',
        time: 'Today • 08:00 AM',
        type: NotificationType.reward,
        isNew: true,
      ),
      NotificationItemData(
        title: 'Transfer Out',
        description:
            'You just made a transfer of \$100.00 to Roger on November 17, 2024 at 09:12 AM. If you did not do this, please call 11223344 immediately.',
        time: 'Today • 09:12 AM',
        type: NotificationType.transfer,
        isNew: false,
      ),
      NotificationItemData(
        title: 'Freepick Subscription',
        description:
            'You just made a purchase \$59.00 of Freepick Premium on November 17, 2024 at 08:52 AM. If you did not do this, please call 11223344 immediately.',
        time: 'Today • 08:52 AM',
        type: NotificationType.subscription,
        isNew: false,
      ),
      NotificationItemData(
        title: 'Sportify Premium',
        description:
            'You just made a purchase \$9.99 of Sportify Premium on November 17, 2024 at 08:15 AM. If you did not do this, please call 11223344 immediately.',
        time: 'Today • 08:15 AM',
        type: NotificationType.subscription,
        isNew: false,
      ),
    ];
  }

  Widget _buildNotificationCardModal(NotificationItemData notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isNew ? Colors.purple.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              notification.isNew
                  ? Colors.purple.shade100
                  : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getNotificationColor(notification.type),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.purchase:
        return Colors.orange;
      case NotificationType.transfer:
        return Colors.grey;
      case NotificationType.subscription:
        return Colors.grey;
      case NotificationType.reward:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.purchase:
        return Icons.shopping_bag;
      case NotificationType.transfer:
        return Icons.send;
      case NotificationType.subscription:
        return Icons.subscriptions;
      case NotificationType.reward:
        return Icons.card_giftcard;
      default:
        return Icons.notifications;
    }
  }

  Widget _buildCategoryIcon(String title, String iconName) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
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
          child: Center(
            child: Image.asset(
              'assets/images/$iconName',
              width: 30,
              height: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            action,
            style: const TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
    String iconName,
    String title,
    String subtitle,
    String value,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/$iconName',
                width: 30,
                height: 30,
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
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
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
    );
  }

  Widget _buildTransactionItem(
    String iconName,
    String title,
    String time,
    String amount,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/$iconName',
                width: 20,
                height: 20,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Clase para manejar datos de transacciones
class TransactionData {
  final String icon;
  final String title;
  final String time;
  final String amount;
  final Color color;
  final String description;

  TransactionData({
    required this.icon,
    required this.title,
    required this.time,
    required this.amount,
    required this.color,
    required this.description,
  });
}

class NotificationItemData {
  final String title;
  final String description;
  final String time;
  final NotificationType type;
  final bool isNew;

  NotificationItemData({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    this.isNew = false,
  });
}

enum NotificationType { purchase, transfer, subscription, reward }