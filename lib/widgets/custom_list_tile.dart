import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomMenuListTile extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback? onTap;

  const CustomMenuListTile({super.key, this.isSelected = false, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    selected: isSelected,
    hoverColor: Colors.white.withValues(alpha: 0.1),
    selectedTileColor: Theme.of(context).colorScheme.tertiary,
    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
    onTap: onTap,
    title: CustomText(label, color: Theme.of(context).colorScheme.onPrimary, fontSize: 14.0, fontWeight: FontWeight.bold),
  );
}

class CustomExpansionListTile extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const CustomExpansionListTile({super.key, required this.label, required this.children});

  @override
  Widget build(BuildContext context) => ExpansionTile(
    backgroundColor: Colors.white.withValues(alpha: 0.25),
    collapsedIconColor: Theme.of(context).colorScheme.onPrimary,
    iconColor: Theme.of(context).colorScheme.onPrimary,
    tilePadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
    collapsedShape: const Border(),
    shape: const Border(),
    title: CustomText(label, color: Theme.of(context).colorScheme.onPrimary, fontSize: 14.0, fontWeight: FontWeight.bold),
    children: children,
  );
}
