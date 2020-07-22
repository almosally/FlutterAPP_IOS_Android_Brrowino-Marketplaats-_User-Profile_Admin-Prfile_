class SearchOffer {
  final String title;
  final String description;


  SearchOffer(this.title, this.description);

  static List<SearchOffer> mapJSONStringToList(List<dynamic> jsonList) {
    return jsonList
        .map((r) => SearchOffer(r['title'], r['description']))
        .toList();
  }
}