import 'package:flutter/material.dart';
import 'package:plantyard/services/auth_service.dart';
import 'package:plantyard/screens/auth/login_screen.dart';
import 'package:plantyard/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getCurrentUser();
    if (user != null && mounted) {
      setState(() {
        userName = user.fullName;
        userEmail = user.email;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pwofil mwen'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header pwofil
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.lightGreen,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userName ?? 'Itilizatè',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userEmail ?? 'imèl@example.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Opsyon pwofil
          _buildMenuItem(
            icon: Icons.shopping_bag,
            title: 'Komand mwen yo',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.favorite,
            title: 'Favori mwen',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.location_on,
            title: 'Adrès livrezon',
            onTap: () {},
          ),
          _buildMenuItem(
            icon: Icons.notifications,
            title: 'Notifikasyon',
            onTap: () {},
          ),
          const Divider(height: 30),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Dekonekte',
            color: Colors.red,
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
