class ImageData {
  ImageData({
    this.playerImages = const [],
    this.teamImages = const [],
  });

  final List<PlayerImage> playerImages;
  final List<TeamImage> teamImages;

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        playerImages: json["playerImages"] != null
            ? List<PlayerImage>.from(
                json["playerImages"].map((x) => PlayerImage.fromJson(x)))
            : [],
        teamImages: json["teamImages"] != null
            ? List<TeamImage>.from(
                json["teamImages"].map((x) => TeamImage.fromJson(x)))
            : [],
      );
}

class PlayerImage {
  PlayerImage({
    this.playerKey = '',
    this.teamKey = '',
    this.image = '',
    this.fullName = '',
  });

  final String playerKey;
  final String teamKey;
  final String image;
  final String fullName;

  factory PlayerImage.fromJson(Map<String, dynamic> json) => PlayerImage(
        playerKey: json["playerKey"] ?? '',
        teamKey: json["teamKey"] ?? '',
        image: json["image"] ?? '',
        fullName: json["fullName"] ?? '',
      );
}

class TeamImage {
  TeamImage({
    this.teamKey = '',
    this.teamName = '',
    this.image = '',
    this.teamColor = '',
  });

  final String teamKey;
  final String teamName;
  final String image;
  final String teamColor;

  factory TeamImage.fromJson(Map<String, dynamic> json) => TeamImage(
        teamKey: json["teamKey"] ?? '',
        teamName: json["teamName"] ?? '',
        image: json["image"] ?? '',
        teamColor: json["teamColor"] ?? '',
      );
}
