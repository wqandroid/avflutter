class Move {
  String title;
  String code;
  String coverUrl;
  String date;
  bool hot;
  String link;

  Move(this.title, this.code, this.date, this.coverUrl, this.link, this.hot);

//   public static Movie create(String title, String code, String date, String coverUrl, String detailUrl, boolean hot) {

  String buildStr() {
    return "$title$code$coverUrl";
  }


}


