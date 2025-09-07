import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _studentIdController;
  
  @override
  void initState() {
    super.initState();
    
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final user = appProvider.currentUser ?? UserModel.empty();
    
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phoneNumber);
    _studentIdController = TextEditingController(text: user.studentId);
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }
  
  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }
  
  void _saveProfile() {
    // TODO: Implement profile update logic
    _toggleEditing();
  }
  
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              
              final appProvider = Provider.of<AppProvider>(context, listen: false);
              appProvider.clearCurrentUser();
              
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.currentUser ?? UserModel.empty();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                // Profile image
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  child: user.profileImage != null
                      ? ClipOval(
                          child: Image.network(
                            user.profileImage!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          user.name.isNotEmpty
                              ? user.name.substring(0, 1).toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                ),
                
                const SizedBox(height: 16),
                
                // User name
                if (!_isEditing)
                  Text(
                    user.name.isNotEmpty ? user.name : 'User',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                const SizedBox(height: 4),
                
                // User role badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    user.role.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Profile form
          if (_isEditing)
            _buildProfileForm()
          else
            _buildProfileInfo(user),
          
          const SizedBox(height: 32),
          
          // Edit/Save button
          Center(
            child: ElevatedButton.icon(
              onPressed: _isEditing ? _saveProfile : _toggleEditing,
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              label: Text(_isEditing ? 'Save Profile' : 'Edit Profile'),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Settings and options
          const Divider(),
          
          _buildSettingItem(
            icon: Icons.shield,
            title: 'Trusted Contacts',
            subtitle: 'Manage your emergency contacts',
            onTap: () {
              // TODO: Navigate to trusted contacts screen
            },
          ),
          
          _buildSettingItem(
            icon: Icons.settings,
            title: 'App Settings',
            subtitle: 'Notifications, privacy, and more',
            onTap: () {
              // TODO: Navigate to settings screen
            },
          ),
          
          _buildSettingItem(
            icon: Icons.accessibility,
            title: 'Accessibility',
            subtitle: 'Text-to-speech, high contrast mode',
            onTap: () {
              // TODO: Navigate to accessibility settings
            },
          ),
          
          _buildSettingItem(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'FAQs, contact support',
            onTap: () {
              // TODO: Navigate to help screen
            },
          ),
          
          _buildSettingItem(
            icon: Icons.info,
            title: 'About',
            subtitle: 'App version, terms, privacy policy',
            onTap: () {
              // TODO: Navigate to about screen
            },
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Logout button
          Center(
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.dangerColor,
                side: const BorderSide(color: AppTheme.dangerColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildProfileInfo(UserModel user) {
    return Column(
      children: [
        _buildInfoItem(
          icon: Icons.email,
          title: 'Email',
          value: user.email.isNotEmpty ? user.email : 'Not set',
        ),
        
        _buildInfoItem(
          icon: Icons.phone,
          title: 'Phone',
          value: user.phoneNumber.isNotEmpty ? user.phoneNumber : 'Not set',
        ),
        
        _buildInfoItem(
          icon: Icons.badge,
          title: 'Student/Staff ID',
          value: user.studentId.isNotEmpty ? user.studentId : 'Not set',
        ),
        
        _buildInfoItem(
          icon: Icons.verified_user,
          title: 'Account Status',
          value: user.isVerified ? 'Verified' : 'Unverified',
          valueColor: user.isVerified ? AppTheme.successColor : AppTheme.warningColor,
        ),
      ],
    );
  }
  
  Widget _buildProfileForm() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
        ),
        
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _studentIdController,
          decoration: const InputDecoration(
            labelText: 'Student/Staff ID',
            prefixIcon: Icon(Icons.badge),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
