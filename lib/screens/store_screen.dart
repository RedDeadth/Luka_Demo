import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/user_manager.dart';
import 'shopping_cart_screen.dart';
import 'bottom_navigation_widget.dart';
import 'missions_screen.dart';
class StoreScreen extends StatefulWidget {
  final double? initialBalance;
  final Function(double)? onBalanceUpdated;

  const StoreScreen({Key? key, this.initialBalance, this.onBalanceUpdated})
    : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 3;
  List<CartItem> _cartItems = [];
  late double _userBalance;
  List<Product> _allProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _userBalance = widget.initialBalance ?? UserManager.balance;
    _loadProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    try {
      final products = await SupabaseService.getProducts();
      
      setState(() {
        _allProducts = products.map((p) => Product(
          id: p['id'].toString(),
          name: p['nombre'],
          price: (p['precio'] as num).toDouble(),
          imagePath: _getProductImage(p['nombre']),
          category: p['tipos_producto']?['nombre'] ?? 'Otros',
          stock: p['stock'] ?? 0,
        )).toList();
      });
    } catch (e) {
      print('Error cargando productos: $e');
      // Usar productos por defecto si falla la conexión
      _loadDefaultProducts();
    }

    setState(() => _isLoading = false);
  }

  void _loadDefaultProducts() {
    _allProducts = [
      // Comidas
      Product(id: '1', name: 'MENÚ', price: 12.0, imagePath: 'assets/images/Menu.png', category: 'Alimentos'),
      Product(id: '2', name: 'PASTEL', price: 12.0, imagePath: 'assets/images/pastel.png', category: 'Alimentos'),
      Product(id: '3', name: 'EMPANADA', price: 12.0, imagePath: 'assets/images/empanada.png', category: 'Alimentos'),
      Product(id: '4', name: 'PAPA', price: 12.0, imagePath: 'assets/images/papa.png', category: 'Alimentos'),
      // Bebidas
      Product(id: '5', name: 'Coca Cola', price: 8.0, imagePath: 'assets/images/cocacola.png', category: 'Bebidas'),
      Product(id: '6', name: 'Jugo Natural', price: 10.0, imagePath: 'assets/images/jugo.png', category: 'Bebidas'),
      Product(id: '7', name: 'Agua Mineral', price: 5.0, imagePath: 'assets/images/aguamineral.png', category: 'Bebidas'),
      Product(id: '8', name: 'Café', price: 6.0, imagePath: 'assets/images/cafe.png', category: 'Bebidas'),
      // Otros
      Product(id: '9', name: 'Cuaderno', price: 25.0, imagePath: 'assets/images/cuaderno.png', category: 'Útiles'),
      Product(id: '10', name: 'Lapicero', price: 8.0, imagePath: 'assets/images/lapicero.png', category: 'Útiles'),
      Product(id: '11', name: 'USB', price: 45.0, imagePath: 'assets/images/usb.png', category: 'Útiles'),
      Product(id: '12', name: 'Calculadora', price: 35.0, imagePath: 'assets/images/calculadora.png', category: 'Útiles'),
    ];
  }

  String _getProductImage(String productName) {
    // Mapear nombres de productos de la BD a imágenes
    final imageMap = {
      'Empanada de Pollo': 'assets/images/empanada.png',
      'Coca Cola 500ml': 'assets/images/cocacola.png',
      'Cuaderno Universitario': 'assets/images/cuaderno.png',
      'Lapicero Azul': 'assets/images/lapicero.png',
      'Impresión A4': 'assets/images/Menu.png', // Imagen por defecto
    };
    
    return imageMap[productName] ?? 'assets/images/Menu.png';
  }

  void _updateBalance(double newBalance) {
    setState(() {
      _userBalance = newBalance;
    });
    if (widget.onBalanceUpdated != null) {
      widget.onBalanceUpdated!(newBalance);
    }
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
        title: const Text(
          'Tienda',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          // Carrito de compras
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShoppingCartScreen(
                        cartItems: _cartItems,
                        userBalance: _userBalance,
                        onUpdateCart: (updatedItems) {
                          setState(() {
                            _cartItems = updatedItems;
                          });
                        },
                        onBalanceUpdated: (newBalance) async {
                          await _processPurchase(newBalance);
                        },
                      ),
                    ),
                  );
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cartItems.length.toString(),
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
        ],
      ),
      body: Column(
        children: [
          // Saldo del usuario
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.white,
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
                Tab(text: 'Comidas'),
                Tab(text: 'Bebidas'),
                Tab(text: 'Otros'),
              ],
            ),
          ),

          // Tab Bar View con productos de la base de datos
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductGrid(_getProductsByCategory(['Alimentos'])),
                _buildProductGrid(_getProductsByCategory(['Bebidas'])),
                _buildProductGrid(_getProductsByCategory(['Útiles', 'Servicios', 'Otros'])),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: const SimpleBottomNavigation(currentIndex: 3),
    );
  }

  List<Product> _getProductsByCategory(List<String> categories) {
    return _allProducts.where((p) => categories.contains(p.category)).toList();
  }

  Widget _buildProductGrid(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No hay productos disponibles',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
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
          // Imagen del producto
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(product.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Información del producto
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        'assets/images/luka_moneda.png',
                        width: 16,
                        height: 16,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _addToCart(product),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(Product product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (existingIndex >= 0) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(product: product, quantity: 1));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} agregado al carrito'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Procesar compra con la base de datos
  Future<void> _processPurchase(double newBalance) async {
  try {
    final totalSpent = _userBalance - newBalance;
    
    // Crear la venta en la base de datos
    final saleItems = _cartItems.map((item) => {
      'producto_id': int.parse(item.product.id),
      'cantidad': item.quantity,
      'precio_unitario': item.product.price,
      'subtotal': item.totalPrice,
    }).toList();

    final success = await SupabaseService.createSale(
      cuentaId: UserManager.accountId,
      total: totalSpent,
      items: saleItems,
    );

    if (success) {
      // Actualizar saldo en la base de datos
      await SupabaseService.updateAccountBalance(UserManager.accountId, newBalance);
      
      // Actualizar saldo local
      UserManager.updateBalance(newBalance);
      _updateBalance(newBalance);

      // NUEVA FUNCIONALIDAD: Verificar misiones después de compra
      try {
        final completedMissions = await SupabaseService.onPurchaseCompleted(
          UserManager.userId, 
          totalSpent
        );
        
        // Mostrar notificación de misiones completadas si las hay
        if (completedMissions.isNotEmpty) {
          _showMissionCompletedSnackBar(completedMissions);
        }
      } catch (e) {
        print('Error verificando misiones: $e');
      }

      // Limpiar carrito
      setState(() {
        _cartItems.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compra realizada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al procesar la compra'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Error procesando compra: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error de conexión'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Agregar este método para mostrar notificación de misiones completadas
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
}

// Clases de modelo
class Product {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final String category;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
    this.stock = 0,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
}