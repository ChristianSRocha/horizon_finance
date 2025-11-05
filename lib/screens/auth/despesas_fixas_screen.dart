import 'package:flutter/material.dart';
import 'package:horizon_finance/screens/dashboard/dashboard_screen.dart'; 
import 'package:supabase_flutter/supabase_flutter.dart';
import 'verify_email_screen.dart';

class DespesasFixasScreen extends StatefulWidget {
  const DespesasFixasScreen({super.key});

  @override
  State<DespesasFixasScreen> createState() => _DespesasFixasScreenState();
}

class _DespesasFixasScreenState extends State<DespesasFixasScreen> {
  final List<Map<String, dynamic>> _despesas = [
    {'name': 'Aluguel/Hipoteca', 'icon': Icons.home_outlined, 'value': 0.0},
    {'name': 'Assinaturas', 'icon': Icons.subscriptions_outlined, 'value': 0.0},
    {'name': 'Plano de Saúde', 'icon': Icons.local_hospital_outlined, 'value': 0.0},
    {'name': 'Mensalidades', 'icon': Icons.school_outlined, 'value': 0.0},
    {'name': 'Outras Despesas Fixas', 'icon': Icons.more_horiz, 'value': 0.0},
  ];

  @override
  void initState() {
    super.initState();
    _ensureEmailConfirmed();
  }

  Future<void> _ensureEmailConfirmed() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      final confirmed = user?.emailConfirmedAt != null;
      if (!confirmed) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
        );
      }
    } catch (e) {
      // Tratar erro se necessário
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 10),
          
          Text(
            'Quais são suas despesas fixas?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryBlue.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Insira 0,00 nas despesas que você não possui.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),

          Expanded(
            child: ListView.builder(
              itemCount: _despesas.length,
              itemBuilder: (context, index) {
                final despesa = _despesas[index];
                return _buildDespesaTile(
                  name: despesa['name'],
                  icon: despesa['icon'],
                  onValueChanged: (String value) {},
                  primaryColor: primaryBlue,
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 20, top: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue, 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Finalizar e Acessar o App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDespesaTile({
    required String name,
    required IconData icon,
    required ValueChanged<String> onValueChanged,
    required Color primaryColor,
  }) {
    final TextStyle valueStyle = TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),

            SizedBox(
              width: 120, 
              child: TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                onChanged: onValueChanged,
                style: valueStyle, 
                decoration: InputDecoration(
                  prefixText: 'R\$ ', 
                  prefixStyle: valueStyle, 
                  hintText: '0,00',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  isDense: true, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}