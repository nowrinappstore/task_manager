import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/controller/auth_controller.dart';

import '../screens/update_profile_screen.dart';

class TmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: InkWell(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProfileScreen()));
        },
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                'https://ix-marketing.imgix.net/bg-remove_after.png?auto=format,compress&w=1074',
              ),
            ),
        
            const SizedBox(width: 10),
        
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AuthController.userData?.firstName} ${AuthController.userData?.lastName}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: Colors.white),
                  ),
        
                  Text(
                    AuthController.userData!.email.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
