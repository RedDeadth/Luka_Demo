import 'package:flutter/material.dart';
import 'shopping_cart_screen.dart';
import 'bottom_navigation_widget.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 3;
  List<CartItem> _cartItems = [];
  double _userBalance = 1500.0; // Saldo del usuario en LUKAS

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                onPressed: () {
                  Navigator.push(
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
          
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Comidas
                _buildProductGrid(_getFoodProducts()),
                // Bebidas
                _buildProductGrid(_getDrinkProducts()),
                // Otros
                _buildProductGrid(_getOtherProducts()),
              ],
            ),
          ),
        ],
      ),
      
      // Bottom Navigation con índice 3 (Tienda)
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
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

  List<Product> _getFoodProducts() {
    return [
      Product(
        id: '1',
        name: 'MENÚ',
        price: 12.0,
        imagePath: 'assets/images/menu.png',
        category: 'Comidas',
      ),
      Product(
        id: '2',
        name: 'PASTEL',
        price: 12.0,
        imagePath: 'assets/images/pastel.png',
        category: 'Comidas',
      ),
      Product(
        id: '3',
        name: 'EMPANADA',
        price: 12.0,
        imagePath: 'assets/images/empanada.png',
        category: 'Comidas',
      ),
      Product(
        id: '4',
        name: 'PAPA',
        price: 12.0,
        imagePath: 'assets/images/papa.png',
        category: 'Comidas',
      ),
    ];
  }

  List<Product> _getDrinkProducts() {
    return [
      Product(
        id: '5',
        name: 'Coca Cola',
        price: 8.0,
        imagePath: 'assets/images/coca_cola.png',
        category: 'Bebidas',
      ),
      Product(
        id: '6',
        name: 'Jugo Natural',
        price: 10.0,
        imagePath: 'assets/images/jugo.png',
        category: 'Bebidas',
      ),
      Product(
        id: '7',
        name: 'Agua Mineral',
        price: 5.0,
        imagePath: 'assets/images/agua.png',
        category: 'Bebidas',
      ),
      Product(
        id: '8',
        name: 'Café',
        price: 6.0,
        imagePath: 'assets/images/cafe.png',
        category: 'Bebidas',
      ),
    ];
  }

  List<Product> _getOtherProducts() {
    return [
      Product(
        id: '9',
        name: 'Cuaderno',
        price: 25.0,
        imagePath: 'assets/images/cuaderno.png',
        category: 'Otros',
      ),
      Product(
        id: '10',
        name: 'Lapicero',
        price: 8.0,
        imagePath: 'assets/images/lapicero.png',
        category: 'Otros',
      ),
      Product(
        id: '11',
        name: 'USB',
        price: 45.0,
        imagePath: 'assets/images/usb.png',
        category: 'Otros',
      ),
      Product(
        id: '12',
        name: 'Calculadora',
        price: 35.0,
        imagePath: 'assets/images/calculadora.png',
        category: 'Otros',
      ),
    ];
  }

  void _addToCart(Product product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
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
}

// Clases de modelo
class Product {
  final String id;
  final String name;
  final double price;
  final String imagePath;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;
}