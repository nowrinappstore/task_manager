import 'package:flutter/material.dart';
import 'package:task_manager/task_manager/controller/auth_controller.dart';
import '../screens/login_screen.dart';
import '../screens/update_profile_screen.dart';

class TmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
          );
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

            Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AuthController.userData?.firstName??'Not found'} ${AuthController.userData?.lastName??'Not Found'}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.white),
                ),

                Text(
                  AuthController.userData!.email.toString()??'Not Found',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.white),
                  
                ),

              ],
            ),
            SizedBox(width: 100,),

          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: (){
            logout(context);

          },
          icon: const Icon(Icons.logout,size: 25),
        ),
      ]
    );


    }
  Future<void>logout(BuildContext context)async{
    final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('আপনি কি লগআউট করতে চান?'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context,false);
              },
                  child: const Text('Cancel'),
              ),
              TextButton(onPressed: (){
                Navigator.pop(context,true);
              }, child: const Text('Logout',style: TextStyle(color: Colors.red),)),

            ],
          );
          
        },
        );
    //Cancel করলে এখান থেকে বের হয়ে যাবে
    if(confirm != true) return;

    // User data clear
    await AuthController.clearUserData(context);

    if(!context.mounted) return;

    // Login screen-এ নিয়ে যাবে এবং আগের সব route remove করবে

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen(),
    ), (route) => false);
        

    

  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  }





