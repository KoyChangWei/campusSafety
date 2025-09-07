import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';

class TrustedContactsScreen extends StatefulWidget {
  const TrustedContactsScreen({super.key});

  @override
  State<TrustedContactsScreen> createState() => _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _relationshipController = TextEditingController();
  
  bool _notifyOnSOS = true;
  bool _notifyOnWalkWithMe = true;
  bool _isEditing = false;
  String? _editingContactId;
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }
  
  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _relationshipController.clear();
    _notifyOnSOS = true;
    _notifyOnWalkWithMe = true;
    _isEditing = false;
    _editingContactId = null;
  }
  
  void _editContact(TrustedContact contact) {
    setState(() {
      _nameController.text = contact.name;
      _phoneController.text = contact.phoneNumber;
      _emailController.text = contact.email ?? '';
      _relationshipController.text = contact.relationship;
      _notifyOnSOS = contact.notifyOnSOS;
      _notifyOnWalkWithMe = contact.notifyOnWalkWithMe;
      _isEditing = true;
      _editingContactId = contact.id;
    });
  }
  
  void _deleteContact(String contactId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Contact'),
        content: const Text('Are you sure you want to remove this trusted contact?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final appProvider = Provider.of<AppProvider>(context, listen: false);
              appProvider.removeTrustedContact(contactId);
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact removed successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Remove'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.dangerColor,
            ),
          ),
        ],
      ),
    );
  }
  
  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      
      final newContact = TrustedContact(
        id: _isEditing ? _editingContactId! : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        relationship: _relationshipController.text,
        notifyOnSOS: _notifyOnSOS,
        notifyOnWalkWithMe: _notifyOnWalkWithMe,
      );
      
      if (_isEditing) {
        // First remove the old contact
        appProvider.removeTrustedContact(_editingContactId!);
      }
      
      // Add the new/updated contact
      appProvider.addTrustedContact(newContact);
      
      // Clear the form
      _clearForm();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Contact updated successfully' : 'Contact added successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.currentUser;
    final contacts = user?.trustedContacts ?? [];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Manage Trusted Contacts',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Add people who should be notified during emergencies or when you\'re using Walk With Me.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contact list
            if (contacts.isEmpty)
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 64,
                      color: AppTheme.textTertiaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No trusted contacts yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first contact below',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                child: Text(
                                  contact.name.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      contact.relationship,
                                      style: TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editContact(contact),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteContact(contact.id),
                                tooltip: 'Delete',
                                color: AppTheme.dangerColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildContactInfoRow(Icons.phone, contact.phoneNumber),
                          if (contact.email != null)
                            _buildContactInfoRow(Icons.email, contact.email!),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildNotificationChip(
                                'SOS Alerts',
                                contact.notifyOnSOS,
                                AppTheme.dangerColor,
                              ),
                              const SizedBox(width: 8),
                              _buildNotificationChip(
                                'Walk With Me',
                                contact.notifyOnWalkWithMe,
                                AppTheme.primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            
            const SizedBox(height: 32),
            
            // Add/Edit contact form
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Edit Contact' : 'Add New Contact',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter contact name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Phone Field
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter phone number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Email Field (Optional)
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email (Optional)',
                          hintText: 'Enter email address',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Relationship Field
                      TextFormField(
                        controller: _relationshipController,
                        decoration: const InputDecoration(
                          labelText: 'Relationship',
                          hintText: 'E.g., Family, Friend, Roommate',
                          prefixIcon: Icon(Icons.people),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your relationship';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Notification toggles
                      Text(
                        'Notification Settings',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      SwitchListTile(
                        title: const Text('Notify for SOS Alerts'),
                        subtitle: const Text('Contact will be notified during emergencies'),
                        value: _notifyOnSOS,
                        onChanged: (value) {
                          setState(() {
                            _notifyOnSOS = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      SwitchListTile(
                        title: const Text('Notify for Walk With Me'),
                        subtitle: const Text('Contact will be notified when sharing your journey'),
                        value: _notifyOnWalkWithMe,
                        onChanged: (value) {
                          setState(() {
                            _notifyOnWalkWithMe = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Form buttons
                      Row(
                        children: [
                          if (_isEditing)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _clearForm,
                                child: const Text('Cancel'),
                              ),
                            ),
                          if (_isEditing)
                            const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveContact,
                              child: Text(_isEditing ? 'Update' : 'Add Contact'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContactInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
  
  Widget _buildNotificationChip(String label, bool isEnabled, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isEnabled ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEnabled ? color : Colors.grey,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEnabled ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isEnabled ? color : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isEnabled ? color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
