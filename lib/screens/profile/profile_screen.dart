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
  String? userName, userEmail;
  bool _isLoading = true;
  final _ud = UserDataService();

  @override
  void initState() {
    super.initState();
    _ud.addListener(_r);
    _load();
  }

  @override
  void dispose() {
    _ud.removeListener(_r);
    super.dispose();
  }

  void _r() => setState(() {});

  Future<void> _load() async {
    await _ud.init();
    final user = await AuthService.getCurrentUser();
    if (mounted)
      setState(() {
        userName = user?.fullName;
        userEmail = user?.email;
        _isLoading = false;
      });
  }

  void _logout() => showDialog(
      context: context,
      builder: (_) => AlertDialog(
              title: const Text('Dekonekte?'),
              content: const Text('Èske w sèten ou vle dekonekte?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annile')),
                TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () async {
                      await AuthService.logout();
                      if (!mounted) return;
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (_) => false);
                    },
                    child: const Text('Dekonekte')),
              ]));

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
          title: const Text('Pwofil mwen'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0),
      body: ListView(padding: EdgeInsets.zero, children: [
        _header(),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              _item(
                  Icons.shopping_bag_outlined,
                  'Komand mwen yo',
                  '${_ud.orders.length} komand',
                  _ud.orders.length,
                  _showOrders),
              _item(Icons.favorite_outline, 'Favori mwen',
                  '${_ud.favoriteIds.length} plant', 0, _showFavorites),
              _item(Icons.location_on_outlined, 'Adrès livrezon',
                  '${_ud.addresses.length} adrès', 0, _showAddresses),
              _item(
                  Icons.notifications_outlined,
                  'Notifikasyon',
                  '${_ud.unreadNotificationCount} nouvo alèt',
                  _ud.unreadNotificationCount,
                  _showNotifications),
              _item(Icons.help_outline, 'Èd ak sipò', 'Kontakte nou', 0,
                  _showSupport),
              _item(Icons.info_outline, 'A pwopo', 'Enfòmasyon kont ou', 0,
                  _showAbout),
              const Divider(height: 32),
              ListTile(
                  leading: _ibox(Icons.logout, Colors.red.shade50, Colors.red),
                  title: const Text('Dekonekte',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w500)),
                  onTap: _logout),
            ])),
      ]),
    );
  }

  Widget _header() => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
          color: Color(0xFF2E7D32),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      child: Column(children: [
        const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Color(0xFF2E7D32))),
        const SizedBox(height: 12),
        Text(userName ?? 'Itilizatè',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(userEmail ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _stat('${_ud.orders.length}', 'Komand'),
          _stat('${_ud.favoriteIds.length}', 'Favori'),
          _stat('${_ud.addresses.length}', 'Adrès'),
        ]),
      ]));

  Widget _stat(String v, String l) => Column(children: [
        Text(v,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(l, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ]);

  Widget _ibox(IconData i, Color bg, Color fg) => Container(
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Icon(i, color: fg));

  Widget _item(IconData icon, String title, String sub, int badge,
          VoidCallback onTap) =>
      ListTile(
          leading:
              _ibox(icon, const Color(0xFFC8E6C9), const Color(0xFF2E7D32)),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(sub,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            if (badge > 0)
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text('$badge',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold))),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ]),
          onTap: onTap);

  void _sheet(String title, IconData icon, Widget child, {Widget? action}) =>
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) =>
              _Sheet(title: title, icon: icon, action: action, child: child));

  void _showOrders() => _sheet(
      'Komand mwen yo',
      Icons.shopping_bag_outlined,
      _ud.orders.isEmpty
          ? _empty(Icons.shopping_bag_outlined, 'Ou poko gen okenn komand')
          : Column(
              children: _ud.orders
                  .map((o) => Card(
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
                                      Text(o.id,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13)),
                                      _badge(o.status, Colors.green.shade50,
                                          Colors.green.shade800),
                                    ]),
                                const SizedBox(height: 6),
                                Text(
                                    '${o.items.length} atik • \$${o.total.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13)),
                                Text(_dt(o.date),
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12)),
                                const SizedBox(height: 8),
                                ...o.items.map((i) => Row(children: [
                                      const Icon(Icons.eco,
                                          size: 14, color: Color(0xFF2E7D32)),
                                      const SizedBox(width: 6),
                                      Expanded(
                                          child: Text(
                                              '${i.plant.name} x${i.quantity}',
                                              style: const TextStyle(
                                                  fontSize: 13))),
                                      Text(
                                          '\$${i.totalPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2E7D32))),
                                    ])),
                              ]))))
                  .toList()));

  void _showFavorites() {
    final favs = PlantDataService.allPlants
        .where((p) => _ud.favoriteIds.contains(p.id))
        .toList();
    _sheet(
        'Favori mwen',
        Icons.favorite_outline,
        favs.isEmpty
            ? _empty(
                Icons.favorite_outline, 'Ou poko mete okenn plant an favori')
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemCount: favs.length,
                itemBuilder: (_, i) => GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  PlantDetailScreen(plant: favs[i])));
                    },
                    child: _FavCard(plant: favs[i]))));
  }

  void _showAddresses() => _sheet(
      'Adrès livrezon',
      Icons.location_on_outlined,
      Column(children: [
        if (_ud.addresses.isEmpty)
          _empty(Icons.location_off_outlined, 'Ou poko gen okenn adrès'),
        ..._ud.addresses.map((a) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
                leading: Icon(Icons.location_on,
                    color: a.isDefault ? const Color(0xFF2E7D32) : Colors.grey),
                title: Row(children: [
                  Text(a.label,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (a.isDefault) ...[
                    const SizedBox(width: 6),
                    _badge('Default', const Color(0xFF2E7D32), Colors.white)
                  ],
                ]),
                subtitle: Text('${a.street}, ${a.city}',
                    style: const TextStyle(fontSize: 12)),
                trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'd') await _ud.setDefaultAddress(a.id);
                      if (v == 'x') await _ud.deleteAddress(a.id);
                    },
                    itemBuilder: (_) => [
                          const PopupMenuItem(
                              value: 'd', child: Text('Mete kòm default')),
                          const PopupMenuItem(
                              value: 'x',
                              child: Text('Efase',
                                  style: TextStyle(color: Colors.red))),
                        ])))),
        const SizedBox(height: 8),
        OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showAddressForm();
            },
            icon: const Icon(Icons.add),
            label: const Text('Ajoute yon adrès'),
            style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2E7D32),
                side: const BorderSide(color: Color(0xFF2E7D32)))),
      ]));

  void _showAddressForm() {
    final lbl = TextEditingController(text: 'Kay');
    final str = TextEditingController(),
        cty = TextEditingController(),
        phn = TextEditingController();
    bool isDef = false;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => StatefulBuilder(
            builder: (context, set) => Container(
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ajoute adrès',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context)),
                      ]),
                  const SizedBox(height: 16),
                  _fld(lbl, 'Label (Kay, Travay...)', Icons.label_outline),
                  const SizedBox(height: 10),
                  _fld(phn, 'Nimewo telefòn', Icons.phone_outlined,
                      type: TextInputType.phone),
                  const SizedBox(height: 10),
                  _fld(str, 'Ri ak nimewo', Icons.home_outlined),
                  const SizedBox(height: 10),
                  _fld(cty, 'Vil', Icons.location_city),
                  const SizedBox(height: 10),
                  Row(children: [
                    Switch(
                        value: isDef,
                        activeColor: const Color(0xFF2E7D32),
                        onChanged: (v) => set(() => isDef = v)),
                    const Text('Adrès default'),
                  ]),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (str.text.isEmpty || cty.text.isEmpty) return;
                            await _ud.addAddress(DeliveryAddress(
                                id: 'a-${DateTime.now().millisecondsSinceEpoch}',
                                label: lbl.text,
                                phone: phn.text,
                                fullName: userName ?? '',
                                street: str.text,
                                city: cty.text,
                                isDefault: isDef));
                            if (mounted) Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text('Anrejistre',
                              style: TextStyle(fontSize: 16)))),
                ])))));
  }

  void _showNotifications() => _sheet(
      'Notifikasyon',
      Icons.notifications_outlined,
      _ud.notifications.isEmpty
          ? _empty(Icons.notifications_off_outlined, 'Pa gen notifikasyon')
          : Column(
              children: _ud.notifications
                  .map((n) => GestureDetector(
                      onTap: () => _ud.markNotificationRead(n.id),
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: n.isRead
                                  ? Colors.white
                                  : const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: n.isRead
                                      ? Colors.grey.shade200
                                      : const Color(0xFF2E7D32)
                                          .withOpacity(0.3))),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: _nc(n.type).withOpacity(0.15),
                                        shape: BoxShape.circle),
                                    child: Icon(_ni(n.type),
                                        color: _nc(n.type), size: 18)),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Row(children: [
                                        Expanded(
                                            child: Text(n.title,
                                                style: TextStyle(
                                                    fontWeight: n.isRead
                                                        ? FontWeight.normal
                                                        : FontWeight.bold,
                                                    fontSize: 14))),
                                        if (!n.isRead)
                                          Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFF2E7D32),
                                                  shape: BoxShape.circle)),
                                      ]),
                                      const SizedBox(height: 4),
                                      Text(n.message,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      Text(_dt(n.date),
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade400)),
                                    ])),
                              ]))))
                  .toList()),
      action: TextButton(
          onPressed: () async {
            await _ud.markAllRead();
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Li tout',
              style: TextStyle(color: Color(0xFF2E7D32)))));

  void _showSupport() {
    final msg = TextEditingController();
    final topics = [
      'Pwoblèm komand',
      'Pèman',
      'Livrezon',
      'Plant domaje',
      'Kont',
      'Lòt'
    ];
    String topic = topics[0];
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => StatefulBuilder(
            builder: (context, set) => Container(
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Èd ak Sipò',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context)),
                          ]),
                      const SizedBox(height: 16),
                      const Text('Sijè',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton<String>(
                              value: topic,
                              isExpanded: true,
                              underline: const SizedBox(),
                              onChanged: (v) => set(() => topic = v!),
                              items: topics
                                  .map((t) => DropdownMenuItem(
                                      value: t, child: Text(t)))
                                  .toList())),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: msg,
                          maxLines: 5,
                          decoration: InputDecoration(
                              labelText: 'Detay pwoblèm nan',
                              hintText: 'Eksplike pwoblèm ou a...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      const SizedBox(height: 16),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                if (msg.text.isEmpty) return;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Mesaj ou a te voye!'),
                                        backgroundColor: Color(0xFF2E7D32),
                                        behavior: SnackBarBehavior.floating));
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
                                      borderRadius:
                                          BorderRadius.circular(12))))),
                    ])))));
  }

  void _showAbout() => _sheet(
      'A pwopo',
      Icons.info_outline,
      Column(children: [
        Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.green.shade50, shape: BoxShape.circle),
            child: const Icon(Icons.eco, size: 60, color: Color(0xFF2E7D32))),
        const SizedBox(height: 12),
        const Text('PlantYard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('Vèsyon 1.0.0', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              _ir(Icons.person_outline, 'Non', userName ?? '—'),
              const Divider(height: 16),
              _ir(Icons.email_outlined, 'Imèl', userEmail ?? '—'),
              const Divider(height: 16),
              _ir(Icons.shopping_bag_outlined, 'Komand',
                  '${_ud.orders.length} komand'),
              const Divider(height: 16),
              _ir(Icons.favorite_outline, 'Favori',
                  '${_ud.favoriteIds.length} plant'),
            ])),
        const SizedBox(height: 16),
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12)),
            child: const Text(
                'PlantYard se yon mache dijital pou vann plant. Pèmèt ou achte plant depi lakay ou epi aprann kijan pou pran swen yo.',
                style: TextStyle(fontSize: 14, height: 1.6),
                textAlign: TextAlign.center)),
      ]));

  Widget _empty(IconData icon, String msg) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(children: [
        Icon(icon, size: 60, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text(msg,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            textAlign: TextAlign.center),
      ]));

  Widget _fld(TextEditingController c, String label, IconData icon,
          {TextInputType type = TextInputType.text}) =>
      TextFormField(
          controller: c,
          keyboardType: type,
          decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12)));

  Widget _ir(IconData icon, String label, String value) => Row(children: [
        Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 10),
        Text(label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ]);

  Widget _badge(String t, Color bg, Color fg) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(t,
          style:
              TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w500)));

  IconData _ni(String t) => switch (t) {
        'order' => Icons.shopping_bag,
        'promo' => Icons.local_offer,
        'stock' => Icons.inventory_2,
        _ => Icons.info
      };
  Color _nc(String t) => switch (t) {
        'order' => Colors.blue,
        'promo' => Colors.orange,
        'stock' => Colors.red,
        _ => const Color(0xFF2E7D32)
      };
  String _dt(DateTime d) =>
      '${d.day}/${d.month}/${d.year} - ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

class _Sheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? action;
  const _Sheet(
      {required this.title,
      required this.icon,
      required this.child,
      this.action});
  @override
  Widget build(BuildContext context) => Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFC8E6C9),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: const Color(0xFF2E7D32))),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              if (action != null) action!,
              IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
            ]),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Flexible(child: SingleChildScrollView(child: child)),
          ]));
}

class _FavCard extends StatelessWidget {
  final Plant plant;
  const _FavCard({required this.plant});
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
                height: 110,
                width: double.infinity,
                color: const Color(0xFFC8E6C9),
                child: plant.images.isNotEmpty
                    ? Image.network(plant.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.eco,
                                size: 40, color: Color(0xFF2E7D32))))
                    : const Center(
                        child: Icon(Icons.eco,
                            size: 40, color: Color(0xFF2E7D32))))),
        Padding(
            padding: const EdgeInsets.all(8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(plant.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              Text(plant.formattedPrice,
                  style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ])),
      ]));
}
