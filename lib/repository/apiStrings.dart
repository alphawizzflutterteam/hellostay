



import 'apiConstants.dart';

final Uri userRegister = Uri.parse('${baseUrl}register');
final Uri getSendOtp = Uri.parse('${baseUrl}send-otp');
final Uri loginApi = Uri.parse('${baseUrl}login');
final Uri getVerifyOtp = Uri.parse('${baseUrl}verify-otp');
final Uri getUserDataApi = Uri.parse('${baseUrl}me');
final Uri updatePassword = Uri.parse('${baseUrl}update-password');
final Uri getSignUpApi = Uri.parse('${baseUrl}signup/completesignup');
final Uri getSignSendOtp = Uri.parse('${baseUrl}signup/sendotp');
final Uri getSignVerifyOtp = Uri.parse('${baseUrl}signup/verifyotp');
final Uri getCountry = Uri.parse('${baseUrl}get_countries');
final Uri getSate= Uri.parse('${baseUrl}get_states');
final Uri getBusinessCategory= Uri.parse('${baseUrl}business_cat');
final Uri getProductListAPI = Uri.parse('${baseUrl}get_product_list');
final Uri getAddProductApi = Uri.parse('${baseUrl}product_purchase');
final Uri getBookingApiUrl = Uri.parse('${baseUrl1}user/booking-history');
final Uri getAddToCartApi = Uri.parse('${baseUrl1}booking/addToCart');
final Uri getSupplierOrClientApi = Uri.parse('${baseUrl}supplier');
final Uri contactSupplierOrClientApi = Uri.parse('${baseUrl}save_inquiry');
final Uri getProductsApi = Uri.parse('${baseUrl}get_home_products');
final Uri hotelSearch = Uri.parse('${baseUrl1}hotel/search');
final Uri checkoutApi = Uri.parse('${baseUrl1}booking/doCheckout');

const String MethodType = 'GET';
