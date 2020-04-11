class Contestant{
  int contNumber;
  String contName;
  int fbLikes;
  int fbComments;
  int fbShares;
  int instaLikes;
  int instaComments;
  int adjFbComments;
  int adjFbShares;
  int adjInstComments;
  int totalPoints;
  String lastUpdated;

  Contestant(this.contNumber, this.contName, this.fbLikes, this.fbComments, 
             this.fbShares, this.instaLikes, this.instaComments, this.adjFbComments, this.adjFbShares, this.adjInstComments,
             this.totalPoints, this.lastUpdated);

  Contestant.create({this.contNumber, this.contName,this.fbLikes,this.fbComments,this.fbShares,this.instaLikes,this.instaComments,this.lastUpdated}){
    this.adjFbComments = this.fbComments <= this.fbLikes?this.fbComments:this.fbLikes;
    this.adjFbShares = this.fbShares <= this.fbLikes?this.fbShares:this.fbLikes;
    this.adjInstComments = this.instaComments <= this.instaLikes?this.instaComments:this.instaLikes;
    this.totalPoints = (this.fbLikes+this.instaLikes)+(2*(this.adjFbComments+this.adjInstComments))+
                       (3*this.adjFbShares);
  }

  Map<String, dynamic> toMap() => {
        "contnumber": this.contNumber,
        "contname": this.contName,
        "fblikes": this.fbLikes,
        "fbcomments": this.fbComments,
        "fbshares": this.fbShares,
        "instalikes": this.instaLikes,
        "instacomments": this.instaComments,
        "adjfbcomments": this.adjFbComments,
        "adjfbshares": this.adjFbShares,
        "adjinstacomments": this.adjInstComments,
        "totalpoints": this.totalPoints,
        "lastupdated": this.lastUpdated
  };
  
  factory Contestant.fromMap(Map<String, dynamic> data) => new Contestant(
      data["contnumber"],
      data["contname"],
      data["fblikes"],
      data["fbcomments"],
      data["fbshares"],
      data["instalikes"],
      data["instacomments"],
      data["adjfbcomments"],
      data["adjfbshares"],
      data["adjinstacomments"],
      data["totalpoints"],
      data["lastupdated"],
  );
}