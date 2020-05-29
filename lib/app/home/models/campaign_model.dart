class CampaignModel { 
  CampaignModel({
    this.id,
    this.title,
    this.content, 
    this.oldPrice,
    this.campaignCategory1,
    this.campaignCategory2, 
    this.campaignType,
    this.newPrice,
    this.releaseDate, 
    this.startingHour,
    this.restaurantAddress,
    this.endingHour,
    this.campaignStarted,
    this.campaignFinished,
    this.code,
  });
  final String id;
  final String title;
  final String content;
  final double oldPrice;
  final String campaignCategory1;
  final String campaignCategory2;
  final String campaignType;
  final double newPrice;
  final double startingHour;
  final double endingHour;
  final String restaurantAddress;
  final DateTime campaignFinished;
  final DateTime campaignStarted;
  final DateTime releaseDate;
  String code;

  
  factory CampaignModel.fromMap(Map<String, dynamic> data, String campaignId) {
    if (data == null){
      return null;
    }
    if (data['campaign_type'] == "Momentarily"){
      final String id = data['id'];
      final String title = data['title'];
      final String content = data['content'];
      final String campaignType =  data['campaign_type'];
      final double newPrice =  data['newPrice'];
      final double oldPrice  = data['oldPrice'];
      final String restaurantAddress = data['restaurantAddress'];
      final DateTime campaignStarted = data['campaign_started'];
      final DateTime campaignFinished = data['campaign_finished'];
      final String campaignCategory1 = data['campaign_category_1'];
      final String campaignCategory2 = data['campaign_category_2'];
      final String code = data['code'];
      return CampaignModel(
        id: id,
        title: title,
        content: content,
        campaignType: 'Momentarily',
        newPrice: newPrice,
        restaurantAddress: restaurantAddress,
        oldPrice:  oldPrice,
        campaignStarted: campaignStarted,
        campaignFinished: campaignFinished,
        campaignCategory1: campaignCategory1,
        campaignCategory2: campaignCategory2,
        code: code,
      );
    }
    else {
      final String id = data['id'];
      final String title = data['title'];
      final String content = data['content'];
      final String campaignType =  data['campaign_type'];
      final double newPrice =  data['newPrice'];
      final double oldPrice  = data['oldPrice'];
      final DateTime startingHour = data['starting_hour'];
      final String restaurantAddress = data['restaurantAddress'];
      final DateTime endingHour = data['ending_hour'];
      final DateTime releaseDate = data['releaseDate'];
      final String campaignCategory1 = data['campaign_category_1'];
      final String campaignCategory2 = data['campaign_category_2'];
      final String code = data['code'];
      return CampaignModel(
        id: id,
        title: title,
        content: content,
        campaignType: 'Permanent',
        newPrice: newPrice,
        oldPrice:  oldPrice,
        releaseDate: releaseDate,
        restaurantAddress: restaurantAddress,
        campaignStarted: startingHour,
        campaignFinished: endingHour,
        campaignCategory1: campaignCategory1,
        campaignCategory2: campaignCategory2,
        code: code,
      );
    }
  }

  Map<String, dynamic> toMap() {
    if (campaignType == "Permanent"){ 
      return {
        'id': id,
        'title': title,
        'content': content,
        'campaign_type': 'Permenant',
        'campaign_category_1': campaignCategory1,
        'campaign_category_2': campaignCategory2,
        'restaurant_address': restaurantAddress,
        'oldPrice': oldPrice,
        'newPrice': newPrice,
        'releaseTime': DateTime.now(),
        'starting_hour': startingHour,
        'ending_hour': endingHour,
        'code': code,
      };
    }
    else {
      return {
        'id': id,
        'title': title,
        'content': content,
        'campaign_type': 'Momentarily',
        'campaign_category_1': campaignCategory1,
        'campaign_category_2': campaignCategory2,
        'restaurant_address': restaurantAddress,
        'oldPrice': oldPrice,
        'newPrice': newPrice,
        'campaign_started' : campaignStarted,
        'campaign_finished' : campaignFinished,
        'code': code,
      };
    }
  }

  CampaignModel copyWith({
    String id,
    String title,
    String content,
    double oldPrice,
    String campaignCategory1,
    String campaignCategory2,
    String campaignType,
    double newPrice,
    double startingHour,
    double endingHour,
    String restaurantAddress,
    DateTime campaignStarted,
    DateTime campaignFinished,
    String code,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      oldPrice: oldPrice ?? this.oldPrice,
      newPrice: newPrice ?? this.newPrice,
      campaignCategory1: campaignCategory1 ?? this.campaignCategory1,
      campaignCategory2: campaignCategory2 ?? this.campaignCategory2,
      campaignType: campaignType ?? this.campaignType,
      startingHour: startingHour ?? this.startingHour,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      endingHour: endingHour ?? this.endingHour,
      campaignStarted: campaignStarted ?? this.campaignStarted,
      campaignFinished: campaignFinished ?? this.campaignFinished,
      code: code ?? this.code,
    ); 
  }
}