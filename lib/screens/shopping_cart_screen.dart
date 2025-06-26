import 'package:flutter/material.dart';
import 'store_screen.dart';
import 'purchase_sucesss_creen.dart';

class ShoppingCartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double userBalance;
  final Function(List<CartItem>) onUpdateCart;
  final Function(double)? onBalanceUpdated; // Callback para actualizar saldo

  const ShoppingCartScreen({
    Key? key,
    required this.cartItems,
    required this.userBalance,
    required this.onUpdateCart,
    this.onBalanceUpdated,
  }) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  late List<CartItem> _cartItems;
  late double _userBalance;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
    _userBalance = widget.userBalance;
  }

  double get _totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  bool get _canAfford {
    return _userBalance >= _totalAmount;
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
          onPressed: () {
            widget.onUpdateCart(_cartItems);
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Carrito de Compras',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutSection(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega productos para comenzar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Continuar Comprando'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        // Saldo disponible
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Row(
            children: [
              const Text(
                'Saldo disponible: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Text(
                _userBalance.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _canAfford ? Colors.green : Colors.red,
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
        
        const SizedBox(height: 8),
        
        // Lista de productos en el carrito
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return _buildCartItem(item, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Imagen del producto
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(item.product.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${item.product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      'assets/images/luka_moneda.png',
                      width: 16,
                      height: 16,
                    ),
                    const Text(
                      ' c/u',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Controles de cantidad
          Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _decreaseQuantity(index),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: () => _increaseQuantity(index),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Total por producto
              Row(
                children: [
                  Text(
                    'Total: ${item.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
          
          const SizedBox(width: 8),
          
          // Botón eliminar
          GestureDetector(
            onTap: () => _removeItem(index),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.red.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total general
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total a pagar:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      _totalAmount.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _canAfford ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      'assets/images/luka_moneda.png',
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ],
            ),
            
            if (!_canAfford) ...[
              const SizedBox(height: 8),
              Text(
                'Saldo insuficiente',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Botón de comprar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canAfford ? _processPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canAfford ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _canAfford ? 'Comprar Ahora' : 'Saldo Insuficiente',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _processPayment() async {
    if (_canAfford && _cartItems.isNotEmpty) {
      // IMPORTANTE: Calcular el total ANTES de limpiar el carrito
      final totalToPay = _totalAmount;
      
      // Crear copia de los items comprados antes de limpiar el carrito
      final purchasedItems = List<CartItem>.from(_cartItems);
      final newBalance = _userBalance - totalToPay;
      final transactionId = _generateTransactionId();

      // Actualizar saldo local
      setState(() {
        _userBalance = newBalance;
        _cartItems.clear();
      });

      // Actualizar carrito en el padre
      widget.onUpdateCart([]);
      
      // Llamar callback para actualizar saldo en HomeScreen si existe
      if (widget.onBalanceUpdated != null) {
        widget.onBalanceUpdated!(newBalance);
      }

      // Navegar al voucher de compra usando el total calculado antes de limpiar
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PurchaseSuccessVoucherScreen(
            purchasedItems: purchasedItems,
            totalAmount: totalToPay, // Usar el total calculado antes de limpiar
            newBalance: newBalance,
            transactionId: transactionId,
          ),
        ),
      );

      // Después de que el usuario vuelve del voucher, cerrar el carrito
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  String _generateTransactionId() {
    final now = DateTime.now();
    return 'PUR${now.millisecondsSinceEpoch.toString().substring(8)}';
  }
}