import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibe/providers.dart';


class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String? _tempToken;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Vibe!'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone number',
                hintText: '+7xxx-xxx-xx-xx',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            _isLoading ? CircularProgressIndicator() : ElevatedButton(
              onPressed: () async {
                setState(() => _isLoading = true);
                try {
                  final response = await authService.sendVerificationCode(_phoneController.text);
                  if(response.success) {
                    setState(() {
                      _tempToken = response.token;
                      _isLoading = false;
                    });
                  } else {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.message)),
                    );
                  }
                } catch (e) {
                  setState(() => _isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'))
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )
              ),
              child: Text('Send code'),
            ),
            if (_tempToken != null) ... [
              SizedBox(height: 16.0),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Code verification',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  setState(() => _isLoading = true);
                  try {
                    final response = await authService.verifyCode(
                      _phoneController.text,
                      _codeController.text,
                      _tempToken!);
                      setState(() => _isLoading = false);
                      if (response.success) {
                        Navigator.pushReplacementNamed(context, '/chats');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)),
                        );
                      }
                  } catch (e) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'))
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12.0),
                  ),
                )
              , child: Text('Confirm'))
            ]
          ],
        ),
        ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

}