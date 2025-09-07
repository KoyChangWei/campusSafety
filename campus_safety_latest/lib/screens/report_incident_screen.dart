import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ReportIncidentScreen extends StatefulWidget {
  const ReportIncidentScreen({super.key});

  @override
  State<ReportIncidentScreen> createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedCategory = 'Suspicious Activity';
  final List<String> _categories = [
    'Suspicious Activity',
    'Harassment',
    'Theft',
    'Vandalism',
    'Safety Hazard',
    'Medical Emergency',
    'Other',
  ];
  
  bool _isAnonymous = false;
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  
  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Photo Evidence'),
        content: const Text('Photo attachment feature coming soon! For now, please describe the incident in detail.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Report Submitted'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successColor,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Thank you for your report. Campus security has been notified and will review your submission.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Report ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Incident'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Submit an Incident Report',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Help keep our campus safe by reporting suspicious activities or safety concerns.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Incident Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Brief description of the incident',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Location Field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Where did this happen?',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Provide details about the incident',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Description is too short';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Attached Media
              Text(
                'Evidence',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Attach photos or videos as evidence (optional)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Media Buttons (Coming Soon)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showComingSoonDialog,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showComingSoonDialog,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Anonymous Toggle
              SwitchListTile(
                title: const Text('Submit Anonymously'),
                subtitle: const Text('Your identity will not be revealed to anyone'),
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
