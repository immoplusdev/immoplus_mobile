import 'package:immoplus/app/core/error/app_error_mapper.dart';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../models/remote/rating/rating_request.dart';
import '../models/remote/rating/rating_history_response.dart';
import '../models/remote/rating/residence_reviews_response.dart';
import '../providers/rating_provider.dart';
import 'package:injectable/injectable.dart';

@injectable
class RatingRepository {
  final Dio _dio;

  RatingRepository(this._dio);

  Future<void> createClientRating(RatingRequest request) async {
    try {
      await RatingProvider(_dio).createClientRating(request);
    } on DioException catch (e) {
      log('DioError (createClientRating): ${e.message}');
      throw AppErrorMapper.from(e);
    }
  }

  Future<RatingHistoryResponse> getRatingHistory(
      {int? page, int? perPage}) async {
    try {
      return await RatingProvider(_dio)
          .getRatingHistory(page: page, perPage: perPage);
    } on DioException catch (e) {
      log('DioError (getRatingHistory): ${e.message}');
      throw AppErrorMapper.from(e);
    }
  }

  Future<ResidenceReviewsResponse> getResidenceReviews(
    String residenceId, {
    int? page,
    int? perPage,
  }) async {
    try {
      return await RatingProvider(_dio)
          .getResidenceReviews(residenceId, page: page, perPage: perPage);
    } on DioException catch (e) {
      log('DioError (getResidenceReviews): ${e.message}');
      throw AppErrorMapper.from(e);
    }
  }
}
