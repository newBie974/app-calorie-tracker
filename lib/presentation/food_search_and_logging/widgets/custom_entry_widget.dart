import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomEntryWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddCustomEntry;

  const CustomEntryWidget({
    super.key,
    required this.onAddCustomEntry,
  });

  @override
  State<CustomEntryWidget> createState() => _CustomEntryWidgetState();
}

class _CustomEntryWidgetState extends State<CustomEntryWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _servingSizeController = TextEditingController();

  bool _isExpanded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _servingSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'add',
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Custom Entry',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Create your own food entry',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expandable form
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded ? null : 0,
            child:
                _isExpanded ? _buildCustomEntryForm() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomEntryForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
        child: Column(
          children: [
            Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2)),
            SizedBox(height: 2.h),

            // Food name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                hintText: 'Enter food name',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a food name';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),

            // Serving size
            TextFormField(
              controller: _servingSizeController,
              decoration: const InputDecoration(
                labelText: 'Serving Size',
                hintText: 'e.g., 100g, 1 cup, 1 piece',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter serving size';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),

            // Calories
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories',
                hintText: 'Enter calories per serving',
                suffixText: 'cal',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter calories';
                }
                final calories = int.tryParse(value);
                if (calories == null || calories < 0) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),

            // Macronutrients row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _proteinController,
                    decoration: const InputDecoration(
                      labelText: 'Protein',
                      hintText: '0.0',
                      suffixText: 'g',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final protein = double.tryParse(value);
                        if (protein == null || protein < 0) {
                          return 'Invalid';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: TextFormField(
                    controller: _carbsController,
                    decoration: const InputDecoration(
                      labelText: 'Carbs',
                      hintText: '0.0',
                      suffixText: 'g',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final carbs = double.tryParse(value);
                        if (carbs == null || carbs < 0) {
                          return 'Invalid';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: TextFormField(
                    controller: _fatController,
                    decoration: const InputDecoration(
                      labelText: 'Fat',
                      hintText: '0.0',
                      suffixText: 'g',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final fat = double.tryParse(value);
                        if (fat == null || fat < 0) {
                          return 'Invalid';
                        }
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitCustomEntry,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Add Custom Entry',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitCustomEntry() {
    if (_formKey.currentState!.validate()) {
      final customEntry = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': _nameController.text.trim(),
        'brand': 'Custom Entry',
        'calories': int.parse(_caloriesController.text),
        'protein': double.tryParse(_proteinController.text) ?? 0.0,
        'carbs': double.tryParse(_carbsController.text) ?? 0.0,
        'fat': double.tryParse(_fatController.text) ?? 0.0,
        'servingSize': _servingSizeController.text.trim(),
        'image':
            'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        'isFavorite': false,
        'isCustom': true,
        'timestamp': DateTime.now(),
      };

      widget.onAddCustomEntry(customEntry);

      // Clear form
      _nameController.clear();
      _caloriesController.clear();
      _proteinController.clear();
      _carbsController.clear();
      _fatController.clear();
      _servingSizeController.clear();

      // Collapse form
      setState(() {
        _isExpanded = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Custom entry added successfully!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }
}
