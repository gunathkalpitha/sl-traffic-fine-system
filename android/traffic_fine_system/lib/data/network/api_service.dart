// lib/data/network/api_service.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../model/fine.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../model/payment_request.dart';
import '../model/payment_response.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Auth
  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  // Fine
  @GET('/fines/{referenceNumber}')
  Future<Fine> getFineDetails(
    @Path('referenceNumber') String referenceNumber,
    @Query('categoryId') String categoryId,
  );

  // Payment
  @POST('/payments')
  Future<PaymentResponse> processPayment(@Body() PaymentRequest request);

  @GET('/payments/{paymentId}')
  Future<PaymentResponse> getPaymentStatus(
    @Path('paymentId') String paymentId,
  );
}
