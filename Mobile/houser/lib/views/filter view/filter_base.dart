import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:houser/views/filter%20view/filter_room_view.dart';
import 'package:houser/views/filter%20view/filter_user_view.dart';

class FilterBaseView extends StatefulWidget {
  const FilterBaseView({Key? key}) : super(key: key);

  @override
  _FilterBaseViewState createState() => _FilterBaseViewState();
}

class _FilterBaseViewState extends State<FilterBaseView> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoginButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      backgroundColor: Colors.transparent,
    );
  }

  Widget body()
  {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
          child: Column(
            children: [
              tabBar(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FilterRoomView(),
                      FilterUserView(),
                    ],
                  ),
                ),
              ),
              button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabBar()
  {
    double borderRadius = 8;
    var theme = Theme.of(context);

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          color: Colors.white,
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600
        ),
        tabs: [
          Tab(
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  color: theme.primaryColorDark,
                ),
                Expanded(
                  child: AutoSizeText(
                    'KAMBARYS',
                    maxLines: 1,
                    style: TextStyle(
                      color: theme.primaryColorDark,
                    ),
                  ),
                )
              ],
            ),
          ),
          Tab(
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: theme.primaryColorDark,
                ),
                Expanded(
                  child: AutoSizeText(
                    'KAMBARIOKAS',
                    maxLines: 1,
                    style: TextStyle(
                      color: theme.primaryColorDark,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget button()
  {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      height: 90,
      width: double.infinity,
      child: TextButton(
        onPressed: ! _isLoginButtonEnabled ? null : () async {
          setState(() {
            _isLoginButtonEnabled = false;
          });
          if(!_formKey.currentState!.validate()) {
            setState(() {
              _isLoginButtonEnabled = true;
            });
            return;
          }
          await onButtonClick();

          setState(() {
            _isLoginButtonEnabled = true;
          });
        },
        style: TextButton.styleFrom(
            backgroundColor: Colors.redAccent
        ),
        child: Text(
          'Nustatyti filtrą'.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16
          ),
        ),
      ),
    );
  }

  Future onButtonClick() async {
    return;
  }
}
