import 'package:flutter/material.dart';
import 'package:plantyard/services/auth_service.dart';
import 'package:plantyard/services/user_data_service.dart';
import 'package:plantyard/services/plant_data_service.dart';
import 'package:plantyard/models/plant_model.dart';
import 'package:plantyard/screens/auth/login_screen.dart';
import 'package:plantyard/screens/shop/plant_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;
  bool _isLoading = true;
  final UserDataService _userData = UserDataService();

  @override
  void initState() {
    super.initState();
    _userData.addListener(_refresh);
    _loadAll();
  }

  @override
  void dispose() {
    _userData.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    await _userData.init();
    final user = await AuthService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        userName = user.fullName;
        userEmail = user.email;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dekonekte?'),
        content: const Text('Èske w sèten ou vle dekonekte?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annile'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.logout();
              if (!mounted) return;
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Dekonekte'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pwofil mwen'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 50, color: Color(0xFF2E7D32)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName ?? 'Itilizatè',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail ?? 'imèl@example.com',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat(
                              '${_userData.orders.length}', 'Komand'),
                          _buildStat(
                              '${_userData.favoriteIds.length}', 'Favori'),
                          _buildStat(
                              '${_userData.addresses.length}', 'Adrès'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Komand mwen yo',
                        subtitle:
                            '${_userData.orders.length} komand anrejistre',
                        badge: _userData.orders.length,
                        onTap: () => _showOrders(),
                      ),
                      _buildMenuItem(
                        icon: Icons.favorite_outline,
                        title: 'Favori mwen',
                        subtitle:
                            '${_userData.favoriteIds.length} plant an favori',
                        onTap: () => _showFavorites(),
                      ),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Adrès livrezon',
                        subtitle:
                            '${_userData.addresses.length} adrès anrejistre',
                        onTap: () => _showAddresses(),
                      ),
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifikasyon',
                        subtitle: '${_userData.unreadNotificationCount} nouvo alèt',
                        badge: _userData.unreadNotificationCount,
                        onTap: () => _showNotifications(),
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Èd ak sipò',
                        subtitle: 'Kontakte nou si ou gen pwoblèm',
                        onTap: () => _showSupport(),
                      ),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'A pwopo',
                        subtitle: 'Enfòmasyon kont ou ak aplikasyon an',
                        onTap: () => _showAbout(),
                      ),
                      const Divider(height: 32),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.logout, color: Colors.red),
                        ),
                        title: const Text('Dekonekte',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500)),
                        onTap: _logout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFC8E6C9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF2E7D32)),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$badge',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  // ===== KOMAND =====
  void _showOrders() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheet(
        title: 'Komand mwen yo',
        icon: Icons.shopping_bag_outlined,
        child: _userData.orders.isEmpty
            ? _emptyState(
                Icons.shopping_bag_outlined, 'Ou poko gen okenn komand')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _userData.orders.length,
                itemBuilder: (context, index) {
                  final order = _userData.orders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(order.id,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(order.status,
                                    style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${order.items.length} atik • \$${order.total.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(order.date),
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          ),
                          if (order.deliveryAddress != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    order.deliveryAddress!,
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 10),
                          // Lis plant yo
                          ...order.items.map((item) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.eco,
                                        size: 14,
                                        color: Color(0xFF2E7D32)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        '${item.plant.name} x${item.quantity}',
                                        style: const TextStyle(
                                            fontSize: 13),
                                      ),
                                    ),
                                    Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2E7D32)),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // ===== FAVORI =====
  void _showFavorites() {
    final favIds = _userData.favoriteIds;
    final favPlants = PlantDataService.allPlants
        .where((p) => favIds.contains(p.id))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheet(
        title: 'Favori mwen',
        icon: Icons.favorite_outline,
        child: favPlants.isEmpty
            ? _emptyState(Icons.favorite_outline,
                'Ou poko mete okenn plant an favori')
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: favPlants.length,
                itemBuilder: (context, index) {
                  final plant = favPlants[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PlantDetailScreen(plant: plant),
                        ),
                      );
                    },
                    child: _FavoritePlantCard(plant: plant),
                  );
                },
              ),
      ),
    );
  }

  // ===== ADRÈS =====
  void _showAddresses() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => _BottomSheet(
          title: 'Adrès livrezon',
          icon: Icons.location_on_outlined,
          action: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showAddAddressForm();
            },
            icon: const Icon(Icons.add, color: Color(0xFF2E7D32)),
            label: const Text('Ajoute',
                style: TextStyle(color: Color(0xFF2E7D32))),
          ),
          child: _userData.addresses.isEmpty
              ? Column(
                  children: [
                    _emptyState(
                        Icons.location_off_outlined,
                        'Ou poko gen okenn adrès enrejistre'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddAddressForm();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajoute yon adrès'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    ..._userData.addresses.map((addr) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: addr.isDefault
                                    ? const Color(0xFFC8E6C9)
                                    : Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: addr.isDefault
                                    ? const Color(0xFF2E7D32)
                                    : Colors.grey,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(addr.label,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                if (addr.isDefault) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: const Text('Default',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10)),
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Text(
                                '${addr.street}, ${addr.city}',
                                style:
                                    const TextStyle(fontSize: 12)),
                            trailing: PopupMenuButton<String>(
                              onSelected: (val) async {
                                if (val == 'default') {
                                  await _userData
                                      .setDefaultAddress(addr.id);
                                } else if (val == 'delete') {
                                  await _userData
                                      .deleteAddress(addr.id);
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                    value: 'default',
                                    child: Text('Mete kòm default')),
                                const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Efase',
                                        style: TextStyle(
                                            color: Colors.red))),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showAddAddressForm();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Ajoute yon lòt adrès'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2E7D32),
                        side: const BorderSide(
                            color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showAddAddressForm() {
    final labelCtrl = TextEditingController(text: 'Kay');
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    bool isDefault = false;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ajoute yon adrès',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _formField(labelCtrl, 'Label (Kay, Travay...)',
                      Icons.label_outline),
                  const SizedBox(height: 12),
                  _formField(nameCtrl, 'Non konplè', Icons.person_outline),
                  const SizedBox(height: 12),
                  _formField(phoneCtrl, 'Nimewo telefòn',
                      Icons.phone_outlined,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 12),
                  _formField(streetCtrl, 'Ri ak nimewo',
                      Icons.home_outlined),
                  const SizedBox(height: 12),
                  _formField(cityCtrl, 'Vil', Icons.location_city),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Switch(
                        value: isDefault,
                        activeColor: const Color(0xFF2E7D32),
                        onChanged: (v) =>
                            setModalState(() => isDefault = v),
                      ),
                      const Text('Defini kòm adrès default'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (labelCtrl.text.isEmpty ||
                            streetCtrl.text.isEmpty ||
                            cityCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Tanpri ranpli tout chan yo')),
                          );
                          return;
                        }
                        await _userData.addAddress(DeliveryAddress(
                          id:
                              'addr-${DateTime.now().millisecondsSinceEpoch}',
                          label: labelCtrl.text,
                          fullName: nameCtrl.text,
                          phone: phoneCtrl.text,
                          street: streetCtrl.text,
                          city: cityCtrl.text,
                          isDefault: isDefault,
                        ));
                        if (mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Anrejistre adrès la',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== NOTIFIKASYON =====
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheet(
        title: 'Notifikasyon',
        icon: Icons.notifications_outlined,
        action: TextButton(
          onPressed: () async {
            await _userData.markAllRead();
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Li tout',
              style: TextStyle(color: Color(0xFF2E7D32))),
        ),
        child: _userData.notifications.isEmpty
            ? _emptyState(
                Icons.notifications_off_outlined, 'Pa gen notifikasyon')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _userData.notifications.length,
                itemBuilder: (context, index) {
                  final notif = _userData.notifications[index];
                  return GestureDetector(
                    onTap: () async {
                      await _userData.markNotificationRead(notif.id);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: notif.isRead
                            ? Colors.white
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: notif.isRead
                              ? Colors.grey.shade200
                              : const Color(0xFF2E7D32).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _notifColor(notif.type)
                                  .withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _notifIcon(notif.type),
                              color: _notifColor(notif.type),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notif.title,
                                        style: TextStyle(
                                          fontWeight:
                                              notif.isRead
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    if (!notif.isRead)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF2E7D32),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif.message,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(notif.date),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  IconData _notifIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'promo':
        return Icons.local_offer;
      case 'stock':
        return Icons.inventory_2;
      default:
        return Icons.info;
    }
  }

  Color _notifColor(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'promo':
        return Colors.orange;
      case 'stock':
        return Colors.red;
      default:
        return const Color(0xFF2E7D32);
    }
  }

  // ===== ÈD AK SIPÒ =====
  void _showSupport() {
    final nameCtrl = TextEditingController(text: userName);
    final emailCtrl = TextEditingController(text: userEmail);
    final msgCtrl = TextEditingController();
    String selectedTopic = 'Pwoblèm komand';
    final topics = [
      'Pwoblèm komand',
      'Pwoblèm pèman',
      'Livrezon',
      'Plant domaje',
      'Kont mwen',
      'Lòt',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8E6C9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.support_agent,
                          color: Color(0xFF2E7D32)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Èd ak Sipò',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text('Nou la pou ede ou',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Sijè pwoblèm nan',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedTopic,
                    isExpanded: true,
                    underline: const SizedBox(),
                    onChanged: (v) =>
                        setModalState(() => selectedTopic = v!),
                    items: topics
                        .map((t) => DropdownMenuItem(
                            value: t, child: Text(t)))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 14),
                _formField(nameCtrl, 'Non ou', Icons.person_outline),
                const SizedBox(height: 12),
                _formField(emailCtrl, 'Imèl ou', Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                TextFormField(
                  controller: msgCtrl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Detay pwoblèm nan',
                    hintText:
                        'Eksplike pwoblèm ou a an detay...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Icon(Icons.message_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (msgCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Tanpri ekri pwoblèm ou a')),
                        );
                        return;
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.white),
                              SizedBox(width: 8),
                              Text('Mesaj ou a te voye! Nou pral reponn ou.'),
                            ],
                          ),
                          backgroundColor: Color(0xFF2E7D32),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Voye mesaj la',
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== A PWOPO =====
  void _showAbout() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheet(
        title: 'A pwopo',
        icon: Icons.info_outline,
        child: Column(
          children: [
            // Logo
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.eco,
                  size: 60, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 16),
            const Text('PlantYard',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('Vèsyon 1.0.0',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            // Enfò kont
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enfòmasyon kont',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 12),
                  _infoRow(Icons.person_outline, 'Non', userName ?? '—'),
                  const Divider(height: 16),
                  _infoRow(Icons.email_outlined, 'Imèl',
                      userEmail ?? '—'),
                  const Divider(height: 16),
                  _infoRow(Icons.shopping_bag_outlined, 'Komand',
                      '${_userData.orders.length} komand'),
                  const Divider(height: 16),
                  _infoRow(Icons.favorite_outline, 'Favori',
                      '${_userData.favoriteIds.length} plant'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Deskripsyon app
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'PlantYard se yon mache dijital pou vann plant. '
                'Pèmèt ou achte plant depi lakay ou epi aprann '
                'kijan pou pran swen yo. Dekouvri plizyè kategori '
                'plant depi plant entryè, plant medsin, fwi ak legim, '
                'ak anpil lòt ankò.',
                style: TextStyle(
                    fontSize: 14, height: 1.6, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(
                color: Colors.grey.shade600, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }

  // ===== UTILITE =====
  Widget _emptyState(IconData icon, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(icon, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(
                  color: Colors.grey.shade600, fontSize: 15),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _formField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// ===== WIDGET REUTILIZAB - BOTTOM SHEET =====
class _BottomSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? action;

  const _BottomSheet({
    required this.title,
    required this.icon,
    required this.child,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tit
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8E6C9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF2E7D32)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              if (action != null) action!,
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Kontni
          Flexible(
            child: SingleChildScrollView(child: child),
          ),
        ],
      ),
    );
  }
}

// ===== WIDGET KAT PLANT FAVORI =====
class _FavoritePlantCard extends StatelessWidget {
  final Plant plant;

  const _FavoritePlantCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 110,
              width: double.infinity,
              color: const Color(0xFFC8E6C9),
              child: plant.images.isNotEmpty
                  ? Image.network(plant.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.eco,
                                size: 40, color: Color(0xFF2E7D32)),
                          ))
                  : const Center(
                      child: Icon(Icons.eco,
                          size: 40, color: Color(0xFF2E7D32))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plant.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(plant.formattedPrice,
                    style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}