// System Packages
import 'dart:async';

class Validators {
  final validateContNumber =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (contNumber, sink) {
    if (contNumber.length == 0 || contNumber == null){
      sink.addError("Contestant Number cannot be blank!");
    }else{
      sink.add(contNumber);
    }
  });

  final validateContName = StreamTransformer<String, String>.fromHandlers(
      handleData: (contName, sink) {
    if (contName.length == 0 || contName == null) {
      sink.addError("Contestant Name cannot be blank!");
    }else{
      sink.add(contName);
    }
  });

  final validateFBLikes =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (fbLikes, sink) {
    if (fbLikes.length == 0 || fbLikes == null){
      sink.addError("Facebook Likes cannot be blank!");
    }else{
      sink.add(fbLikes);
    }
  });

  final validateFBComments =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (fbComments, sink) {
    if (fbComments.length == 0 || fbComments == null){
      sink.addError("Facebook Comments cannot be blank!");
    }else{
      sink.add(fbComments);
    }
  });

  final validateFBShares =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (fbShares, sink) {
    if (fbShares.length == 0 || fbShares == null){
      sink.addError("Facebook Shares cannot be blank!");
    }else{
      sink.add(fbShares);
    }
  });

  final validateInstaLikes =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (instaLikes, sink) {
    if (instaLikes.length == 0 || instaLikes == null){
      sink.addError("Instagram Likes cannot be blank!");
    }else{
      sink.add(instaLikes);
    }
  });

  final validateInstaComments =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (instaComments, sink) {
    if (instaComments.length == 0 || instaComments == null){
      sink.addError("Instagram Comments cannot be blank!");
    }else{
      sink.add(instaComments);
    }
  });

  final validateContNumberSelected = StreamTransformer<String, String>.fromHandlers(
      handleData: (contNumberSelected, sink) {
    if (contNumberSelected.length != 0 || contNumberSelected != null) {
      sink.add(contNumberSelected);
    }
  });
}