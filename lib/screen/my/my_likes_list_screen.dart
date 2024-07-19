// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../controller/my_menu_controller.dart';
//
//
// class MyLikesListScreen extends StatefulWidget {
//   const MyLikesListScreen({Key? key}) : super(key: key);
//
//   @override
//   _MyLikesListScreenState createState() => _MyLikesListScreenState();
// }
//
// class _MyLikesListScreenState extends State<MyLikesListScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MyMenuController>().setSelectedScreen('myLikes');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _myScheduleUI(context),
//       ),
//     );
//   }
//
//   Widget _myScheduleUI(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '나의 좋아요',
//             style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _myScheduleUIMobile(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: _myScheduleUI(context),
//     );
//   }
//
//   Widget _myScheduleUITablet(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 60),
//       child: _myScheduleUI(context),
//     );
//   }
//
//   Widget _myScheduleUIDesktop(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 80),
//         width: MediaQuery.of(context).size.width / 2,
//         child: _myScheduleUI(context),
//       ),
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/my_menu_controller.dart';

class MyLikesListScreen extends StatefulWidget {
  const MyLikesListScreen({Key? key}) : super(key: key);

  @override
  _MyLikesListScreenState createState() => _MyLikesListScreenState();
}

class _MyLikesListScreenState extends State<MyLikesListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myLikes');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _myScheduleUI(context),
      ),
    );
  }

  Widget _myScheduleUI(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 좋아요',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: 6, // 여기에 실제 데이터의 길이를 넣어야 합니다.
            itemBuilder: (context, index) {
              return _buildImageCard(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImageDialog(context);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Image.asset(
              '../assets/images/noImg.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
                // 좋아요 버튼 클릭 시 동작
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image.asset(
                          '../assets/images/noImg.jpg',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '이미지가 없습니다',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _myScheduleUIMobile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _myScheduleUI(context),
    );
  }

  Widget _myScheduleUITablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: _myScheduleUI(context),
    );
  }

  Widget _myScheduleUIDesktop(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80),
        width: MediaQuery.of(context).size.width / 2,
        child: _myScheduleUI(context),
      ),
    );
  }

}
