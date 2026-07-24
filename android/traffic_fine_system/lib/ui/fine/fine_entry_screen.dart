// lib/ui/fine/fine_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_constants.dart';
import '../../utils/validation_utils.dart';
import '../../utils/extensions.dart';
import 'fine_view_model.dart';

class FineEntryScreen extends ConsumerStatefulWidget {
  const FineEntryScreen({super.key});

  @override
  ConsumerState<FineEntryScreen> createState() => _FineEntryScreenState();
}

class _FineEntryScreenState extends ConsumerState<FineEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _refController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _refController.dispose();
    // Reset state to initial so it doesn't immediately navigate if coming back
    Future.microtask(() {
      if (mounted) ref.read(fineViewModelProvider.notifier).reset();
    });
    super.dispose();
  }

  Future<void> _lookup() async {
    context.hideKeyboard();
    if (!_formKey.currentState!.validate()) return;
    await ref.read(fineViewModelProvider.notifier).fetchFineDetails(
          referenceNumber: _refController.text.trim(),
          categoryId: _selectedCategory!,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<FineState>(fineViewModelProvider, (_, state) {
      state.whenOrNull(
        loaded: (fine) => context.push(
          AppConstants.routePayment,
          extra: fine,
        ),
        error: (msg) => context.showSnackBar(msg, isError: true),
      );
    });

    final state = ref.watch(fineViewModelProvider);
    final isLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        title: const Text('Enter Fine Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader(
                icon: Icons.article_outlined,
                title: 'Fine Information',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _refController,
                decoration: const InputDecoration(
                  labelText: 'Fine Reference Number',
                  hintText: 'Enter the number from the fine sheet',
                  prefixIcon: Icon(Icons.numbers_rounded),
                ),
                validator: ValidationUtils.validateFineReference,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Fine Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: AppConstants.fineCategories.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text('${e.key} — ${e.value}'),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (_) => _selectedCategory == null
                    ? 'Please select a fine category'
                    : null,
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _lookup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003087),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.search_rounded, color: Colors.white),
                  label: Text(
                    isLoading ? 'Fetching...' : 'Look Up Fine',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Color(0xFF003087), size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'The fine reference number and category ID are printed on the traffic fine sheet.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF003087),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF003087), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF003087),
          ),
        ),
      ],
    );
  }
}
