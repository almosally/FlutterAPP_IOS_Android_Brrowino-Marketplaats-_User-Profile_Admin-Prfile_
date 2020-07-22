class SearchUser {
  final String name;


  SearchUser(this.name);

  static List<SearchUser> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList
        .map((r) => SearchUser(r['name']))
        .toList();
  }
}