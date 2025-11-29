import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:horizon_finance/features/transactions/models/transactions.dart';
import 'package:horizon_finance/features/transactions/services/transaction_service.dart';
import 'package:horizon_finance/widgets/bottom_nav_menu.dart';

class Category {
  final int id;
  final String nome;
  final String tipo;

  Category({required this.id, required this.nome, required this.tipo});
}

class TransactionFormScreen extends ConsumerStatefulWidget {
  final TransactionType initialType;
  final Transaction? transaction;
  final bool isEditing;

  const TransactionFormScreen({
    super.key,
    required this.initialType,
    this.transaction,
    this.isEditing = false,
  });

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  late TransactionType _type;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();  // <-- ADICIONADO

  DateTime _selectedDate = DateTime.now();
  int? _selectedCategoryId;
  bool _isLoading = false;

  // --- CATEGORIAS ---
  static final List<Category> _allCategories = [
    Category(id: 1, nome: 'Salário', tipo: 'RECEITA'),
    Category(id: 2, nome: 'Renda Extra (Freela)', tipo: 'RECEITA'),
    Category(id: 3, nome: 'Investimentos', tipo: 'RECEITA'),
    Category(id: 4, nome: 'Presentes', tipo: 'RECEITA'),
    Category(id: 5, nome: 'Outras Receitas', tipo: 'RECEITA'),
    Category(id: 6, nome: 'Aluguel', tipo: 'DESPESA'),
    Category(id: 7, nome: 'Financiamento', tipo: 'DESPESA'),
    Category(id: 8, nome: 'Condomínio', tipo: 'DESPESA'),
    Category(id: 9, nome: 'Água', tipo: 'DESPESA'),
    Category(id: 10, nome: 'Energia Elétrica', tipo: 'DESPESA'),
    Category(id: 11, nome: 'Internet / TV / Telefone', tipo: 'DESPESA'),
    Category(id: 12, nome: 'Casa', tipo: 'DESPESA'),
    Category(id: 13, nome: 'Supermercado', tipo: 'DESPESA'),
    Category(id: 14, nome: 'Restaurantes / Delivery', tipo: 'DESPESA'),
    Category(id: 15, nome: 'Veículo', tipo: 'DESPESA'),
    Category(id: 16, nome: 'Transporte', tipo: 'DESPESA'),
    Category(id: 17, nome: 'Saúde', tipo: 'DESPESA'),
    Category(id: 18, nome: 'Cuidados Pessoais', tipo: 'DESPESA'),
    Category(id: 19, nome: 'Academia / Esportes', tipo: 'DESPESA'),
    Category(id: 20, nome: 'Lazer e Entretenimento', tipo: 'DESPESA'),
    Category(id: 21, nome: 'Compras', tipo: 'DESPESA'),
    Category(id: 22, nome: 'Assinaturas', tipo: 'DESPESA'),
    Category(id: 23, nome: 'Investimentos (Aportes)', tipo: 'DESPESA'),
    Category(id: 24, nome: 'Presentes / Doações', tipo: 'DESPESA'),
    Category(id: 25, nome: 'Educação', tipo: 'DESPESA'),
    Category(id: 26, nome: 'Outras Despesas', tipo: 'DESPESA'),
  ];

  List<Category> get _currentCategories {
    final tipo = _type == TransactionType.receita ? 'RECEITA' : 'DESPESA';
    return _allCategories.where((c) => c.tipo == tipo).toList();
  }

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;

    if (widget.isEditing && widget.transaction != null) {
      final t = widget.transaction!;
      _descriptionController.text = t.descricao;
      _valueController.text =
          NumberFormat.currency(locale: 'pt_BR', symbol: '')
              .format(t.valor)
              .trim();
      _selectedDate = t.data ?? DateTime.now();
      _type = t.tipo;
      _selectedCategoryId = t.categoriaId;
    }

