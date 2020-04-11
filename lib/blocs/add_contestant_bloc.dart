//System Packages
import 'package:rxdart/rxdart.dart';
//Resources
import 'package:compete_viewer/resources/repository.dart';
//Utilities
import 'package:compete_viewer/utilities/validators.dart';

class AddContestantBloc extends Validators{
  final Repository _repository = Repository();
  final BehaviorSubject _contNumberController = BehaviorSubject<String>();
  final BehaviorSubject _contNameController = BehaviorSubject<String>();
  final BehaviorSubject _fbLikesController = BehaviorSubject<String>();
  final BehaviorSubject _fbCommentsController = BehaviorSubject<String>();
  final BehaviorSubject _fbSharesController = BehaviorSubject<String>();
  final BehaviorSubject _instaLikesController = BehaviorSubject<String>();
  final BehaviorSubject _instaCommentsController = BehaviorSubject<String>();
  final PublishSubject _isSubmitValid = PublishSubject<bool>();

  void dispose(){
    _contNumberController.close();
    _contNameController.close();
    _fbLikesController.close();
    _fbCommentsController.close();
    _fbSharesController.close();
    _instaLikesController.close();
    _instaCommentsController.close();
    _isSubmitValid.close();
  }

  Stream<String> get contNumber => _contNumberController.stream.transform(validateContNumber);
  Stream<String> get contName => _contNameController.stream.transform(validateContName);
  Stream<String> get fbLikes => _fbLikesController.stream.transform(validateFBLikes);
  Stream<String> get fbComments => _fbCommentsController.stream.transform(validateFBComments);
  Stream<String> get fbShares => _fbSharesController.stream.transform(validateFBShares);
  Stream<String> get instaLikes => _instaLikesController.stream.transform(validateInstaLikes);
  Stream<String> get instaComments => _instaCommentsController.stream.transform(validateInstaComments);
  Stream<bool> get submitValid => _isSubmitValid.stream;

  Function(String) get changeContNumber => _contNumberController.sink.add;
  Function(String) get chnageContName => _contNameController.sink.add;
  Function(String) get changeFBLikes => _fbLikesController.sink.add;
  Function(String) get changeFBComments => _fbCommentsController.sink.add;
  Function(String) get changeFBShares => _fbSharesController.sink.add;
  Function(String) get changeInstaLikes => _instaLikesController.sink.add;
  Function(String) get changeInstaComments => _instaCommentsController.sink.add;

  checkSubmitValid() => _contNumberController.value!=null&&_contNumberController.value!=""&& _contNameController.value!=null&&
                        _contNameController.value!=""&& _fbLikesController.value!=null&&_fbLikesController.value!=""&&
                        _fbCommentsController.value!=null&&_fbCommentsController.value!=""&&_fbSharesController.value!=null&&
                        _fbSharesController.value!=""&&_instaLikesController.value!=null&&_instaLikesController.value!=""&&
                        _instaCommentsController!=null&&_instaCommentsController.value!=""?
                        _isSubmitValid.sink.add(true):_isSubmitValid.sink.add(false);
  
  Future<ErrorType> submit() async {
    final int validId = int.parse(_contNumberController.value);
    final String validName = _contNameController.value;
    final int validFBLikes = int.parse(_fbLikesController.value);
    final int validFBComments = int.parse(_fbCommentsController.value);
    final int validFBShares = int.parse(_fbSharesController.value);
    final int validInstaLikes = int.parse(_instaLikesController.value);
    final int validInstaComments = int.parse(_instaCommentsController.value);

    ErrorType errorType = await _repository.addContestant(contId:validId, contName: validName, fbLikes: validFBLikes, fbComments: validFBComments,
                              fbShares: validFBShares, instaLikes: validInstaLikes, instaComments: validInstaComments);
    return errorType;
  }


}

final AddContestantBloc addContestantBloc = AddContestantBloc();