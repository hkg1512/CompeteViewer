//System Packages
import 'package:intl/intl.dart';
//Resources
import 'package:compete_viewer/models/contestant_model.dart';
import 'package:compete_viewer/resources/database_provider.dart';

enum ErrorType{ NONE, CONTESTANT_EXIST}

class Repository{
  Future<ErrorType> addContestant({int contId, String contName, int fbLikes, int fbComments, 
                                   int fbShares, int instaLikes, int instaComments}) async {
    bool contestantExist = await DBProvider.db.contestantExist(contNumber: contId, contName: contName);
    if(contestantExist){
      return ErrorType.CONTESTANT_EXIST;
    }else{
      Contestant newContestant = Contestant.create(contNumber:contId, contName:contName,
                                fbLikes:fbLikes, fbComments:fbComments, fbShares:fbShares,
                                instaLikes:instaLikes, instaComments:instaComments, 
                                lastUpdated: DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now()));
      DBProvider.db.newContestant(newContestant);
    }

    return ErrorType.NONE;
  }

  Future<List<Contestant>> getAllContestants() async => await DBProvider.db.getAllContestants();
  updateContestant(Contestant contestant) async => DBProvider.db.updateContestants([contestant]);
  deleteContestant(Contestant contestant) => DBProvider.db.deleteContestants([contestant]);
}