    // Preenche a data no campo
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
  }

  @override
  void dispose() {
    _valueController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  double _parseValue(String text) {
    String clean = text
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(clean) ?? 0.0;
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    final valor = _parseValue(_valueController.text);
    if (valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira um valor maior que zero')),
      );
      return;
    }

    final descricao = _descriptionController.text.isEmpty
        ? (_type == TransactionType.receita ? 'Receita' : 'Despesa')
        : _descriptionController.text;

    final service = ref.read(TransactionServiceProvider);

    setState(() => _isLoading = true);

    try {
      if (widget.isEditing && widget.transaction != null) {
        await service.updateTransaction(
          id: widget.transaction!.id,
          descricao: descricao,
          tipo: _type,
          valor: valor,
          data: _selectedDate,
          categoriaId: _selectedCategoryId!,
          fixedTransaction: false,
        );
      } else {
        await service.addTransaction(
          descricao: descricao,
          tipo: _type,
          valor: valor,
          data: _selectedDate,
          categoriaId: _selectedCategoryId!,
          fixedTransaction: false,
        );
      }

      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            DateFormat('dd/MM/yyyy').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color typeColor = _type == TransactionType.receita
        ? const Color(0xFF2E7D32)
        : const Color(0xFFE53935);

    final title = widget.isEditing
        ? 'Editar ${_type == TransactionType.receita ? "Receita" : "Despesa"}'
        : 'Nova ${_type == TransactionType.receita ? "Receita" : "Despesa"}';

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false, // sem botão de voltar
        title: Text(
          title,
          style: TextStyle(color: typeColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: typeColor),
        actions: widget.isEditing ? null : [
          _buildTypeSwapButton(typeColor),
        ],
      ),

      bottomNavigationBar: BottomNavMenu(
        currentIndex: 2,
        primaryColor: Theme.of(context).primaryColor,
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Detalhes da Transação',
                        style: TextStyle(
                          fontSize: 18,
                          color: typeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildValueField(typeColor),
                      const SizedBox(height: 16),

                      _buildCategoryDropdown(typeColor),
                      const SizedBox(height: 16),

                      _buildDescriptionField(typeColor),
                      const SizedBox(height: 16),

                      _buildDateField(typeColor),
                      const SizedBox(height: 24),

                      _buildActionButton(
                        typeColor,
                        widget.isEditing
                            ? 'Salvar Alterações'
                            : 'Registrar',
                      ),

                      if (widget.isEditing) _buildDeleteButton(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // ----------------------------------------------
  // WIDGETS
  // ----------------------------------------------

  Widget _buildTypeSwapButton(Color color) {
    final isReceita = _type == TransactionType.receita;
    return TextButton.icon(
      icon: Icon(
        isReceita ? Icons.arrow_downward : Icons.arrow_upward,
        color: color,
      ),
      label: Text(
        isReceita ? 'Despesa' : 'Receita',
        style: TextStyle(color: color),
      ),
      onPressed: () {
        setState(() {
          _type = isReceita
              ? TransactionType.despesa
              : TransactionType.receita;
          _selectedCategoryId = null;
        });
      },
    );
  }

  Widget _buildValueField(Color color) {
    return TextFormField(
      controller: _valueController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Valor',
        prefixText: 'R\$ ',
        prefixStyle: TextStyle(color: color, fontSize: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      onChanged: (v) {
        final clean = v.replaceAll(RegExp(r'[^\d]'), '');
        if (clean.isEmpty) return;

        final number = int.parse(clean);
        final formatted = NumberFormat.currency(
          locale: 'pt_BR',
          symbol: '',
        ).format(number / 100).trim();

        _valueController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      },
      validator: (v) {
        if (v == null || v.isEmpty) return 'Insira um valor.';
        if (_parseValue(v) <= 0) return 'Insira um valor maior que zero.';
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown(Color color) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Categoria',
        prefixIcon: Icon(Icons.category_outlined, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      value: _selectedCategoryId,
      items: _currentCategories
          .map(
            (cat) => DropdownMenuItem(
              value: cat.id,
              child: Text(cat.nome),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => _selectedCategoryId = v),
      validator: (v) =>
          v == null ? 'Selecione a categoria.' : null,
    );
  }

  Widget _buildDescriptionField(Color color) {
    return TextFormField(
      controller: _descriptionController,
      maxLength: 100,
      decoration: InputDecoration(
        labelText: 'Descrição (Opcional)',
        prefixIcon: Icon(Icons.description_outlined, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }

  Widget _buildDateField(Color color) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Data',
        prefixIcon: Icon(Icons.calendar_today, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildActionButton(Color color, String text) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18)),
    );
  }

  Widget _buildDeleteButton() {
    return TextButton(
      onPressed: _deleteTransaction,
      child: const Text(
        'Excluir Transação',
        style: TextStyle(color: Color(0xFFE53935)),
      ),
    );
  }

  Future<void> _deleteTransaction() async {
    if (widget.transaction == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir'),
        content: const Text('Deseja excluir esta transação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(TransactionServiceProvider);
      await service.deleteTransaction(widget.transaction!.id);
      if (mounted) Navigator.pop(context, true);
    }
  }
}
