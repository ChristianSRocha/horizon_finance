import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pacote necessário para formatação de data e moeda

// Certifique-se de que o pacote intl esteja no seu pubspec.yaml:
// dependencies:
//   intl: ^0.19.0 # Use a versão mais recente

enum TransactionType { receita, despesa }

class TransactionFormScreen extends StatefulWidget {
  final TransactionType initialType;
  final bool isEditing;

  const TransactionFormScreen({
    super.key,
    required this.initialType,
    this.isEditing = false,
  });

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  late TransactionType _type;
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  // Controladores de Estado
  DateTime _selectedDate = DateTime.now(); // Data inicial
  final TextEditingController _valueController = TextEditingController();

  // Listas de Categorias (simplificadas para o código)
  final List<String> _expenseCategories = [
    'Alimentação',
    'Moradia',
    'Lazer',
    'Transporte',
    'Saúde',
    'Educação',
    'Serviços'
  ];
  final List<String> _revenueCategories = [
    'Salário',
    'Investimento',
    'Freelance',
    'Renda Extra',
    'Presente',
    'Reembolso'
  ];

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  // FUNÇÃO PARA ABRIR O CALENDÁRIO
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Theme.of(context).primaryColor, // Cor primária do seu app
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF424242),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color typeColor = _type == TransactionType.receita
        ? const Color(0xFF2E7D32)
        : const Color(0xFFE53935);

    final String title = widget.isEditing
        ? 'Editar ${_type == TransactionType.receita ? "Receita" : "Despesa"}'
        : 'Nova ${_type == TransactionType.receita ? "Receita" : "Despesa"}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title,
            style: TextStyle(color: typeColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: widget.isEditing ? null : [_buildTypeSwapButton(typeColor)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              _buildValueField(typeColor),
              const SizedBox(height: 20),
              _buildCategoryDropdown(typeColor),
              const SizedBox(height: 20),
              _buildDescriptionField(typeColor),
              const SizedBox(height: 20),
              _buildDateField(typeColor),
              const SizedBox(height: 40),
              _buildActionButton(typeColor,
                  widget.isEditing ? 'Salvar Alterações' : 'Registrar'),
              if (widget.isEditing) _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES DE FORMULÁRIO (Atualizados) ---

  Widget _buildTypeSwapButton(Color typeColor) {
    final bool isReceita = _type == TransactionType.receita;

    return TextButton.icon(
      icon: Icon(isReceita ? Icons.arrow_downward : Icons.arrow_upward,
          color: typeColor),
      label: Text(
        isReceita ? 'Trocar para Despesa' : 'Trocar para Receita',
        style: TextStyle(color: typeColor),
      ),
      onPressed: () {
        setState(() {
          _type = isReceita ? TransactionType.despesa : TransactionType.receita;
          _selectedCategory = null;
        });
      },
    );
  }

  Widget _buildValueField(Color color) {
    return TextFormField(
      controller: _valueController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      // LÓGICA DE FORMATAÇÃO: Limita o input a números e formata para moeda no display
      onChanged: (value) {
        // Lógica simples de máscara (você pode expandir com um pacote como flutter_masked_text)
        final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
        if (cleanValue.isNotEmpty) {
          final number = int.parse(cleanValue);
          // Atualiza o controller com o valor formatado (ex: 10000 -> 100,00)
          final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: '');
          final formatted = formatter.format(number / 100);

          _valueController.value = TextEditingValue(
            text: formatted.trim(),
            selection: TextSelection.collapsed(offset: formatted.trim().length),
          );
        }
      },
      decoration: InputDecoration(
        labelText: 'Valor',
        prefixText: 'R\$ ',
        prefixStyle: TextStyle(color: color, fontSize: 18),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            double.tryParse(value.replaceAll('.', '').replaceAll(',', '.')) ==
                null) {
          return 'Insira um valor válido.';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown(Color typeColor) {
    final List<String> currentCategories = _type == TransactionType.receita
        ? _revenueCategories
        : _expenseCategories;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Categoria',
        prefixIcon: Icon(Icons.category_outlined, color: typeColor),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: typeColor, width: 2),
        ),
      ),
      initialValue: _selectedCategory,
      hint: const Text('Selecione uma categoria'),
      items: currentCategories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue;
        });
      },
      validator: (value) {
        if (value == null) return 'Selecione a categoria.';
        return null;
      },
    );
  }

  Widget _buildDescriptionField(Color color) {
    return TextFormField(
      maxLength: 100,
      decoration: InputDecoration(
        labelText: 'Descrição (Opcional)',
        prefixIcon: Icon(Icons.description_outlined, color: color),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }

  Widget _buildDateField(Color color) {
    // FUNÇÃO DE SELEÇÃO DE DATA
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Data',
        hintText: formatter.format(_selectedDate),
        prefixIcon: Icon(Icons.calendar_today, color: color),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      onTap: () => _selectDate(context), // LIGAÇÃO COM O showDatePicker
    );
  }

  Widget _buildActionButton(Color color, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Lógica para SALVAR a transação
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextButton(
        onPressed: () {
          // Lógica para EXCLUIR a transação
          Navigator.of(context).pop();
        },
        child: const Text('Excluir Transação',
            style: TextStyle(color: Color(0xFFE53935), fontSize: 16)),
      ),
    );
  }
}
