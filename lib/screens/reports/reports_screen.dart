import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Relatórios e Análises',
            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seletor de Período
            _buildPeriodSelector(primaryBlue),
            const SizedBox(height: 20),

            // Cartão do Gráfico
            _buildChartCard(primaryBlue),
            const SizedBox(height: 20),

            // Lista de Categorias de Despesas (Legenda do Gráfico)
            _buildCategoryList('Alimentação', 850.00, Colors.blueAccent),
            _buildCategoryList('Moradia', 1500.00, Colors.redAccent),
            _buildCategoryList('Transporte', 450.00, Colors.orangeAccent),
            _buildCategoryList('Lazer', 300.00, primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'Mês Atual',
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: primaryColor),
          items: const [
            DropdownMenuItem(value: 'Mês Atual', child: Text('Mês Atual')),
            DropdownMenuItem(
                value: 'Últimos 30 dias', child: Text('Últimos 30 dias')),
            DropdownMenuItem(
                value: 'Último Trimestre', child: Text('Último Trimestre')),
          ],
          onChanged: (String? newValue) {
            // Lógica de filtro
          },
        ),
      ),
    );
  }

  Widget _buildChartCard(Color primaryColor) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribuição de Despesas',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242)),
            ),
            const SizedBox(height: 15),
            Container(
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('GRÁFICO DE PIZZA (FL_CHART)',
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(String name, double amount, Color color) {
    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(name),
      trailing: Text(
        'R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}',
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Color(0xFF424242)),
      ),
      onTap: () {},
    );
  }
}
