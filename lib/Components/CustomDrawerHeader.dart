import 'package:cash_flow_app/Components/UserData.dart';
import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({Key? key, required this.userData})
      : super(key: key);
  final UserData userData;
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blueAccent,
            backgroundImage: AssetImage('assets/profile-pic.jpg'),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            userData.name,
            style: TextStyle(fontSize: 15),
          ),
          Text(
            userData.email,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
      decoration: BoxDecoration(color: Colors.blueAccent),
    );
  }
}
