// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'piece_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PieceModel _$PieceModelFromJson(Map<String, dynamic> json) {
  return _PieceModel.fromJson(json);
}

/// @nodoc
mixin _$PieceModel {
  String get nom => throw _privateConstructorUsedError;
  int get nombre => throw _privateConstructorUsedError;

  /// Serializes this PieceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PieceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PieceModelCopyWith<PieceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PieceModelCopyWith<$Res> {
  factory $PieceModelCopyWith(
          PieceModel value, $Res Function(PieceModel) then) =
      _$PieceModelCopyWithImpl<$Res, PieceModel>;
  @useResult
  $Res call({String nom, int nombre});
}

/// @nodoc
class _$PieceModelCopyWithImpl<$Res, $Val extends PieceModel>
    implements $PieceModelCopyWith<$Res> {
  _$PieceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PieceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nom = null,
    Object? nombre = null,
  }) {
    return _then(_value.copyWith(
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PieceModelImplCopyWith<$Res>
    implements $PieceModelCopyWith<$Res> {
  factory _$$PieceModelImplCopyWith(
          _$PieceModelImpl value, $Res Function(_$PieceModelImpl) then) =
      __$$PieceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String nom, int nombre});
}

/// @nodoc
class __$$PieceModelImplCopyWithImpl<$Res>
    extends _$PieceModelCopyWithImpl<$Res, _$PieceModelImpl>
    implements _$$PieceModelImplCopyWith<$Res> {
  __$$PieceModelImplCopyWithImpl(
      _$PieceModelImpl _value, $Res Function(_$PieceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PieceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nom = null,
    Object? nombre = null,
  }) {
    return _then(_$PieceModelImpl(
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      nombre: null == nombre
          ? _value.nombre
          : nombre // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PieceModelImpl implements _PieceModel {
  const _$PieceModelImpl({this.nom = '', this.nombre = 0});

  factory _$PieceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PieceModelImplFromJson(json);

  @override
  @JsonKey()
  final String nom;
  @override
  @JsonKey()
  final int nombre;

  @override
  String toString() {
    return 'PieceModel(nom: $nom, nombre: $nombre)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PieceModelImpl &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.nombre, nombre) || other.nombre == nombre));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nom, nombre);

  /// Create a copy of PieceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PieceModelImplCopyWith<_$PieceModelImpl> get copyWith =>
      __$$PieceModelImplCopyWithImpl<_$PieceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PieceModelImplToJson(
      this,
    );
  }
}

abstract class _PieceModel implements PieceModel {
  const factory _PieceModel({final String nom, final int nombre}) =
      _$PieceModelImpl;

  factory _PieceModel.fromJson(Map<String, dynamic> json) =
      _$PieceModelImpl.fromJson;

  @override
  String get nom;
  @override
  int get nombre;

  /// Create a copy of PieceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PieceModelImplCopyWith<_$PieceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
