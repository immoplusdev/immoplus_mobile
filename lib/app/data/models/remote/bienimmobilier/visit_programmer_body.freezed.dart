// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_programmer_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VisitProgrammerBody _$VisitProgrammerBodyFromJson(Map<String, dynamic> json) {
  return _VisitProgrammerBody.fromJson(json);
}

/// @nodoc
mixin _$VisitProgrammerBody {
  List<DateDemandeVisite> get datesDemandeVisite =>
      throw _privateConstructorUsedError;

  /// Serializes this VisitProgrammerBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VisitProgrammerBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VisitProgrammerBodyCopyWith<VisitProgrammerBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitProgrammerBodyCopyWith<$Res> {
  factory $VisitProgrammerBodyCopyWith(
          VisitProgrammerBody value, $Res Function(VisitProgrammerBody) then) =
      _$VisitProgrammerBodyCopyWithImpl<$Res, VisitProgrammerBody>;
  @useResult
  $Res call({List<DateDemandeVisite> datesDemandeVisite});
}

/// @nodoc
class _$VisitProgrammerBodyCopyWithImpl<$Res, $Val extends VisitProgrammerBody>
    implements $VisitProgrammerBodyCopyWith<$Res> {
  _$VisitProgrammerBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VisitProgrammerBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datesDemandeVisite = null,
  }) {
    return _then(_value.copyWith(
      datesDemandeVisite: null == datesDemandeVisite
          ? _value.datesDemandeVisite
          : datesDemandeVisite // ignore: cast_nullable_to_non_nullable
              as List<DateDemandeVisite>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VisitProgrammerBodyImplCopyWith<$Res>
    implements $VisitProgrammerBodyCopyWith<$Res> {
  factory _$$VisitProgrammerBodyImplCopyWith(_$VisitProgrammerBodyImpl value,
          $Res Function(_$VisitProgrammerBodyImpl) then) =
      __$$VisitProgrammerBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DateDemandeVisite> datesDemandeVisite});
}

/// @nodoc
class __$$VisitProgrammerBodyImplCopyWithImpl<$Res>
    extends _$VisitProgrammerBodyCopyWithImpl<$Res, _$VisitProgrammerBodyImpl>
    implements _$$VisitProgrammerBodyImplCopyWith<$Res> {
  __$$VisitProgrammerBodyImplCopyWithImpl(_$VisitProgrammerBodyImpl _value,
      $Res Function(_$VisitProgrammerBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of VisitProgrammerBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datesDemandeVisite = null,
  }) {
    return _then(_$VisitProgrammerBodyImpl(
      datesDemandeVisite: null == datesDemandeVisite
          ? _value._datesDemandeVisite
          : datesDemandeVisite // ignore: cast_nullable_to_non_nullable
              as List<DateDemandeVisite>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VisitProgrammerBodyImpl implements _VisitProgrammerBody {
  _$VisitProgrammerBodyImpl(
      {required final List<DateDemandeVisite> datesDemandeVisite})
      : _datesDemandeVisite = datesDemandeVisite;

  factory _$VisitProgrammerBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$VisitProgrammerBodyImplFromJson(json);

  final List<DateDemandeVisite> _datesDemandeVisite;
  @override
  List<DateDemandeVisite> get datesDemandeVisite {
    if (_datesDemandeVisite is EqualUnmodifiableListView)
      return _datesDemandeVisite;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_datesDemandeVisite);
  }

  @override
  String toString() {
    return 'VisitProgrammerBody(datesDemandeVisite: $datesDemandeVisite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisitProgrammerBodyImpl &&
            const DeepCollectionEquality()
                .equals(other._datesDemandeVisite, _datesDemandeVisite));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_datesDemandeVisite));

  /// Create a copy of VisitProgrammerBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisitProgrammerBodyImplCopyWith<_$VisitProgrammerBodyImpl> get copyWith =>
      __$$VisitProgrammerBodyImplCopyWithImpl<_$VisitProgrammerBodyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VisitProgrammerBodyImplToJson(
      this,
    );
  }
}

abstract class _VisitProgrammerBody implements VisitProgrammerBody {
  factory _VisitProgrammerBody(
          {required final List<DateDemandeVisite> datesDemandeVisite}) =
      _$VisitProgrammerBodyImpl;

  factory _VisitProgrammerBody.fromJson(Map<String, dynamic> json) =
      _$VisitProgrammerBodyImpl.fromJson;

  @override
  List<DateDemandeVisite> get datesDemandeVisite;

  /// Create a copy of VisitProgrammerBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisitProgrammerBodyImplCopyWith<_$VisitProgrammerBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
