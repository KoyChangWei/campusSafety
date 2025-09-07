import 'package:flutter/material.dart';
import '../utils/theme.dart';

class WalkWithMeScreen extends StatefulWidget {
  const WalkWithMeScreen({super.key});

  @override
  State<WalkWithMeScreen> createState() => _WalkWithMeScreenState();
}

class _WalkWithMeScreenState extends State<WalkWithMeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  int _selectedDuration = 15;
  final List<int> _durationOptions = [5, 10, 15, 20, 30, 45, 60];
  final List<String> _contactOptions = ['None selected'];
  String _selectedContact = 'None selected';
  bool _shareWithSecurity = true;
  bool _isSessionActive = false;
  bool _isLoading = false;
  
  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }
  
  void _startSession() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isSessionActive = true;
          });
        }
      });
    }
  }
  
  void _endSession() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSessionActive = false;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk With Me'),
      ),
      body: _isSessionActive 
          ? _buildActiveSession() 
          : _buildSetupForm(),
    );
  }
  
  Widget _buildSetupForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_walk,
                  size: 60,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Share Your Journey',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Let trusted contacts or campus security follow your route in real-time until you reach your destination safely.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Destination Field
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                hintText: 'Where are you going?',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your destination';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Duration Selector
            Text(
              'Estimated Duration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              children: _durationOptions.map((duration) {
                final isSelected = duration == _selectedDuration;
                return ChoiceChip(
                  label: Text('$duration min'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedDuration = duration;
                      });
                    }
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected 
                        ? AppTheme.primaryColor 
                        : AppTheme.textSecondaryColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Contact Selector
            Text(
              'Share With Trusted Contact',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            
            const SizedBox(height: 8),
            
            DropdownButtonFormField<String>(
              value: _selectedContact,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
              ),
              items: _contactOptions.map((contact) {
                return DropdownMenuItem<String>(
                  value: contact,
                  child: Text(contact),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedContact = value;
                  });
                }
              },
            ),
            
            const SizedBox(height: 8),
            
            TextButton(
              onPressed: () {
                // TODO: Navigate to add contact screen
              },
              child: const Text('+ Add New Contact'),
            ),
            
            const SizedBox(height: 16),
            
            // Share with security toggle
            SwitchListTile(
              title: const Text('Share with Campus Security'),
              subtitle: const Text('Allow security personnel to monitor your journey'),
              value: _shareWithSecurity,
              onChanged: (value) {
                setState(() {
                  _shareWithSecurity = value;
                });
              },
              activeColor: AppTheme.primaryColor,
            ),
            
            const SizedBox(height: 32),
            
            // Start Button
            ElevatedButton(
              onPressed: _isLoading ? null : _startSession,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Start Sharing Location'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActiveSession() {
    return Column(
      children: [
        // Map placeholder
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 80,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Map View',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Your live location will be shown here'),
                ],
              ),
            ),
          ),
        ),
        
        // Session info panel
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Destination and timer
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destination',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        Text(
                          _destinationController.text.isNotEmpty
                              ? _destinationController.text
                              : 'Unknown destination',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 16,
                          color: AppTheme.successColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_selectedDuration min',
                          style: const TextStyle(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Sharing with info
              if (_shareWithSecurity)
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text('Campus Security'),
                  subtitle: Text('Monitoring your journey'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              
              if (_selectedContact != 'None selected')
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.secondaryColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(_selectedContact),
                  subtitle: const Text('Trusted contact'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              
              const SizedBox(height: 16),
              
              // End Session Button
              ElevatedButton(
                onPressed: _isLoading ? null : _endSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.dangerColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('End Journey'),
              ),
              
              const SizedBox(height: 8),
              
              // SOS Button
              OutlinedButton(
                onPressed: () {
                  // TODO: Trigger SOS
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.dangerColor,
                  side: const BorderSide(color: AppTheme.dangerColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('SOS Emergency'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
