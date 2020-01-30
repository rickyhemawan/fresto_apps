// Doku API Docs for reference
// https://merchant.doku.com/acc/downloads/doc/onecheckoutv2-api/DOKU_OC-1.20-Hosted.pdf

// ------
// Routes
// ------

// Client Route
const kSplashScreenRoute = "/";
const kMainScreenRoute = "/main_screen_route";
const kOrderScreenRoute = "/order_screen_route";
const kMerchantDetailScreenRoute = "/merchant_screen";
const kCreateOrderScreenRoute = '/create_order_screen';
const kLoginScreenRoute = "/login_screen";

// Merchant Route
const kMerchantMainScreenRoute = "/merchant_main_screen_route";
const kMerchantOrderDetailsScreenRoute = "/merchant_order_details_screen_route";
const kMerchantAddSingleMenuScreenRoute =
    "/merchant_add_single_menu_screen_route";
const kMerchantEditSingleMenuScreenRoute =
    "/merchant_edit_single_menu_screen_route";
const kMerchantTrackClientScreenRoute = "/merchant_track_client_screen_route";

// Admin Route
const kAdminMainScreenRoute = "/admin_main_screen_route";
const kAdminAddMerchantScreenRoute = "/admin_add_merchant_screen_route";
const kAdminShowMerchantsScreenRoute = "/admin_show_merchants_screen_route";

// Maps Route
const kMapSearchScreenRoute = "/map_search_screen_route";

//---------------
// Error Messages
//---------------

// Without Internet
const kErrorEmptyEmail = "Email cannot be empty";
const kErrorNotValidEmailAddress = "Not a valid email address";
const kErrorEmptyPassword = "Password cannot be empty";
const kErrorEmptyConfirmPassword = "Confirm password cannot be empty";
const kErrorPasswordNotMatch = "Password doesnt match";
const kErrorEmptyPhoneNumber = "Phone Number cannot be empty";
const kErrorEmptyFullName = "Full Name cannot be empty";

const kNullMerchantName = "Merchant Name cannot be empty";
const kNullMerchantAddress = "Merchant Address cannot be empty";
const kNullOperationHour = "Merchant Operating hour cannot be empty";
const kNullPhoneNumber = "Merchant Phone Number cannot be empty";

// With Internet
const kErrorUserNotRegistered = "User is not available";
const kErrorWrongEmailOrPassword = "Wrong Email or Password";
const kErrorCreateUserFailed = "Cannot Create this User";
const kErrorEmailAlreadyInUse = "Email is already in use";
const kErrorFailedUploadImage = "Error uploading image";

// Regex filter
const kEmailRegex =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

// Default Content
const kDefaultRestaurantName = "Restaurant Name Here";
const kDefaultAddress = "Address Here";
const kDefaultDescription = "Description Here";
const kDefaultOperatingTime = "Operating Time Here";
const kDefaultPhoneNumber = "Phone Number Here";
const kDefaultEmail = "Email Here";

//------
// Views
//------

// Login / Register View
const double expandedHeight = 152;
const double cardHeight = 240.0;
const double cardWidth = 160.0;

enum FetchingStatus {
  notFetching,
  isFetching,
  isLastPage,
  noResult,
}

enum OrderDay {
  today,
  upcoming,
  past,
}

// Dummy
const kDummyCustomerName = "John Doe";
const kDummyDefaultImage =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSgtOIzMXobQHT5Me1o-aTK0TbnGuE9FzVLi9AYTg-ZODyxw6ob";
const kDummyMap =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRd3Dwz0UrzTfTmR9V6FOEAzJd9e5Mb6_9QA6vJV9S0CJFEimcF";
const kDummyFoodImage =
    "https://cdns.klimg.com/merdeka.com/i/w/news/2019/10/05/1115256/670x335/resep-gado-gado-surabaya-menu-sayuran-segar-untuk-cuaca-panas.jpg";
const kDummyFoodName =
    "Rice Cake with Traditional Peanut Sauce, Mixed Spices, Traditional Salad and Egg";
const kDummyMerchantName = "Chez Gado Gado Restaurant";
const kDummyMerchantImage =
    "https://smudgeeats.com/wp-content/uploads/2016/06/restaurant_bali_chezgadogado_12-720x480.jpg";
const kDummyMerchantAddress =
    "Jl. Camplung Tanduk No.99, Seminyak, Kuta, Kabupaten Badung, Bali 80361";
const kDummyDescription =
    "Gado-gado (Indonesian or Betawi), also known as Lotek (Sundanese and Javanese), is an Indonesian salad of slightly boiled, blanched or steamed vegetables and hard-boiled eggs, boiled potato, fried tofu and tempeh, and lontong (rice wrapped in a banana leaf), served with a peanut sauce dressing.";
const kDummyMerchantOpenStatus = "Open from 10:00 AM until 1:00 AM";
const kDummyFoodPrice = "Rp. 40.000";
