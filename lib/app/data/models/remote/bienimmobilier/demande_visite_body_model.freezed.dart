// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'demande_visite_body_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DemandeVisiteBodyModel _$DemandeVisiteBodyModelFromJson(
    Map<String, dynamic> json) {
  return _DemandeVisiteBodyModel.fromJson(json);
}

/// @nodoc
mixin _$DemandeVisiteBodyModel {
  String get bienImmobilier => throw _privateConstructorUsedError;
  String get typeDemandeVisite => throw _privateConstructorUsedError;
  List<DateDemandeVisite> get datesDemandeVisite =>
      throw _privateConstructorUsedError;
  String get clientPhoneNumber => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;

  /// Serializes this DemandeVisiteBodyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DemandeVisiteBodyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DemandeVisiteBodyModelCopyWith<DemandeVisiteBodyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DemandeVisiteBodyModelCopyWith<$Res> {
  factory $DemandeVisiteBodyModelCopyWith(DemandeVisiteBodyModel value,
          $Res Function(DemandeVisiteBodyModel) then) =
      _$DemandeVisiteBodyModelCopyWithImpl<$Res, DemandeVisiteBodyModel>;
  @useResult
  $Res call(
      {String bienImmobilier,
      String typeDemandeVisite,
      List<DateDemandeVisite> datesDemandeVisite,
      String clientPhoneNumber,
      String notes});
}

/// @nodoc
class _$DemandeVisiteBodyModelCopyWithImpl<$Res,
        $Val extends DemandeVisiteBodyModel>
    implements $DemandeVisiteBodyModelCopyWith<$Res> {
  _$DemandeVisiteBodyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DemandeVisiteBodyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bienImmobilier = null,
    Object? typeDemandeVisite = null,
    Object? datesDemandeVisite = null,
    Object? clientPhoneNumber = null,
    Object? notes = null,
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
      datesDemandeVisite: null == datesDemandeVisite
          ? _value.datesDemandeVisite
          : datesDemandeVisite // ignore: cast_nullable_to_non_nullable
              as List<DateDemandeVisite>,
      clientPhoneNumber: null == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DemandeVisiteBodyModelImplCopyWith<$Res>
    implements $DemandeVisiteBodyModelCopyWith<$Res> {
  factory _$$DemandeVisiteBodyModelImplCopyWith(
          _$DemandeVisiteBodyModelImpl value,
          $Res Function(_$DemandeVisiteBodyModelImpl) then) =
      __$$DemandeVisiteBodyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bienImmobilier,
      String typeDemandeVisite,
      List<DateDemandeVisite> datesDemandeVisite,
      String clientPhoneNumber,
      String notes});
}

/// @nodoc
class __$$DemandeVisiteBodyModelImplCopyWithImpl<$Res>
    extends _$DemandeVisiteBodyModelCopyWithImpl<$Res,
        _$DemandeVisiteBodyModelImpl>
    implements _$$DemandeVisiteBodyModelImplCopyWith<$Res> {
  __$$DemandeVisiteBodyModelImplCopyWithImpl(
      _$DemandeVisiteBodyModelImpl _value,
      $Res Function(_$DemandeVisiteBodyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DemandeVisiteBodyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bienImmobilier = null,
    Object? typeDemandeVisite = null,
    Object? datesDemandeVisite = null,
    Object? clientPhoneNumber = null,
    Object? notes = null,
  }) {
    return _then(_$DemandeVisiteBodyModelImpl(
      bienImmobilier: null == bienImmobilier
          ? _value.bienImmobilier
          : bienImmobilier // ignore: cast_nullable_to_non_nullable
              as String,
      typeDemandeVisite: null == typeDemandeVisite
          ? _value.typeDemandeVisite
          : typeDemandeVisite // ignore: cast_nullable_to_non_nullable
              as String,
      datesDemandeVisite: null == datesDemandeVisite
          ? _value._datesDemandeVisite
          : datesDemandeVisite // ignore: cast_nullable_to_non_nullable
              as List<DateDemandeVisite>,
      clientPhoneNumber: null == clientPhoneNumber
          ? _value.clientPhoneNumber
          : clientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DemandeVisiteBodyModelImpl implements _DemandeVisiteBodyModel {
  const _$DemandeVisiteBodyModelImpl(
      {this.bienImmobilier = '',
      this.typeDemandeVisite = '',
      final List<DateDemandeVisite> datesDemandeVisite = const [],
      this.clientPhoneNumber = '',
      this.notes = ''})
      : _datesDemandeVisite = datesDemandeVisite;

  factory _$DemandeVisiteBodyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DemandeVisiteBodyModelImplFromJson(json);

  @override
  @JsonKey()
  final String bienImmobilier;
  @override
  @JsonKey()
  final String typeDemandeVisite;
  final List<DateDemandeVisite> _datesDemandeVisite;
  @override
  @JsonKey()
  List<DateDemandeVisite> get datesDemandeVisite {
    if (_datesDemandeVisite is EqualUnmodifiableListView)
      return _datesDemandeVisite;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_datesDemandeVisite);
  }

  @override
  @JsonKey()
  final String clientPhoneNumber;
  @override
  @JsonKey()
  final String notes;

  @override
  String toString() {
    return 'DemandeVisiteBodyModel(bienImmobilier: $bienImmobilier, typeDemandeVisite: $typeDemandeVisite, datesDemandeVisite: $datesDemandeVisite, clientPhoneNumber: $clientPhoneNumber, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DemandeVisiteBodyModelImpl &&
            (identical(other.bienImmobilier, bienImmobilier) ||
                other.bienImmobilier == bienImmobilier) &&
            (identical(other.typeDemandeVisite, typeDemandeVisite) ||
                other.typeDemandeVisite == typeDemandeVisite) &&
            const DeepCollectionEquality()
                .equals(other._datesDemandeVisite, _datesDemandeVisite) &&
            (identical(other.clientPhoneNumber, clientPhoneNumber) ||
                other.clientPhoneNumber == clientPhoneNumber) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bienImmobilier,
      typeDemandeVisite,
      const DeepCollectionEquality().hash(_datesDemandeVisite),
      clientPhoneNumber,
      notes);

  /// Create a copy of DemandeVisiteBodyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DemandeVisiteBodyModelImplCopyWith<_$DemandeVisiteBodyModelImpl>
      get copyWith => __$$DemandeVisiteBodyModelImplCopyWithImpl<
          _$DemandeVisiteBodyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DemandeVisiteBodyModelImplToJson(
      this,
    );
  }
}

abstract class _DemandeVisiteBodyModel implements DemandeVisiteBodyModel {
  const factory _DemandeVisiteBodyModel(
      {final String bienImmobilier,
      final String typeDemandeVisite,
      final List<DateDemandeVisite> datesDemandeVisite,
      final String clientPhoneNumber,
      final String notes}) = _$DemandeVisiteBodyModelImpl;

  factory _DemandeVisiteBodyModel.fromJson(Map<String, dynamic> json) =
      _$DemandeVisiteBodyModelImpl.fromJson;

  @override
  String get bienImmobilier;
  @override
  String get typeDemandeVisite;
  @override
  List<DateDemandeVisite> get datesDemandeVisite;
  @override
  String get clientPhoneNumber;
  @override
  String get notes;

  /// Create a copy of DemandeVisiteBodyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DemandeVisiteBodyModelImplCopyWith<_$DemandeVisiteBodyModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
