//System Packages
import 'package:compete_viewer/resources/repository.dart';
import 'package:flutter/material.dart';
//Blocs
import 'package:compete_viewer/blocs/add_contestant_bloc.dart';
import 'package:compete_viewer/blocs/leaderboard_bloc.dart';
import 'package:compete_viewer/blocs/update_contestant_bloc.dart';
//Models
import 'package:compete_viewer/models/contestant_model.dart';
//Utilities
import 'package:compete_viewer/utilities/screen_handler.dart';
import 'package:flutter/rendering.dart';

class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  int _sortSelectionIndex;
  static Contestant pinnedContestant;
  static final _appBarTitles = <dynamic>
  [
    {"title":"Add Contestant", "icon":Icons.person_add},
    {"title":"Leaderboard","icon":Icons.score},
    {"title":"Update Contestant","icon":Icons.edit}
  ];

  final _fieldProperties =
  [
    {
      "keyboardType": TextInputType.text, "prefixIcon": Icon(Icons.person, color: Colors.greenAccent),
      "labelText": "Contestant Name", "onChanged": updateContestantBloc.changeContName
    },
    {
      "keyboardType": TextInputType.number, "prefixIcon": Icon(Icons.thumb_up, color: Colors.blueAccent),
      "labelText": "Facebook Likes", "onChanged": updateContestantBloc.changeFBLikes
    },
    {
      "keyboardType": TextInputType.number, "prefixIcon": Icon(Icons.comment, color: Colors.blueAccent),
      "labelText": "Facebook Comments", "onChanged": updateContestantBloc.changeFBComments
    },
    {
      "keyboardType": TextInputType.number, "prefixIcon": Icon(Icons.share, color: Colors.blueAccent),
      "labelText": "Facebook Shares", "onChanged": updateContestantBloc.changeFBShares
    },
    {
      "keyboardType": TextInputType.number, "prefixIcon": Icon(Icons.thumb_up, color: Colors.pinkAccent),
      "labelText": "Instagram Likes", "onChanged": updateContestantBloc.changeInstaLikes
    },
    {
      "keyboardType": TextInputType.number, "prefixIcon": Icon(Icons.comment, color: Colors.pinkAccent),
      "labelText": "Instagram Comments", "onChanged": updateContestantBloc.changeInstaComments
    }
  ];

  final List<SortType> _sortTypes = 
  [
    SortType.SORT_BY_TOTALPOINTS_DESC,
    SortType.SORT_BY_TOTALPOINTS_ASC,
    SortType.SORT_BY_CONTNUMBER_DESC,
    SortType.SORT_BY_CONTNUMBER_ASC
  ];

  final List<String> _sortSnackMesgs = 
  [
    "Sort Criteria - Total points (Descending)",
    "Sort Criteria - Total points (Ascending)",
    "Sort Criteria - Contestant Number (Descending)",
    "Sort Criteria - Contestant Number (Ascending)"
  ];

  @override
  void initState() {
    super.initState();
    _sortSelectionIndex = 0;
  }
  @override
  Widget build(BuildContext context){

    SizeConfig.init(context);
    updateContestantBloc.init();
    addContestantBloc.checkSubmitValid();
    updateContestantBloc.checkUpdateValid();
    leaderBoardBloc.setContestants(sortType: _sortTypes.elementAt(_sortSelectionIndex));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Icon(_appBarTitles.elementAt(_selectedIndex)["icon"], color: Colors.white),
        title: Text(_appBarTitles.elementAt(_selectedIndex)["title"])),
      body: Center(
        child: getWidget(_selectedIndex)),
      bottomNavigationBar: _getBottomNavigationBar(),
      floatingActionButton: _selectedIndex==1?
      FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.sort, color: Colors.white),
        onPressed: () => sortSelection()):null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,  
    );
  }
  sortSelection(){
    setState(() => _sortSelectionIndex==3?_sortSelectionIndex=0:++_sortSelectionIndex);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:Text(_sortSnackMesgs[_sortSelectionIndex], style: TextStyle(color: Colors.amber),),
      duration:Duration(seconds: 2)));
  }

  Widget getWidget(int index){
    Widget widget = _getLeaderBoardWidget();
    switch(index){
      case 0:
       widget = _getAddContestantWidget();
       break;
      case 1:
       widget = _getLeaderBoardWidget();
       break;
      case 2:
       widget = _getUpdateContestantWidget();
       break;
    }

    return widget;
  }

  _getBottomNavigationBar() => BottomNavigationBar(
      backgroundColor: Colors.black,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add, color: Colors.white,),
          title: Text('Add', style: TextStyle(color: Colors.white),),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.score, color: Colors.white,),
          title: Text('Leaderboard', style: TextStyle(color: Colors.white),),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit, color: Colors.white,),
          title: Text('Update', style: TextStyle(color: Colors.white),),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
  );

  _onItemTapped(int index) => setState(() => _selectedIndex = index);

  Widget _getAddContestantWidget() => SingleChildScrollView(
    child: Card(
      color: Colors.white,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(width: 1.0, color: Colors.blue)),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0
        ),
        child:Column(
        children: <Widget>
        [
          _contestantNumberField(),
          SizedBox(height: 5.0,),
          _contestantNameField(),
          SizedBox(height: 5.0,),
          _fbLikesField(),
          SizedBox(height: 5.0,),
          _fbCommentsField(),
          SizedBox(height: 5.0,),
          _fbSharesField(),
          SizedBox(height: 5.0,),
          _instaLikesField(),
          SizedBox(height: 5.0,),
          _instaCommentsField(),
          SizedBox(height: 30.0,),
          submitButton(),
        ])))
  );

  _contestantNumberField() => StreamBuilder<String>(
    stream: addContestantBloc.contNumber,
    builder: (context, snapshot) => TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.perm_identity, color: Colors.redAccent),
        labelText: "Contestant Number",
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
        errorText: snapshot.error,
        errorStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.redAccent),
        ),
      onChanged: addContestantBloc.changeContNumber,
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },)
  );

  _contestantNameField() => StreamBuilder<String>(
    stream: addContestantBloc.contName,
    builder: (context, snapshot) => TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person, color: Colors.greenAccent),
        labelText: "Contestant Name",
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
        errorText: snapshot.error,
        errorStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.redAccent),
        ),
      onChanged: addContestantBloc.chnageContName,
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },)
  );

  _fbLikesField() => StreamBuilder<String>(
    stream: addContestantBloc.fbLikes,
    builder: (context, snapshot) => TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.thumb_up, color: Colors.blueAccent),
        labelText: "Facebook Likes",
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
        errorText: snapshot.error,
        errorStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.redAccent),
        ),
      onChanged: addContestantBloc.changeFBLikes,
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },)
  );

  _fbCommentsField() => StreamBuilder<String>(
    stream: addContestantBloc.fbComments,
    builder: (context, snapshot) => TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.comment, color: Colors.blueAccent),
        labelText: "Facebook Comments",
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
        errorText: snapshot.error,
        errorStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.redAccent),
        ),
      onChanged: addContestantBloc.changeFBComments,
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },)
  );

  _fbSharesField() => StreamBuilder<String>(
    stream: addContestantBloc.fbShares,
    builder: (context, snapshot) => TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.share, color: Colors.blueAccent),
        labelText: "Facebook Shares",
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
        errorText: snapshot.error,
        errorStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.redAccent),
        ),
      onChanged: addContestantBloc.changeFBShares,
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },)
  );

  _instaLikesField() => StreamBuilder<String>(
    stream: addContestantBloc.instaLikes,
    builder: (context, snapshot) => TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.thumb_up, color: Colors.pinkAccent),
        labelText: "Instagram Likes",
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
        errorText: snapshot.error,
        errorStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.redAccent),
        ),
      onChanged: addContestantBloc.changeInstaLikes,
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },)
  );

  _instaCommentsField() => StreamBuilder<String>(
    stream: addContestantBloc.instaComments,
    builder: (context, snapshot) => TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.comment, color: Colors.pinkAccent),
        labelText: "Instagram Comments",
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
        errorText: snapshot.error,
        errorStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.redAccent),
        ),
      onChanged: addContestantBloc.changeInstaComments,
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },)
  );

  submitButton() => StreamBuilder<bool>(
    stream: addContestantBloc.submitValid,
    initialData: false,
    builder: (context,snapshot) => RaisedButton(
      elevation: 2.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
      clipBehavior: Clip.hardEdge,
      color: Colors.green,
      disabledColor: Colors.grey,
      disabledElevation: 0.0,
      child: Text("Add", style: TextStyle(color: Colors.white)),
      onPressed: snapshot.data?()=>submitData():null)
  );

  submitData() async {
    ErrorType errorType = await addContestantBloc.submit();
    errorType == ErrorType.NONE?submitSucess():submitFailed();
  }

  submitSucess(){
    createSnackbar("Contestant Added Successfully", color: Colors.greenAccent);
    Future.delayed(const Duration(milliseconds: 2000), () => setState(() => _selectedIndex = 1));
  }

  submitFailed() => createSnackbar("Contestant already exists!", color: Colors.redAccent); 

  createSnackbar(String message, {int seconds = 2, Color color = Colors.white}) => _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                      content: Text(message, style: TextStyle(color: color)), 
                      duration: Duration(seconds:seconds))
  );

  _getLeaderBoardWidget() => StreamBuilder(
    stream: leaderBoardBloc.contestants,
    builder: (context,snapshot) => snapshot.hasData&&snapshot.data!=null&&snapshot.data.length!=0?
    ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context,index) => _getLeaderBoardTile(snapshot.data[index])):
      Text("No Contestants", style: TextStyle(fontStyle: FontStyle.italic),)
  );

  _getLeaderBoardTile(Contestant contestant) => GestureDetector(
    onDoubleTap: () => setState(() => pinnedContestant=contestant),
    onTap:() => setState(()=>pinnedContestant=null),
    child:Card(
    color: Colors.white,
    elevation: 1.0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: pinnedContestant==null||pinnedContestant.contNumber!=contestant.contNumber?
        BorderSide(width: 0.5, color: Colors.black54):
        BorderSide(width: 2.5, color: Colors.greenAccent)),
    clipBehavior: Clip.hardEdge,
    margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0),
    child:Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0
      ),
      child:Row(children: <Widget>
    [
      Container(
        width: 35.0,
        child:Center(child:Text(contestant.contNumber.toString(), 
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),))),
      SizedBox(width: 8),
      Container(width: 0.5, height: 120.0, color: Colors.black45),
      SizedBox(width: 8),
      _contestantInfo(contestant),
      SizedBox(width: 5),
      Container(width: 0.5, height: 120.0, color: Colors.black45),
      SizedBox(width: 5),
      Center(child:IconButton(
        padding: EdgeInsets.all(0.0),
        icon: Icon(Icons.delete_forever, color: Colors.blue, size: 30.0),
        onPressed: (){
          leaderBoardBloc.deleteContestant(contestant);
          leaderBoardBloc.setContestants();
        }))
    ]),))
  );

  _contestantInfo(Contestant contestant) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>
    [
      
      pinnedContestant!=null&&pinnedContestant.contNumber==contestant.contNumber?
      Row(children: <Widget>[Icon(Icons.check_circle, color: Colors.green, size: 20.0,),SizedBox(width: 5.0),
      Text(contestant.contName, style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black))]):
      pinnedContestant==null?
      Text(contestant.contName, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)):
      Row(children: <Widget>[Text(contestant.contName, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      SizedBox(width: 5.0),
      Text("("+(contestant.totalPoints - pinnedContestant.totalPoints).toString()+")", style: TextStyle(fontSize: 18.0, 
      fontWeight: FontWeight.bold, color: Colors.indigo))]),
      SizedBox(height: 5.0),
      Container(width: 250.0, height: 0.5, color: Colors.black45),
      SizedBox(height: 5.0),
      Row(children: <Widget>[Icon(Icons.score, color: Colors.purple, size: 15.0,),SizedBox(width: 5.0),
      Text(contestant.totalPoints.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))]),
      SizedBox(height: 5.0),
      Container(width: 250.0, height: 0.5, color: Colors.black45),
      SizedBox(height: 5.0),
      Row(children: <Widget>[Icon(Icons.thumb_up, color: Colors.blueAccent, size: 15.0,),SizedBox(width: 5.0),Text(contestant.fbLikes.toString()),
      SizedBox(width: 5.0), Icon(Icons.comment, color: Colors.blueAccent, size: 15.0,),SizedBox(width: 5.0),
      Text(contestant.fbComments.toString()), Text(" => "+contestant.adjFbComments.toString()),SizedBox(width: 5.0),
      Icon(Icons.share, color: Colors.blueAccent, size: 15.0),SizedBox(width: 5.0),
      Text(contestant.fbShares.toString()), Text(" => "+contestant.adjFbShares.toString())],),
      Row(children: <Widget>[Icon(Icons.thumb_up, color: Colors.pinkAccent, size: 15.0,),SizedBox(width: 5.0),Text(contestant.instaLikes.toString()),
      SizedBox(width: 5.0),Icon(Icons.comment, color: Colors.pinkAccent, size: 15.0),SizedBox(width: 5.0),
      Text(contestant.instaComments.toString()), Text(" => "+contestant.adjInstComments.toString())],),
      SizedBox(height: 5.0),
      Container(width: 250.0, height: 0.5, color: Colors.black45),
      SizedBox(height: 5.0),
      Row(children: <Widget>[Icon(Icons.timer, color: Colors.green, size: 15.0,),SizedBox(width: 5.0),
      Text(contestant.lastUpdated, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))]),
    ]
  );

  _getUpdateContestantWidget() => SingleChildScrollView(
    child: Card(
      color: Colors.white,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(width: 1.0, color: Colors.blue)),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0
        ),
        child:Column(
        children: <Widget>
        [
          _contestantNumberDDMenu(),
          _contestantDetails()
        ])))
  );

  _contestantNumberDDMenu() => StreamBuilder<List<DropdownMenuItem<String>>>(
    stream: updateContestantBloc.contNumberDDMenu,
    initialData: [],
    builder: (context, snapshot){
      updateContestantBloc.setContNumberDDMenu();
      return DropdownButtonFormField(
      hint:Text("Select Contestant Number"),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.perm_identity)),
      value:updateContestantBloc.getContNumberSelectedValue(),
      items:snapshot.data, 
      onChanged: (value){
        print(value);
        updateContestantBloc.setContNumberSelected(value);
        updateContestantBloc.setContestant(value);
        },
      onSaved: (value){
        updateContestantBloc.setContNumberSelected(value);
        updateContestantBloc.setContestant(value);
        }
      );
    }
  );
  
  _contestantDetails() => StreamBuilder<Contestant>(
    stream: updateContestantBloc.contestant,
    initialData: null,
    builder:(context, snapshot) => snapshot.data!=null?
    Column(children: <Widget>
    [
       SizedBox(height: 5.0),
       _contestantNameText(snapshot.data),
       SizedBox(height: 5.0),
       _fbLikesText(snapshot.data),
       SizedBox(height: 5.0),
       _fbCommentsText(snapshot.data),
       SizedBox(height: 5.0),
       _fbSharesText(snapshot.data),
       SizedBox(height: 5.0),
       _instaLikesText(snapshot.data),
       SizedBox(height: 5.0),
       _instaCommentsText(snapshot.data),
       SizedBox(height: 30.0),
       _updateButton()
    ]):SizedBox(),
  );

  _contestantNameText(contestant) => ListTile(
      leading: Icon(Icons.person, color: Colors.greenAccent),
      title: Text(contestant==null?"Contestant Name":contestant.contName),
      trailing: IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: () => getEditPopup(_fieldProperties[0]))
  );

  _fbLikesText(Contestant contestant) =>ListTile(
      leading: Icon(Icons.thumb_up, color: Colors.blueAccent),
      title: Text(contestant==null?"Facebook Likes":contestant.fbLikes.toString()),
      trailing:IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: ()=> getEditPopup(_fieldProperties[1]))
  );

    _fbCommentsText(Contestant contestant) => ListTile(
      leading: Icon(Icons.comment, color: Colors.blueAccent),
      title: Text(contestant==null?"Facebook Comments":contestant.fbComments.toString()),
      trailing:IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: ()=> getEditPopup(_fieldProperties[2]))
  );

    _fbSharesText(Contestant contestant) => ListTile(
      leading: Icon(Icons.share, color: Colors.blueAccent),
      title: Text(contestant==null?"Facebook Shares":contestant.fbShares.toString()),
      trailing:IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: ()=> getEditPopup(_fieldProperties[3]))
  );

    _instaLikesText(Contestant contestant) => ListTile(
      leading: Icon(Icons.thumb_up, color: Colors.pinkAccent),
      title: Text(contestant==null?"Instagram Likes":contestant.instaLikes.toString()),
      trailing:IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: ()=> getEditPopup(_fieldProperties[4]))
  );

    _instaCommentsText(Contestant contestant) => ListTile(
      leading: Icon(Icons.comment, color: Colors.pinkAccent),
      title: Text(contestant==null?"Instagram Comments":contestant.instaComments.toString()),
      trailing:IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: ()=> getEditPopup(_fieldProperties[5]))
  );

  getEditPopup(dynamic property) => showDialog(
    context: context,
    barrierDismissible: true,
    child: AlertDialog(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 30.0
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
      content: editTextField(property)
      )
  );

  editTextField(dynamic property) => TextField(
      keyboardType: property["keyboardType"],
      decoration: InputDecoration(
        prefixIcon: property["prefixIcon"],
        labelText: property["labelText"],
        labelStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
        ),
      onChanged: property["onChanged"],
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
  );

   _updateButton() => StreamBuilder<bool>(
    stream: updateContestantBloc.updateValid,
    initialData: false,
    builder: (context,snapshot) => RaisedButton(
      elevation: 2.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)),
      clipBehavior: Clip.hardEdge,
      color: Colors.green,
      disabledColor: Colors.grey,
      disabledElevation: 0.0,
      child: Text("Update", style: TextStyle(color: Colors.white)),
      onPressed: snapshot.data?()=> _update():null)
  );

  _update(){
    updateContestantBloc.update();
  }

}
