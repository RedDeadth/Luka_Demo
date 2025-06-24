import 'package:flutter/material.dart';
import 'transfer_success_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
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
          'Transacciones',
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
          // Sección: Hoy
          const Text(
            'Hoy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferSuccessScreen(
                    title: 'Transferencia Recibida',
                    amount: '+18',
                    description: 'Campaña de Donación Solarinos',
                  ),
                ),
              );
            },
            child: _buildTransactionItem(
              'ingreso.png',
              'Transferencia Recibida',
              'Hoy - 09:30am',
              '+18',
              Colors.green,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sección: Ayer
          const Text(
            'Ayer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferSuccessScreen(
                    title: 'Compra uniformes',
                    amount: '-5',
                    description: 'Campaña de Donación Solarinos',
                  ),
                ),
              );
            },
            child: _buildTransactionItem(
              'egreso.png',
              'Compra uniformes',
              'Ayer - 08:30am',
              '-5',
              Colors.red,
            ),
          ),
          
          const SizedBox(height: 12),
          
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferSuccessScreen(
                    title: 'Alquiler de oficina',
                    amount: '-8',
                    description: 'Pago mensual de oficina',
                  ),
                ),
              );
            },
            child: _buildTransactionItem(
              'egreso.png',
              'Alquiler de oficina',
              'Ayer - 05:30pm',
              '-8',
              Colors.red,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Sección: Esta semana
          const Text(
            'Esta semana',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferSuccessScreen(
                    title: 'Donación a campaña',
                    amount: '+25',
                    description: 'Campaña de Reforestación',
                  ),
                ),
              );
            },
            child: _buildTransactionItem(
              'ingreso.png',
              'Donación a campaña',
              'Lunes - 02:15pm',
              '+25',
              Colors.green,
            ),
          ),
          
          const SizedBox(height: 12),
          
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferSuccessScreen(
                    title: 'Compra de materiales',
                    amount: '-12',
                    description: 'Materiales para proyecto',
                  ),
                ),
              );
            },
            child: _buildTransactionItem(
              'egreso.png',
              'Compra de materiales',
              'Domingo - 11:45am',
              '-12',
              Colors.red,
            ),
          ),
          
          const SizedBox(height: 12),
          
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferSuccessScreen(
                    title: 'Recompensa por misión',
                    amount: '+50',
                    description: 'Misión completada: Reciclaje',
                  ),
                ),
              );
            },
            child: _buildTransactionItem(
              'ingreso.png',
              'Recompensa por misión',
              'Sábado - 04:20pm',
              '+50',
              Colors.green,
            ),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
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
        ],
      ),
    );
  }
}