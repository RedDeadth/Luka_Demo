import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://gnjmcbbmcpnepfzepnop.supabase.co';
  static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imduam1jYmJtY3BuZXBmemVwbm9wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIwMTAxNjMsImV4cCI6MjA2NzU4NjE2M30.6eHrQd6NVDhP94Ml_V7IWpa8_D3JkxAXvsxu6F7cQEE';
  
  static SupabaseClient get client => Supabase.instance.client;

  // Inicializar Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }

  // ==== USUARIOS ====
  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await client
          .from('users')
          .select('*')
          .eq('email', email)
          .eq('password', password) // En producción usar hash
          .single();
      
      return response;
    } catch (e) {
      print('Error login: $e');
      return null;
    }
  }

  static Future<bool> registerUser({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    required String empresa,
    required String universidad,
    String? codigoEstudiante,
  }) async {
    try {
      await client.from('users').insert({
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'password': password, // En producción usar hash
        'codigo_estudiante': codigoEstudiante,
        'empresa': empresa,
        'universidad': universidad,
      });
      return true;
    } catch (e) {
      print('Error registro: $e');
      return false;
    }
  }

  // ==== CUENTAS ====
  static Future<Map<String, dynamic>?> getUserAccount(int userId) async {
    try {
      final response = await client
          .from('cuentas')
          .select('*')
          .eq('user_id', userId)
          .single();
      
      return response;
    } catch (e) {
      print('Error obtener cuenta: $e');
      return null;
    }
  }

  static Future<bool> updateAccountBalance(int cuentaId, double newBalance) async {
    try {
      await client
          .from('cuentas')
          .update({'saldo': newBalance})
          .eq('id', cuentaId);
      return true;
    } catch (e) {
      print('Error actualizar saldo: $e');
      return false;
    }
  }

  // ==== CAMPAÑAS ====
  static Future<List<Map<String, dynamic>>> getCampaigns() async {
    try {
      final response = await client
          .from('campanas')
          .select('*')
          .eq('estado', true)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obtener campañas: $e');
      return [];
    }
  }

  // ==== PRODUCTOS ====
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await client
          .from('productos')
          .select('''
            *,
            proveedor_id,
            tipo_producto_id,
            proveedores(nombre),
            tipos_producto(nombre)
          ''')
          .eq('estado', 'activo')
          .order('nombre');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obtener productos: $e');
      return [];
    }
  }

  // ==== VENTAS ====
  static Future<bool> createSale({
    required int cuentaId,
    required double total,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // Crear la venta
      final saleResponse = await client
          .from('ventas')
          .insert({
            'cuenta_id': cuentaId,
            'total': total,
            'estado': 'completada',
          })
          .select()
          .single();

      final ventaId = saleResponse['id'];

      // Insertar los detalles de la venta
      await client.from('detalle_ventas').insert(
        items.map((item) => {
          'venta_id': ventaId,
          'producto_id': item['producto_id'],
          'cantidad': item['cantidad'],
          'precio_unitario': item['precio_unitario'],
          'subtotal': item['subtotal'],
        }).toList(),
      );

      return true;
    } catch (e) {
      print('Error crear venta: $e');
      return false;
    }
  }

  // ==== MISIONES ====
  static Future<List<Map<String, dynamic>>> getMissions() async {
    try {
      final response = await client
          .from('misiones')
          .select('*')
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obtener misiones: $e');
      return [];
    }
  }

  static Future<bool> completeMission(int misionId) async {
    try {
      await client
          .from('misiones')
          .update({'completada': true})
          .eq('id', misionId);
      return true;
    } catch (e) {
      print('Error completar misión: $e');
      return false;
    }
  }

  // ==== NUEVO: VERIFICAR Y COMPLETAR MISIONES AUTOMÁTICAMENTE ====
  static Future<List<Map<String, dynamic>>> checkAndCompleteMissions(int userId) async {
    try {
      // Obtener progreso del usuario
      final userProgress = await getUserProgress(userId);
      List<Map<String, dynamic>> completedMissions = [];
      
      // Verificar cada misión
      final missions = await getMissions();
      
      for (final mission in missions) {
        if (mission['completada'] == false) {
          final shouldComplete = _shouldCompleteMission(mission, userProgress);
          
          if (shouldComplete) {
            await completeMission(mission['id']);
            
            // Agregar puntos al usuario
            await _addPointsToUser(userId, mission['puntos'] ?? 0);
            
            completedMissions.add(mission);
          }
        }
      }
      
      return completedMissions;
    } catch (e) {
      print('Error verificando misiones: $e');
      return [];
    }
  }

  static Future<Map<String, int>> getUserProgress(int userId) async {
    try {
      // Obtener transacciones del usuario
      final transactions = await getRecentTransactions(userId);
      
      // Obtener participación en campañas
      final campaigns = await getUserCampaignParticipation(userId);
      
      // Obtener cupones utilizados
      final couponsUsed = await getUserCouponsUsed(userId);
      
      // Calcular progreso
      final purchases = transactions.where((t) => (t['total'] as num) > 0).length;
      final totalSpent = transactions.fold(0.0, (sum, t) => sum + (t['total'] as num).abs());
      final drinkPurchases = await _countDrinkPurchases(userId);
      
      return {
        'purchases': purchases,
        'total_spent': totalSpent.toInt(),
        'drinks': drinkPurchases,
        'campaigns': campaigns,
        'coupons': couponsUsed,
        'referrals': 0, // Por implementar
      };
    } catch (e) {
      print('Error obteniendo progreso: $e');
      return {
        'purchases': 0,
        'total_spent': 0,
        'drinks': 0,
        'campaigns': 0,
        'coupons': 0,
        'referrals': 0,
      };
    }
  }

  static Future<int> _countDrinkPurchases(int userId) async {
    try {
      final response = await client
          .from('detalle_ventas')
          .select('''
            *,
            venta_id,
            producto_id,
            productos!inner(
              tipo_producto_id,
              tipos_producto!inner(nombre)
            ),
            ventas!inner(
              cuenta_id,
              cuentas!inner(user_id)
            )
          ''')
          .eq('ventas.cuentas.user_id', userId)
          .eq('productos.tipos_producto.nombre', 'Bebidas');
      
      return response.length;
    } catch (e) {
      print('Error contando bebidas: $e');
      return 0;
    }
  }

  static Future<int> getUserCampaignParticipation(int userId) async {
    try {
      // Por ahora retorna 0, implementar cuando tengas tabla de participación
      return 0;
    } catch (e) {
      print('Error obteniendo participación en campañas: $e');
      return 0;
    }
  }

  static Future<int> getUserCouponsUsed(int userId) async {
    try {
      // Por ahora retorna 0, implementar cuando tengas tabla de uso de cupones
      return 0;
    } catch (e) {
      print('Error obteniendo cupones usados: $e');
      return 0;
    }
  }

  static bool _shouldCompleteMission(Map<String, dynamic> mission, Map<String, int> progress) {
    final name = mission['nombre'];
    
    switch (name) {
      case 'Primera Compra':
      case 'Primera compra':
        return progress['purchases']! >= 1;
      case 'Compra 2 bebidas':
      case 'Comprador Frecuente':
        return progress['drinks']! >= 2;
      case 'Comprar 5 productos':
        return progress['purchases']! >= 5;
      case 'Gastar 100 LUKAS':
        return progress['total_spent']! >= 100;
      case 'Participar en 3 campañas':
      case 'Eco Warrior':
        return progress['campaigns']! >= 3;
      case 'Usar 3 cupones':
        return progress['coupons']! >= 3;
      default:
        return false;
    }
  }

  static Future<void> _addPointsToUser(int userId, int points) async {
    try {
      // Agregar puntos al saldo del usuario
      final account = await getUserAccount(userId);
      if (account != null) {
        final newBalance = (account['saldo'] as num) + points;
        await updateAccountBalance(account['id'], newBalance.toDouble());
      }
    } catch (e) {
      print('Error agregando puntos: $e');
    }
  }

  // ==== CREAR MISIONES POR DEFECTO ====
  static Future<void> createDefaultMissions() async {
    try {
      final defaultMissions = [
        {
          'nombre': 'Primera Compra',
          'descripcion': 'Realiza tu primera compra en la tienda',
          'puntos': 100,
          'completada': false,
        },
        {
          'nombre': 'Compra 2 bebidas',
          'descripcion': 'Compra 2 bebidas en la tienda',
          'puntos': 150,
          'completada': false,
        },
        {
          'nombre': 'Comprar 5 productos',
          'descripcion': 'Realiza 5 compras diferentes',
          'puntos': 200,
          'completada': false,
        },
        {
          'nombre': 'Gastar 100 LUKAS',
          'descripcion': 'Gasta un total de 100 LUKAS',
          'puntos': 250,
          'completada': false,
        },
        {
          'nombre': 'Participar en 3 campañas',
          'descripcion': 'Únete a 3 campañas diferentes',
          'puntos': 300,
          'completada': false,
        },
        {
          'nombre': 'Usar 3 cupones',
          'descripcion': 'Utiliza 3 cupones diferentes',
          'puntos': 200,
          'completada': false,
        },
      ];

      for (final mission in defaultMissions) {
        try {
          await client.from('misiones').insert(mission);
        } catch (e) {
          // Misión ya existe, continuar
          print('Misión ${mission['nombre']} ya existe');
        }
      }
    } catch (e) {
      print('Error creando misiones por defecto: $e');
    }
  }

  // ==== CUPONES ====
  static Future<List<Map<String, dynamic>>> getUserCoupons(int userId) async {
    try {
      final response = await client
          .from('cupones')
          .select('''
            *,
            proveedor_id,
            proveedores(nombre)
          ''')
          .eq('activo', true)
          .order('fecha_expiracion');
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obtener cupones: $e');
      return [];
    }
  }

  // ==== CUPONES FUNCIONALES ====
  static Future<bool> applyCoupon(String couponCode, double purchaseAmount) async {
    try {
      final coupon = await client
          .from('cupones')
          .select('*')
          .eq('codigo', couponCode)
          .eq('activo', true)
          .single();

      if (coupon != null) {
        final expirationDate = DateTime.parse(coupon['fecha_expiracion']);
        if (expirationDate.isAfter(DateTime.now())) {
          return true; // Cupón válido
        }
      }
      return false;
    } catch (e) {
      print('Error aplicando cupón: $e');
      return false;
    }
  }

  static Future<double> calculateDiscount(String couponCode, double amount) async {
    try {
      final coupon = await client
          .from('cupones')
          .select('*')
          .eq('codigo', couponCode)
          .eq('activo', true)
          .single();

      if (coupon != null) {
        final discountType = coupon['tipo_descuento'];
        final discountValue = (coupon['valor_descuento'] as num).toDouble();
        
        if (discountType == 'porcentaje') {
          return amount * (discountValue / 100);
        } else if (discountType == 'monto_fijo') {
          return discountValue;
        }
      }
      return 0.0;
    } catch (e) {
      print('Error calculando descuento: $e');
      return 0.0;
    }
  }

  // ==== TRANSFERENCIAS ====
  static Future<bool> createTransfer({
    required int cuentaOrigenId,
    required int cuentaDestinoId,
    required double monto,
  }) async {
    try {
      await client.from('transferencias').insert({
        'cuenta_origen_id': cuentaOrigenId,
        'cuenta_destino_id': cuentaDestinoId,
        'monto': monto,
        'fecha_transferencia': DateTime.now().toIso8601String(),
        'estado': 'completada',
      });
      return true;
    } catch (e) {
      print('Error crear transferencia: $e');
      return false;
    }
  }

  // ==== RANKING/LOGROS ====
  static Future<List<Map<String, dynamic>>> getUserRanking() async {
    try {
      final response = await client
          .from('users')
          .select('id, nombre, apellido')
          .order('created_at', ascending: false)
          .limit(10);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obtener ranking: $e');
      return [];
    }
  }

  // ==== TRANSACCIONES RECIENTES ====
  static Future<List<Map<String, dynamic>>> getRecentTransactions(int userId) async {
    try {
      final response = await client
          .from('ventas')
          .select('''
            id,
            total,
            fecha_venta,
            estado,
            cuenta_id,
            cuentas!inner(user_id)
          ''')
          .eq('cuentas.user_id', userId)
          .order('fecha_venta', ascending: false)
          .limit(10);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obtener transacciones: $e');
      return [];
    }
  }

  // ==== LOGROS ====
  static Future<List<Map<String, dynamic>>> getUserAchievements(int userId) async {
    try {
      final response = await client
          .from('logros')
          .select('''
            *,
            mision_id,
            misiones(nombre, descripcion, puntos)
          ''')
          .eq('activo', true)
          .order('fecha_logro', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obtener logros: $e');
      return [];
    }
  }

  // ==== CREAR LOGRO ====
  static Future<bool> createAchievement({
    required int misionId,
    required String nombre,
    required String descripcion,
  }) async {
    try {
      await client.from('logros').insert({
        'mision_id': misionId,
        'nombre': nombre,
        'descripcion': descripcion,
        'fecha_logro': DateTime.now().toIso8601String(),
        'activo': true,
      });
      return true;
    } catch (e) {
      print('Error creando logro: $e');
      return false;
    }
  }

  // ==== NOTIFICACIONES ====
  static Future<void> createNotification({
    required int userId,
    required String type,
    required String title,
    required String message,
  }) async {
    try {
      // Crear notificación en la tabla de notificaciones (si existe)
      // Por ahora solo log
      print('Notificación para usuario $userId: $title - $message');
    } catch (e) {
      print('Error creando notificación: $e');
    }
  }

  // ==== FUNCIÓN HELPER: TRIGGER DESPUÉS DE COMPRA ====
  static Future<List<Map<String, dynamic>>> onPurchaseCompleted(int userId, double amount) async {
    try {
      // Verificar y completar misiones automáticamente
      final newCompletedMissions = await checkAndCompleteMissions(userId);
      
      // Crear notificaciones para misiones completadas
      for (final mission in newCompletedMissions) {
        await createNotification(
          userId: userId,
          type: 'mission_completed',
          title: 'Misión Completada',
          message: '¡Has completado: ${mission['nombre']}! +${mission['puntos']} puntos',
        );
      }
      
      return newCompletedMissions;
    } catch (e) {
      print('Error en onPurchaseCompleted: $e');
      return [];
    }
  }

  // ==== FUNCIÓN HELPER: TRIGGER DESPUÉS DE ESCANEAR QR ====
  static Future<List<Map<String, dynamic>>> onQRScanned(int userId, int pointsEarned) async {
    try {
      // Verificar y completar misiones automáticamente
      final newCompletedMissions = await checkAndCompleteMissions(userId);
      
      // Crear notificaciones para misiones completadas
      for (final mission in newCompletedMissions) {
        await createNotification(
          userId: userId,
          type: 'mission_completed',
          title: 'Misión Completada',
          message: '¡Has completado: ${mission['nombre']}! +${mission['puntos']} puntos',
        );
      }
      
      return newCompletedMissions;
    } catch (e) {
      print('Error en onQRScanned: $e');
      return [];
    }
  }
}