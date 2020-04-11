//System Packages
import 'package:rxdart/rxdart.dart';
//Resources
import 'package:compete_viewer/resources/repository.dart';
//Models
import 'package:compete_viewer/models/contestant_model.dart';
//Utilities
import 'package:compete_viewer/utilities/validators.dart';

enum SortType{ SORT_BY_CONTNUMBER_DESC, SORT_BY_CONTNUMBER_ASC, SORT_BY_TOTALPOINTS_DESC, SORT_BY_TOTALPOINTS_ASC}

class LeaderBoardBloc{
  final Repository _repository = Repository();
  final PublishSubject _contestantsList = PublishSubject<List<Contestant>>();

  void dispose(){
    _contestantsList.close();
  }

  Stream<List<Contestant>> get contestants => _contestantsList.stream;

  void setContestants({SortType sortType = SortType.SORT_BY_TOTALPOINTS_DESC}) async {
    final List<Contestant> list = await _repository.getAllContestants();
    if(sortType == SortType.SORT_BY_CONTNUMBER_ASC){
      list.sort((contestant1,contestant2) => contestant1.contNumber.compareTo(contestant2.contNumber));
    }else if(sortType == SortType.SORT_BY_CONTNUMBER_DESC){
      list.sort((contestant1,contestant2) => contestant2.contNumber.compareTo(contestant1.contNumber));
    }else if(sortType == SortType.SORT_BY_TOTALPOINTS_ASC){
            list.sort((contestant1,contestant2) => contestant1.totalPoints.compareTo(contestant2.totalPoints));
    }else if(sortType == SortType.SORT_BY_TOTALPOINTS_DESC){
      list.sort((contestant1,contestant2) => contestant2.totalPoints.compareTo(contestant1.totalPoints));
    }
    _contestantsList.sink.add(list);
  }

  void deleteContestant(Contestant contestant) => _repository.deleteContestant(contestant);
}

final LeaderBoardBloc leaderBoardBloc = LeaderBoardBloc();