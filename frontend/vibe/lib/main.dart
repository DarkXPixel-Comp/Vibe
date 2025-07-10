import 'package:flutter/material.dart';
import 'package:vibe/generated/auth/auth.pbgrpc.dart';
import 'package:vibe/services/auth_client.dart';

void main() {
  final client = AuthClient();
  runApp(MyApp(client: client.client));

  // final channel = ClientChannel(
  //     'localhost',
  //     port: 50051,
  //     options: const ChannelOptions(credentials: ChannelCredentials.insecure())
  //   );

  // final client = AuthServiceClient(channel);
}

class MyApp extends StatelessWidget {
  final AuthServiceClient client;
  const MyApp({super.key, required this.client});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(client: client,),
    );
  }
}

class LoginPage extends StatefulWidget {
  final AuthServiceClient client;
  const LoginPage({super.key, required this.client});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  
  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    
    try {
      final request = LoginRequest()
      ..username = username
      ..password = password;

      final respone = await widget.client.login(request);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login succesful! Token: ${respone.token}')),);

    } catch(e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }

    // if (username == "test" && password == "1234") {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Login successful!')),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Invalid credentials')),
    //   );
    // }
  }
  
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Vibe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}