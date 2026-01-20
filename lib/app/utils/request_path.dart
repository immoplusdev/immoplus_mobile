import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestPath {
  //https://run.mocky.io/v3/a0fc7f79-97ef-4ea4-8f89-02014218f516
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  //"https://run.mocky.io/v3";
  //config
  static String config = "/api/configuration/retrieve";
  //authentification
  static String login = "/api/auth/login";
  static String register = "/api/auth/register";
  static String updateUser({required String id}) => "/users/$id";
  static String updatePassword = "/api/auth/update-password";
//
  static String test = "/albums/1";
//
  static String gallery = "/items/gallery";
  static String galleryTest = '/aec834f0-5d63-4c1c-ab91-c9ce209f90b3';
  static String productydetailTest =
      "/f75c7ad4d05594355d0f"; //'/a0fc7f79-97ef-4ea4-8f89-02014218f516';
  // product
  static String products = "/items/products";
  static String productsRecommended = "/api/products/recommandations";
  static String productsAtHome = "/api/products/at-home";
  static String productViewed = "/api/products/viewed";
  static String logments = "/api/logements/items";
  static String logmentDetail({required String id}) =>
      "/api/logements/items/$id";
  static String productId({required int id}) => "/items/products/$id";
  static String productDetail({required int id}) => "/api/products/details/$id";
  static String productSimilar({required int id}) =>
      "/api/products/similar/$id";
  static String productMap = "/api/products/map";
//Visit
  static String orderVisit = "/api/demande_visite";

  //Order
  static String orderService = "/api/orders/create-demande-service";
  static String reservations = "/api/reservations/items";
  static String orderBooking = "/api/booking";
  static String orders = "/items/orders";
  static String serviceInterne = "/items/services_internes";
  static String orderId({required String id}) => "/items/orders/$id";

  static String calculOrderProduct = "/api/orders/calculate-order-price";
  static String orderProduct = "/api/orders";
  //static String registor = '/user/register';/api/products/details/25

  //payments
  static String operatorsProviders = "/api/payments/data/providers";
  static String createPaymentIntent = "/api/payments/create-payment-intent";
  static String authentificatePayment =
      "/api/payments/authenticate-payment-intent";
  static String notifications = "/notifications";
  //files
  static String files = "/files";
}
