//System Packages
import 'package:compete_viewer/models/contestant_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
//Resources
import 'package:compete_viewer/resources/repository.dart';
//Utilities
import 'package:compete_viewer/utilities/validators.dart';

class UpdateContestantBloc extends Validators{
  final Repository _repository = Repository();
  final BehaviorSubject _contNumberSelected = BehaviorSubject<String>();
  final BehaviorSubject _contNameController = BehaviorSubject<String>();
  final BehaviorSubject _fbLikesController = BehaviorSubject<String>();
  final BehaviorSubject _fbCommentsController = BehaviorSubject<String>();
  final BehaviorSubject _fbSharesController = BehaviorSubject<String>();
  final BehaviorSubject _instaLikesController = BehaviorSubject<String>();
  final BehaviorSubject _instaCommentsController = BehaviorSubject<String>();
  final PublishSubject _contNumberDDMenu = PublishSubject<List<DropdownMenuItem<String>>>();
  final PublishSubject _contestant = PublishSubject<Contestant>();
  final PublishSubject _isUpdateValid = PublishSubject<bool>();
  List<Contestant> _contestantList = List();

  init() async => _contestantList = await _repository.getAllContestants();

  void dispose(){
    _contNumberSelected.close();
    _contNameController.close();
    _fbLikesController.close();
    _fbCommentsController.close();
    _fbSharesController.close();
    _instaLikesController.close();
    _instaCommentsController.close();
    _contNumberDDMenu.close();
    _contestant.close();
    _isUpdateValid.close();
    _contestantList.clear();
  }

  Stream<List<DropdownMenuItem<String>>> get contNumberDDMenu => _contNumberDDMenu.stream;
  Stream<String> get contName => _contNameController.stream.transform(validateContName);
  Stream<String> get fbLikes => _fbLikesController.stream.transform(validateFBLikes);
  Stream<String> get fbComments => _fbCommentsController.stream.transform(validateFBComments);
  Stream<String> get fbShares => _fbSharesController.stream.transform(validateFBShares);
  Stream<String> get instaLikes => _instaLikesController.stream.transform(validateInstaLikes);
  Stream<String> get instaComments => _instaCommentsController.stream.transform(validateInstaComments);
  Stream<Contestant> get contestant => _contestant.stream;
  Stream<String> get contNumberSelected => _contNumberSelected.stream.transform(validateContNumberSelected);
  Stream<bool> get updateValid => _isUpdateValid.stream;

  Function(String) get changeContName => _contNameController.sink.add;
  Function(String) get changeFBLikes => _fbLikesController.sink.add;
  Function(String) get changeFBComments => _fbCommentsController.sink.add;
  Function(String) get changeFBShares => _fbSharesController.sink.add;
  Function(String) get changeInstaLikes => _instaLikesController.sink.add;
  Function(String) get changeInstaComments => _instaCommentsController.sink.add;

  String getContNumberSelectedValue() => _contNumberSelected.value;

  void setContNumberSelected(String value) => _contNumberSelected.sink.add(value);

  void setContestant(String contNumber){
    _contestantList.forEach((contestant){
      if(contestant.contNumber == int.parse(contNumber)){
        _contestant.sink.add(contestant);
      }
    }); 
  }
  void setContNumberDDMenu(){
    List<DropdownMenuItem<String>> contNumberList = List();
    if(_contestantList.length!=0){
      _contestantList.forEach((contestant) => contNumberList.add(DropdownMenuItem(
                                                                     value: contestant.contNumber.toString(),
                                                                     child:Text(contestant.contNumber.toString()))));
    }
    _contNumberDDMenu.sink.add(contNumberList); 
  } 

  checkUpdateValid() => (_contNameController.value!=null&&
                        _contNameController.value!="")||(_fbLikesController.value!=null&&_fbLikesController.value!="")||
                        (_fbCommentsController.value!=null&&_fbCommentsController.value!="")||(_fbSharesController.value!=null&&
                        _fbSharesController.value!="")||(_instaLikesController.value!=null&&_instaLikesController.value!="")||
                        (_instaCommentsController!=null&&_instaCommentsController.value!="")?
                        _isUpdateValid.sink.add(true):_isUpdateValid.sink.add(false);  
  
  void update() async {
    final int validId = int.parse(_contNumberSelected.value);
    _contestantList.forEach((contestant) async {
      if(contestant.contNumber == validId){
        final String validName = _contNameController.value==null||_contNameController.value==""?
        contestant.contName:_contNameController.value;
        final int validFBLikes = _fbLikesController.value==null||_fbLikesController.value==""?
        contestant.fbLikes:int.parse(_fbLikesController.value);
        final int validFBComments = _fbCommentsController.value==null||_fbCommentsController.value==""?
        contestant.fbComments:int.parse(_fbCommentsController.value);
        final int validFBShares = _fbSharesController.value==null||_fbSharesController.value==""?
        contestant.fbShares:int.parse(_fbSharesController.value);
        final int validInstaLikes = _instaLikesController.value==null||_instaLikesController.value==""?
        contestant.instaLikes:int.parse(_instaLikesController.value);
        final int validInstaComments = _instaCommentsController.value==null||_instaCommentsController.value==""?
        contestant.instaComments:int.parse(_instaCommentsController.value);
        print(validId.toString()+"/"+validName+"/"+validFBLikes.toString()+"/"+validFBComments.toString()+"/"+
              validFBShares.toString()+"/"+validInstaLikes.toString()+"/"+validInstaComments.toString());
        Contestant cont = Contestant.create(contNumber:validId, contName:validName, fbLikes:validFBLikes,
                                                       fbComments: validFBComments, fbShares: validFBShares, instaLikes: validInstaLikes,
                                                       instaComments: validInstaComments, 
                                                       lastUpdated: DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now()));
        await _repository.updateContestant(cont);

        await this.init();
        this.setContestant(validId.toString());
        _contNameController.sink.add("");
        _fbLikesController.sink.add("");
        _fbCommentsController.sink.add("");
        _fbSharesController.sink.add("");
        _instaLikesController.sink.add("");
        _instaCommentsController.sink.add("");
        _isUpdateValid.sink.add(false);
      }
    });
  }
}

final UpdateContestantBloc updateContestantBloc = UpdateContestantBloc();