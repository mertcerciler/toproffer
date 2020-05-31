class APIPath {

  static String user_type(String uid) => 
    'users/$uid/user_type';
    
  static String customer_details(String uid) => 
    'users/$uid/user_type/customers/customer_details/$uid';

  static String get_customer_details(String uid) => 
    'users/$uid/user_type/customers/customer_details';

  static String used_campaigns(String uid) =>
    'users/$uid/user_type/customers/used_campaigns';

  static String token(String uid) =>
    'users/$uid/tokens/$uid'; 

  static String following_restaurants(String uid) => 
    'users/$uid/user_type/customers/following_restaurants/$uid';

  static String restaurant_followers(String uid) => 
    'users/$uid/user_type/restaurants/restaurant_followers/$uid';

  static String restaurant_details(String uid) => 
    'users/$uid/user_type/restaurants/restaurant_details/$uid';

  static String get_restaurant_details(String uid) => 
    'users/$uid/user_type/restaurants/restaurant_details';

  static String all_restaurants(String rid) => 
    'all_restaurants/$rid';

  static String get_all_restaurants() =>
    'all_restaurants/';

  static String active_campaigns(String uid) => 
    'users/$uid/user_type/restaurants/active_campaigns/';
  
  static String delete_active_campaigns(String uid, String cid) => 
    'users/$uid/user_type/restaurants/active_campaigns/$cid';
  
  static String campaign_details_active(String uid, String cid) => 
    'users/$uid/user_type/restaurants/active_campaigns/$cid';

  static String old_campaigns(String uid, String cid) => 
    'users/$uid/user_type/restaurants/old_campaigns/$cid';

  static String get_old_campaigns(String uid) => 
    'users/$uid/user_type/restaurants/old_campaigns/';

  static String total_used_campaigns(int day, String category, String hour) =>
    'total_used_campaigns/$day/$category/$hour';

  static String get_total_used_campaigns(int day, String category, String hour) =>
    'total_used_campaigns/$day/$category/$hour';

  static String get_total_used_campaigns_2(int day, String category) =>
    'total_used_campaigns/$day/$category';

  static String total_active_campaigns(String cid) => 
    'total_active_campaigns/$cid';

  static String get_total_active_campaigns() => 
    'total_active_campaigns/';
}