class SocialsModel {
  final String name;
  final String history;
  final String iconUrl;
  final String imgUrl;
  final String webUrl;

  SocialsModel({
    required this.name,
    required this.history,
    required this.iconUrl,
    required this.imgUrl,
    required this.webUrl,
  });

 
  factory SocialsModel.fromJson(Map<String, dynamic> json) {
    return SocialsModel(
      name: json['name'] ?? '', 
      history: json['history'] ?? 'No history available', 
      iconUrl: json['iconUrl'] ?? '', 
      imgUrl: json['imgUrl'] ?? '', 
      webUrl: json['webUrl'] ?? '', 
    );
  }

}
