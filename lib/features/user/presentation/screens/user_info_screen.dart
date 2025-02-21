// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../home/presentation/widgets/custom_txt_field.dart';

// class UserInfoScreen extends ConsumerStatefulWidget {
//   const UserInfoScreen({super.key});

//   @override
//   State<UserInfoScreen> createState() => _UserInfoScreenState();
// }

// class _UserInfoScreenState extends State<UserInfoScreen> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
    
//   }
// }



// return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Profile'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     const CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey,
//                       child: Icon(
//                         Icons.person,
//                         size: 50,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: CircleAvatar(
//                         radius: 16,
//                         backgroundColor: Colors.teal,
//                         child: const Icon(
//                           Icons.add,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CustomTextField(
//                     hinttxt: "Enter your Name",
//                     mycontroller: _nameController,
//                     textInputAction: TextInputAction.next,
//                   ),
//                   const SizedBox(height: 20),
//                   CustomTextField(
//                     hinttxt: "Enter your phone",
//                     mycontroller: _phoneController,
//                     textInputAction: TextInputAction.next,
//                   ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text(
//                   'Update Profile',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );\


//    final userId = ref.watch(appUserRiverpodProvider).user!.id!;
