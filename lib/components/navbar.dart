import 'package:flutter/material.dart';
import 'package:lifebeat/scripts/vars.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Color(0xFF232D33),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.schedule),
            icon: const Icon(Icons.calendar_today_rounded),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.goals),
            icon: const Icon(Icons.flag_rounded),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded),
          ),
        ],
      ),
    );
  }
}
