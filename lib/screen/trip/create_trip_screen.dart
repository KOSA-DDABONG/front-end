import 'package:flutter/material.dart';
import 'package:front/screen/loading/creating_screen.dart';
import 'package:front/screen/trip/result_screen.dart';

import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/check_login_state.dart';
import '../../responsive.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({Key? key}) : super(key: key);

  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckLoginStateWidget(
      builder: (context, isLoggedIn) {
        PreferredSizeWidget currentAppBar;
        Widget? currentDrawer;
        if (isLoggedIn) {
          currentAppBar = Responsive.isNarrowWidth(context)
              ? ShortHeader(automaticallyImplyLeading: false)
              : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
              ? AfterLoginHeaderDrawer()
              : null;
        }
        else {
          currentAppBar = Responsive.isNarrowWidth(context)
              ? ShortHeader(automaticallyImplyLeading: false)
              : NotLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
              ? NotLoginHeaderDrawer()
              : null;
        }

        return Scaffold(
          appBar: currentAppBar,
          drawer: currentDrawer,
          body: _createTripScreen(),
        );
      }
    );
  }

  Widget _createTripScreen() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('부산 여행으로 2박 3일 추천해줘'),
                    ),
                  ),
                ),
                ListTile(
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('어떤 여행지를 추천해 드릴까요?'),
                    ),
                  ),
                ),
                ListTile(
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('액티비티 위주였으면 좋겠어'),
                    ),
                  ),
                ),
                ListTile(
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('추천 결과입니다.'),
                        ),
                        SizedBox(height: 5),
                        Image.asset('assets/images/noImg.jpg'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CreatingScreen()),
                            );
                          },
                          child: Text('더보기'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '메세지를 입력하세요.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}