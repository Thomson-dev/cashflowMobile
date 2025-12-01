import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cashflow/app/data/services/auth_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

enum TransactionType { income, expense }

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => TransactionFormState();
}

class TransactionFormState extends State<TransactionForm>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  TransactionType _type = TransactionType.income;
  bool _isSubmitting = false;

  final _amountCtrl = TextEditingController(text: '0.00');
  final _descCtrl = TextEditingController();
  String? _category;
  DateTime _date = DateTime.now();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final _categories = const <String>[
    'Salary',
    'Food',
    'Transport',
    'Bills',
    'Shopping',
    'Health',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Professional color palette
  Color get _primary => const Color(0xFF2563EB); // blue-600
  Color get _primaryLight => const Color(0xFF3B82F6); // blue-500
  Color get _primaryDark => const Color(0xFF1D4ED8); // blue-700
  Color get _success => const Color(0xFF10B981); // emerald-500
  Color get _successLight => const Color(0xFFECFDF5); // emerald-50
  Color get _danger => const Color(0xFFEF4444); // red-500
  Color get _dangerLight => const Color(0xFFFEF2F2); // red-50
  Color get _stroke => const Color(0xFFE5E7EB); // gray-200
  Color get _strokeLight => const Color(0xFFF3F4F6); // gray-100
  Color get _label => const Color(0xFF374151); // gray-700
  Color get _labelLight => const Color(0xFF6B7280); // gray-500
  Color get _text => const Color(0xFF111827); // gray-900
  Color get _hint => const Color(0xFF9CA3AF); // gray-400
  Color get _bgSoft => const Color(0xFFFAFAFA); // gray-50
  Color get _card => Colors.white;
  Color get _shadow => const Color(0xFF000000).withOpacity(0.05);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildTransactionTypeSection(),
                    const SizedBox(height: 24),
                    _buildAmountSection(),
                    const SizedBox(height: 24),
                    _buildDescriptionSection(),
                    const SizedBox(height: 24),
                    _buildCategorySection(),
                    const SizedBox(height: 24),
                    _buildDateSection(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.add_card_rounded, color: _primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Transaction',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: _text,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Record your financial activity',
                    style: TextStyle(
                      fontSize: 13,
                      color: _labelLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Transaction Type'),
        const SizedBox(height: 12),
        _TypeSelector(
          value: _type,
          onChanged: (v) => setState(() => _type = v),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Amount (₦)'),
        const SizedBox(height: 12),
        TextFormField(
          controller: _amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          style: TextStyle(
            color: _labelLight,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          decoration: _decoration(
            hint: '0.00',
            prefix: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                '₦',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _labelLight, 
                  fontSize: 14.5,
                ),
              ),
            ),
          ),
          validator: (v) {
            final val = double.tryParse(
              v?.trim().isEmpty == true ? '0' : v!.trim(),
            );
            if (val == null || val <= 0) return 'Enter a valid amount';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Description'),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descCtrl,
          maxLines: 2,
          decoration: _decoration(
            hint: 'Enter transaction description',
            prefixIcon: Icons.description_outlined,
          ),
          style: TextStyle(color: _text, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Category'),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _category,
          items:
              _categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(
                        c,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _text,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (v) => setState(() => _category = v),
          decoration: _decoration(
            hint: 'Select category',
            prefixIcon: Icons.category_outlined,
          ),
          validator: (v) => v == null ? 'Please select a category' : null,
          dropdownColor: _card,
          style: TextStyle(
            color: _text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Date'),
        const SizedBox(height: 12),
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: _formatDate(_date)),
          decoration: _decoration(
            hint: 'MM/DD/YYYY',
            prefixIcon: Icons.calendar_today_outlined,
            suffixIcon: Icons.keyboard_arrow_down_rounded,
          ),
          style: TextStyle(
            color: _text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: _primary,
                      onPrimary: Colors.white,
                      onSurface: _text,
                      surface: _card,
                    ),
                    textTheme: Theme.of(
                      context,
                    ).textTheme.copyWith(bodyLarge: TextStyle(color: _text)),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) setState(() => _date = picked);
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF10B981),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.pressed)) {
              return _primaryDark.withOpacity(0.1);
            }
            return null;
          }),
        ),
        onPressed: () {
          if (_formKey.currentState?.validate() != true) return;
          _submitTransaction();
        },
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Add Transaction',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
            fontSize: 14.5,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}/${d.year}';

  // Submit transaction to API
  Future<void> _submitTransaction() async {
    setState(() => _isSubmitting = true);

    try {
      final amount = double.parse(_amountCtrl.text.replaceAll(',', ''));
      final dateStr = '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';

      final response = await _authService.createTransaction(
        type: _type == TransactionType.income ? 'income' : 'expense',
        amount: amount,
        description: _descCtrl.text.trim(),
        category: _category ?? '',
        date: dateStr,
        tags: [],
      );

      // Show success snackbar
      _showAwesomeSnackbar(
        title: 'Success!',
        message: 'Transaction added successfully',
        contentType: ContentType.success,
      );

      // Clear form
      _amountCtrl.text = '0.00';
      _descCtrl.clear();
      setState(() {
        _category = null;
        _date = DateTime.now();
      });

      // Navigate back or refresh
      Get.back();
    } catch (e) {
      _showAwesomeSnackbar(
        title: 'Error!',
        message: e.toString().replaceAll('Exception: ', ''),
        contentType: ContentType.failure,
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // Show awesome snackbar
  void _showAwesomeSnackbar({
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: TextStyle(
      color: _label,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );

  InputDecoration _decoration({
    String? hint,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon:
          prefixIcon == null
              ? (prefix == null ? null : prefix)
              : Icon(prefixIcon, color: _hint, size: 20),
      suffixIcon:
          suffixIcon == null ? null : Icon(suffixIcon, color: _hint, size: 20),
      filled: true,
      fillColor: _bgSoft,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(
        color: _hint,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _stroke, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF10B981), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _danger, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _danger, width: 2),
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final TransactionType value;
  final ValueChanged<TransactionType> onChanged;

  const _TypeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _buildOption(
            isSelected: value == TransactionType.income,
            label: 'Income',
            icon: Icons.trending_up_rounded,
            color: const Color(0xFF10B981),
            onTap: () => onChanged(TransactionType.income),
          ),
          const SizedBox(width: 8),
          _buildOption(
            isSelected: value == TransactionType.expense,
            label: 'Expense',
            icon: Icons.trending_down_rounded,
            color: const Color(0xFFEF4444),
            onTap: () => onChanged(TransactionType.expense),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required bool isSelected,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? color : const Color(0xFF64748B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : const Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
