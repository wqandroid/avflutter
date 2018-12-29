class Link{
  String link;
  Link(this.link);

}



//演员信息
class Actress extends Link{

   String name;
   String imageUrl;

   String link;

   Actress(this.name, this.imageUrl, this.link) : super(link);


}

class Screenshot{
   String thumbnailUrl;
   String link;
   Screenshot(this.thumbnailUrl, this.link);
}

//暂无分类信息
class Genre{
  String name;
  String link;
  Genre(this.name, this.link);

}

class Header{
   String name;
   String value;
   String link ;

   Header(this.name, this.value, this.link);

}


class MoveDetailInfo{
   final List<Screenshot> screenshots =[];
   String title;
   String coverUrl;
   List<Header> headers = [];
   List<Genre> genres =[];
   List<Actress> actresses=[];
}

class AVinfo{



  String videoId;
  String previewUrl;
  String PlayUrl;
  AVinfo.name(this.videoId, this.previewUrl, this.PlayUrl);
  AVinfo();
}