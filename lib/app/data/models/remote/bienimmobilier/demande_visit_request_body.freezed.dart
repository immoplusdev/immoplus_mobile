// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demande_visit_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DemandeVisitRequestBody _$DemandeVisitRequestBodyFromJson(
    Map<String, dynamic> json) {
  return _DemandeVisitRequestBody.fromJson(json);
}

/// @nodoc
mixin _$DemandeVisitRequestBody {
  String get bienImmobilier => throw _privateConstructorUsedError;
  String get typeDemandeVisite => throw _privateConstructorUsedError;
  String get clientPhoneNumber => throw _privateConstructorUsedError;

  /// Serializes this DemandeVisitRequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DemandeVisitRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemandeVisitRequestBodyCopyWith<DemandeVisitRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemandeVisitRequestBodyCopyWith<$Res> {
  factory $DemandeVisitRequestBodyCopyWith(DemandeVisitRequestBody value,
          $Res Function(DemandeVisitRequestBody) then) =
      _$DemandeVisitRequestBodyCopyWithImpl<$Res, DemandeVisitRequestBody>;
  @useResult
  $Res call(
      {String bienImmobilier,
      String typeDemandeVisite,
      String clientPhoneNumber});
}

/// @nodoc
class _$DemandeVisitRequestBodyCopyWithImpl<$Res,
        $Val extends DemandeVisitRequestBody>
    implements $DemandeVisitRequestBodyCopyWith<$Res> {
  _$DemandeVisitRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemandeVisitRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bienImmobilier = null,
    Object? typeDemandeVisite = null,
    Object? clientPhoneNumber = null,
  }) {
    return _then(_value.copyWith(
      bienImmobilier: null == bienImmobilier
          ? _value.bienImmobilier
          : bienImmobilier // ignore: cast_nullable_to_non_nullable
              as String,
      typeDemandeVisite: null == typeDemandeVisite
          ? _value.typeDemandeVisite
          : typeDemandeVisite // ignore: cast_nullable_to_non_nullable
              as String,
      clientPhoneNumber: null == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DemandeVisitRequestBodyImplCopyWith<$Res>
    implements $DemandeVisitRequestBodyCopyWith<$Res> {
  factory _$$DemandeVisitRequestBodyImplCopyWith(
          _$DemandeVisitRequestBodyImpl value,
          $Res Function(_$DemandeVisitRequestBodyImpl) then) =
      __$$DemandeVisitRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bienImmobilier,
      String typeDemandeVisite,
      String clientPhoneNumber});
}

/// @nodoc
class __$$DemandeVisitRequestBodyImplCopyWithImpl<$Res>
    extends _$DemandeVisitRequestBodyCopyWithImpl<$Res,
        _$DemandeVisitRequestBodyImpl>
    implements _$$DemandeVisitRequestBodyImplCopyWith<$Res> {
  __$$DemandeVisitRequestBodyImplCopyWithImpl(
      _$DemandeVisitRequestBodyImpl _value,
      $Res Function(_$DemandeVisitRequestBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of DemandeVisitRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bienImmobilier = null,
    Object? typeDemandeVisite = null,
    Object? clientPhoneNumber = null,
  }) {
    return _then(_$DemandeVisitRequestBodyImpl(
      bienImmobilier: null == bienImmobilier
          ? _value.bienImmobilier
          : bienImmobilier // ignore: cast_nullable_to_non_nullable
              as String,
      typeDemandeVisite: null == typeDemandeVisite
          ? _value.typeDemandeVisite
          : typeDemandeVisite // ignore: cast_nullable_to_non_nullable
              as String,
      clientPhoneNumber: null == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DemandeVisitRequestBodyImpl implements _DemandeVisitRequestBody {
  _$DemandeVisitRequestBodyImpl(
      {required this.bienImmobilier,
      required this.typeDemandeVisite,
      required this.clientPhoneNumber});

  factory _$DemandeVisitRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$DemandeVisitRequestBodyImplFromJson(json);

  @override
  final String bienImmobilier;
  @override
  final String typeDemandeVisite;
  @override
  final String clientPhoneNumber;

  @override
  String toString() {
    return 'DemandeVisitRequestBody(bienImmobilier: $bienImmobilier, typeDemandeVisite: $typeDemandeVisite, clientPhoneNumber: $clientPhoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemandeVisitRequestBodyImpl &&
            (identical(other.bienImmobilier, bienImmobilier) ||
                other.bienImmobilier == bienImmobilier) &&
            (identical(other.typeDemandeVisite, typeDemandeVisite) ||
                other.typeDemandeVisite == typeDemandeVisite) &&
            (identical(other.clientPhoneNumber, clientPhoneNumber) ||
                other.clientPhoneNumber == clientPhoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, bienImmobilier, typeDemandeVisite, clientPhoneNumber);

  /// Create a copy of DemandeVisitRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemandeVisitRequestBodyImplCopyWith<_$DemandeVisitRequestBodyImpl>
      get copyWith => __$$DemandeVisitRequestBodyImplCopyWithImpl<
          _$DemandeVisitRequestBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DemandeVisitRequestBodyImplToJson(
      this,
    );
  }
}

abstract class _DemandeVisitRequestBody implements DemandeVisitRequestBody {
  factory _DemandeVisitRequestBody(
      {required final String bienImmobilier,
      required final String typeDemandeVisite,
      required final String clientPhoneNumber}) = _$DemandeVisitRequestBodyImpl;

  factory _DemandeVisitRequestBody.fromJson(Map<String, dynamic> json) =
      _$DemandeVisitRequestBodyImpl.fromJson;

  @override
  String get bienImmobilier;
  @override
  String get typeDemandeVisite;
  @override
  String get clientPhoneNumber;

  /// Create a copy of DemandeVisitRequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemandeVisitRequestBodyImplCopyWith<_$DemandeVisitRequestBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
