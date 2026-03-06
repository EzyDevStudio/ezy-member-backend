import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDashboardCard extends StatelessWidget {
  final bool isThisMonth;
  final Color color, iconColor;
  final IconData icon;
  final String data, title;

  const CustomDashboardCard({
    super.key,
    this.isThisMonth = false,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) => CustomContainer(
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomText(title, fontSize: 18.0, fontWeight: FontWeight.bold),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                spacing: 8.0,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Flexible(child: CustomText(data, fontSize: 24.0, fontWeight: FontWeight.bold)),
                  if (isThisMonth) CustomText(Globalization.thisMonth.tr.toLowerCase(), fontSize: 12.0, fontWeight: FontWeight.bold),
                ],
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: iconColor.withValues(alpha: 0.1)),
            padding: EdgeInsets.all(8.0),
            child: Icon(icon, color: iconColor, size: constraints.maxHeight * 0.3),
          ),
        ),
      ],
    ),
  );
}
