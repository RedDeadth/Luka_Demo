import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'store_screen.dart';

class PurchaseSuccessVoucherScreen extends StatelessWidget {
  final List<CartItem> purchasedItems;
  final double totalAmount;
  final double newBalance;
  final String transactionId;

  const PurchaseSuccessVoucherScreen({
    Key? key,
    required this.purchasedItems,
    required this.totalAmount,
    required this.newBalance,
    required this.transactionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3), // Azul como el QR voucher
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Compra Exitosa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showPurchaseDetails(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Logo y título
          Column(
            children: [
              const Text(
                '¡Compra Realizada!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Logo Luka
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/luka_moneda.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Luka Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Voucher Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Icono de éxito
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 50,
                      color: Colors.green.shade600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Total gastado
                  Text(
                    '${totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'LUKAS gastadas',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/luka_moneda.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Nuevo saldo
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Nuevo saldo: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${newBalance.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
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

                  const SizedBox(height: 30),

                  // Lista de productos comprados
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Productos comprados:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Expanded(
                            child: ListView.builder(
                              itemCount: purchasedItems.length,
                              itemBuilder: (context, index) {
                                final item = purchasedItems[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'x${item.quantity}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${item.totalPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Image.asset(
                                        'assets/images/luka_moneda.png',
                                        width: 16,
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Información de la transacción
                          _buildInfoRow(
                            'ID Transacción',
                            transactionId,
                            showCopy: true,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow('Fecha', _getCurrentDateTime()),
                          const SizedBox(height: 8),
                          _buildInfoRow('Terminal', 'LUKA-STORE-001'),

                          const SizedBox(height: 30),

                          // Botones inferiores
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Botón Home
                              GestureDetector(
                                onTap: () {
                                  // Volver al home y pasar el nuevo saldo
                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst);
                                },
                                child: _buildActionButton(
                                  Icons.home,
                                  'Home',
                                  Colors.grey,
                                ),
                              ),

                              // Botón Compartir
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Funcionalidad de compartir próximamente',
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: _buildActionButton(
                                  Icons.share,
                                  'Compartir',
                                  Colors.grey,
                                ),
                              ),

                              // Botón Continuar Comprando
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); // Volver a la tienda
                                },
                                child: _buildActionButton(
                                  Icons.shopping_cart,
                                  'Seguir\nComprando',
                                  Colors.blue,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color:
                color == Colors.blue
                    ? Colors.blue.shade100
                    : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool showCopy = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (showCopy) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                },
                child: const Icon(Icons.copy, size: 16, color: Colors.grey),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return '${now.day} de ${months[now.month - 1]}, ${now.year}';
  }

  void _showPurchaseDetails(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Detalles de la Compra'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID Transacción: $transactionId'),
                const SizedBox(height: 8),
                Text('Total gastado: ${totalAmount.toStringAsFixed(0)} LUKAS'),
                const SizedBox(height: 8),
                Text('Nuevo saldo: ${newBalance.toStringAsFixed(0)} LUKAS'),
                const SizedBox(height: 8),
                Text('Productos: ${purchasedItems.length} artículos'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}
