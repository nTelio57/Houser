import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:houser/enums/FilterType.dart';
import 'package:houser/models/Filter.dart';
import 'package:houser/models/RoomFilter.dart';
import 'package:houser/models/UserFilter.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/views/filter%20view/filter_create_room_offer.dart';
import 'package:houser/views/filter%20view/filter_room_view.dart';
import 'package:houser/views/filter%20view/filter_user_view.dart';
import 'package:houser/views/profile%20view/room_form_view.dart';

// ignore: must_be_immutable
class FilterBaseView extends StatefulWidget {
  final CurrentLogin _currentLogin = CurrentLogin();

  FilterBaseView(this.onFilterChanged, {Key? key}) : super(key: key);

  Function(Filter) onFilterChanged;

  @override
  _FilterBaseViewState createState() => _FilterBaseViewState();
}

class _FilterBaseViewState extends State<FilterBaseView> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = true;
  var filterUserForm = FilterUserView();
  var filterRoomForm = FilterRoomView();
  var filterCreateRoomOffer = FilterCreateRoomOffer((){});

  @override
  void initState() {
    filterCreateRoomOffer.onButtonClick = onCreateRoomOfferClick;
    _tabController = TabController(length: 2, vsync: this, initialIndex: loadFormByFilter());
    super.initState();
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
                      filterRoomForm,
                      userFormLoader(),
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

  Widget userFormLoader()
  {
    return FutureBuilder(
      future: hasAnyRoomOffers(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot)
        {
          if(snapshot.hasData)
          {
            if(snapshot.data!)
              {
                return filterUserForm;
              }
            else
              {
                return filterCreateRoomOffer;
              }
          }
          else if(snapshot.hasError)
          {
            return SizedBox(
              width: double.infinity,
              child: Text(
                'Įvyko klaida.'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.red
                ),
              ),
            );
          }
          else
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
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
        onPressed: ! _isButtonEnabled ? null : () async {
          setState(() {
            _isButtonEnabled = false;
          });
          if(!_formKey.currentState!.validate()) {
            setState(() {
              _isButtonEnabled = true;
            });
            return;
          }

          var currentFilter = widget._currentLogin.user!.filter;
          if(currentFilter != null)
            {
              currentFilter.id = 0;
              if(getFilterByForm() == currentFilter)
              {
                Navigator.pop(context);
                return;
              }
            }

          EasyLoading.show();
          await onButtonClick();
          EasyLoading.dismiss();

          setState(() {
            _isButtonEnabled = true;
          });
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          )
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

  Filter getFilterByForm()
  {
    switch(_tabController.index){
      case 0:
        return filterRoomForm.getFilterByForm();
      case 1:
        return filterUserForm.getFilterByForm();
    }
    return Filter(1, '', FilterType.none);
  }

  int loadFormByFilter()
  {
    if(widget._currentLogin.user!.filter == null) {
      return 0;
    }

    switch(widget._currentLogin.user!.filter!.filterType)
    {
      case FilterType.room:
        filterRoomForm.setFormByFilter(widget._currentLogin.user!.filter! as RoomFilter);
        return 0;
      case FilterType.user:
        filterUserForm.setFormByFilter(widget._currentLogin.user!.filter! as UserFilter);
        return 1;
      default:
        return 0;
    }
  }

  Future onButtonClick() async {
    await widget.onFilterChanged(getFilterByForm());
  }

  void onCreateRoomOfferClick()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RoomFormView())).then((value) {
      setState(() {

      });
    });
  }

  Future<bool> hasAnyRoomOffers() async
  {
    var roomList = await ApiService().GetRoomsByUser(widget._currentLogin.user!.id);
    return roomList.isNotEmpty;
  }
}
