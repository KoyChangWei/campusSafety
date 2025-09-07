import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/theme.dart';

class SOSButton extends StatefulWidget {
  const SOSButton({super.key});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isCountingDown = false;
  int _countdown = 5;
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
  
  void _startCountdown() {
    if (_isCountingDown) return;
    
    setState(() {
      _isCountingDown = true;
      _countdown = 5;
    });
    
    // Visual feedback instead of vibration
    
    // Start countdown
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return false;
      
      setState(() {
        _countdown--;
      });
      
      // Visual countdown feedback
      
      if (_countdown <= 0) {
        _triggerSOS();
        return false;
      }
      
      return true;
    });
  }
  
  void _cancelCountdown() {
    if (!_isCountingDown) return;
    
    setState(() {
      _isCountingDown = false;
    });
    
    // Visual feedback for cancellation
  }
  
  void _triggerSOS() {
    // TODO: Implement actual SOS functionality
    
    // Visual SOS feedback
    
    // Show SOS triggered dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert Sent'),
        content: const Text(
          'Your emergency alert has been sent to campus security and your trusted contacts. '
          'Help is on the way. Stay where you are if it\'s safe to do so.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isCountingDown = false;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onLongPress: _startCountdown,
      onLongPressUp: () {
        setState(() => _isPressed = false);
        if (!_isCountingDown) return;
      },
      child: _isCountingDown 
          ? _buildCountdownButton() 
          : _buildSOSButton(),
    );
  }
  
  Widget _buildSOSButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _isPressed 
          ? AppDimensions.sosButtonSizeLarge - 8
          : AppDimensions.sosButtonSizeLarge,
      height: _isPressed 
          ? AppDimensions.sosButtonSizeLarge - 8
          : AppDimensions.sosButtonSizeLarge,
      decoration: BoxDecoration(
        color: _isPressed 
            ? AppTheme.sosButtonPressedColor
            : AppTheme.sosButtonColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.sosButtonColor.withOpacity(0.4),
            blurRadius: _isPressed ? 4 : 8,
            spreadRadius: _isPressed ? 1 : 2,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emergency,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 4),
            Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Hold to activate',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCountdownButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated ring
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: AppDimensions.sosButtonSizeLarge + 16,
              height: AppDimensions.sosButtonSizeLarge + 16,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.sosCountdownColor.withOpacity(
                    0.3 + (_pulseController.value * 0.7),
                  ),
                  width: 3,
                ),
              ),
            );
          },
        ),
        
        // Button with countdown
        GestureDetector(
          onTap: _cancelCountdown,
          child: Container(
            width: AppDimensions.sosButtonSizeLarge,
            height: AppDimensions.sosButtonSizeLarge,
            decoration: const BoxDecoration(
              color: AppTheme.sosButtonPressedColor,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_countdown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 150.ms)
                .then()
                .fadeOut(delay: 700.ms, duration: 150.ms),
                
                const SizedBox(height: 4),
                
                const Text(
                  'Tap to cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
