import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDashboardCard extends StatelessWidget {
  final bool isThisMonth;
  final Color color;
  final IconData icon;
  final String data, title;

  const CustomDashboardCard({super.key, this.isThisMonth = true, required this.color, required this.icon, required this.data, required this.title});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: color,
      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black26, blurRadius: 2.0, offset: const Offset(3.0, 3.0))],
    ),
    padding: const EdgeInsets.all(16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomText(title, color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                spacing: 8.0,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Flexible(
                    child: CustomText(data, color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  if (isThisMonth)
                    CustomText(Globalization.thisMonth.tr.toLowerCase(), color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                ],
              ),
            ],
          ),
        ),
        LayoutBuilder(builder: (context, constraints) => Icon(icon, size: constraints.maxHeight * 0.7)),
      ],
    ),
  );
}
