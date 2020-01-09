import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_share/ui/profile/bloc.dart';
import 'package:flutter_chat_share/ui/profile/profile_bloc.dart';
import 'package:flutter_chat_share/ui/profile/profile_screen.dart';
import 'package:flutter_chat_share/ui/search/SearchStore.dart';
import 'package:flutter_chat_share/ui/search/search_screen.dart';
import 'package:flutter_chat_share/ui/time_line/bloc/bloc.dart';
import 'package:flutter_chat_share/ui/time_line/time_line.dart';
import 'package:flutter_chat_share/ui/upload/bloc.dart';
import 'package:flutter_chat_share/ui/upload/upload_screen.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
//      onPageChanged: _onPageChanged,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          BlocProvider<TimeLineBloc>(
              create: (_) =>
                  TimeLineBloc()..add(CheckCreateUserTimeLineEvent()),
              child: TimeLineScreen()),
//          BlocProvider<SearchBloc>(
//              create: (_) => SearchBloc(), child: SearchScreen()),
          Injector(
              inject: [Inject<SearchStore>(() => SearchStore())],
              builder: (_) => SearchScreen()),
          BlocProvider<UploadBloc>(
            create: (_) => UploadBloc()..add(EmptyUploadFormEvent()),
            child: UploadScreen(),
          ),
          BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc()..add(FetchProfileInfoEvent()),
            child: ProfileScreen(),
          ),
//          ActivityFeed(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  CupertinoTabBar _buildBottomNavigationBar() {
    return CupertinoTabBar(
      currentIndex: _pageIndex,
      onTap: onTapNavigationBarItem,
      activeColor: Theme.of(context).primaryColor,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
        BottomNavigationBarItem(icon: Icon(Icons.search)),
        BottomNavigationBarItem(icon: Icon(Icons.photo_camera, size: 35)),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
//        BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
      ],
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  void onTapNavigationBarItem(int index) {
    setState(() {
      _pageIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
