
import 'dart:convert' show json;

class Move {
  String title;
  String code;
  String coverUrl;
  String date;
  bool hot;
  String link;

  Move(this.title, this.code, this.date, this.coverUrl, this.link, this.hot);

//    static Movie create(String title, String code, String date, String coverUrl, String detailUrl, boolean hot) {

  String buildStr() {
    return "$title$code$coverUrl";
  }
}

class AvgleSearchResult {
  bool success;
  Response response;
}

class Response {
  bool has_more;
  int total_videos;
  int current_offset;
  int limit;
  List<Video> videos;
}

class Video {
  String title;
  String keyword;
  String channel;
  double duration;
  double framerate;
  bool hd;
  int addtime;
  int viewnumber;
  int likes;
  int dislikes;
  String video_url;
  String embedded_url;
  String preview_url;
  String preview_video_url;
  bool isPublic;
  String vid;
  String uid;
}
