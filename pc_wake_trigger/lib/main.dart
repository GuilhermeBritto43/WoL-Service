import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wake_on_lan/wake_on_lan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PC Wake Trigger',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel('com.example.pc_wake_trigger/actions');

  final TextEditingController _macController = TextEditingController(text: "XX:XX:XX:XX:XX:XX");
  final TextEditingController _ipController = TextEditingController(text: "192.168.X.255");
  
  // Função para disparar o WoL diretamente via código (substitui o clique no app de WoL)
  Future<void> _sendWakeOnLan() async {
    final macStr = _macController.text;
    final ipStr = _ipController.text;

    try {
      final mac = MACAddress.fromChar(macStr);
      final ip = IPv4Address.fromChar(ipStr);
      final wol = WakeOnLAN(mac, ipv4Address: ip);
      
      await wol.wake();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comando Wake-on-LAN enviado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar WoL: $e')),
      );
    }
  }

  // Função para simular o toque em coordenadas específicas na tela via nativo (Android Accessibility)
  Future<void> _tapAtCoordinates(double x, double y) async {
    try {
      await platform.invokeMethod('tapAt', {'x': x, 'y': y});
    } on PlatformException catch (e) {
      print("Falha ao simular toque: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Automação Ligar PC')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _macController, decoration: const InputDecoration(labelText: 'Endereço MAC do PC')),
            TextField(controller: _ipController, decoration: const InputDecoration(labelText: 'IP Broadcast da Rede (ex: 192.168.1.255)')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendWakeOnLan,
              child: const Text('Testar Wake-on-Lan Direto'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exemplo: Clicar na coordenada X=500, Y=1000 da tela
                _tapAtCoordinates(500, 1000);
              },
              child: const Text('Testar Clique em Coordenada (500, 1000)'),
            ),
          ],
        ),
      ),
    );
  }
}