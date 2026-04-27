// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_schema.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOnboardingSchemaCollection on Isar {
  IsarCollection<OnboardingSchema> get onboardingSchemas => this.collection();
}

const OnboardingSchemaSchema = CollectionSchema(
  name: r'OnboardingSchema',
  id: 7369044416931993817,
  properties: {
    r'hasReadOnboarding': PropertySchema(
      id: 0,
      name: r'hasReadOnboarding',
      type: IsarType.bool,
    ),
    r'readAt': PropertySchema(
      id: 1,
      name: r'readAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(
      id: 2,
      name: r'version',
      type: IsarType.long,
    )
  },
  estimateSize: _onboardingSchemaEstimateSize,
  serialize: _onboardingSchemaSerialize,
  deserialize: _onboardingSchemaDeserialize,
  deserializeProp: _onboardingSchemaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _onboardingSchemaGetId,
  getLinks: _onboardingSchemaGetLinks,
  attach: _onboardingSchemaAttach,
  version: '3.3.0-dev.1',
);

int _onboardingSchemaEstimateSize(
  OnboardingSchema object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _onboardingSchemaSerialize(
  OnboardingSchema object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.hasReadOnboarding);
  writer.writeDateTime(offsets[1], object.readAt);
  writer.writeLong(offsets[2], object.version);
}

OnboardingSchema _onboardingSchemaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OnboardingSchema();
  object.hasReadOnboarding = reader.readBool(offsets[0]);
  object.id = id;
  object.readAt = reader.readDateTimeOrNull(offsets[1]);
  object.version = reader.readLong(offsets[2]);
  return object;
}

P _onboardingSchemaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _onboardingSchemaGetId(OnboardingSchema object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _onboardingSchemaGetLinks(OnboardingSchema object) {
  return [];
}

void _onboardingSchemaAttach(
    IsarCollection<dynamic> col, Id id, OnboardingSchema object) {
  object.id = id;
}

extension OnboardingSchemaQueryWhereSort
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QWhere> {
  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OnboardingSchemaQueryWhere
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QWhereClause> {
  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OnboardingSchemaQueryFilter
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QFilterCondition> {
  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      hasReadOnboardingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasReadOnboarding',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      readAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'readAt',
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      readAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'readAt',
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      readAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      readAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      readAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      readAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterFilterCondition>
      versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OnboardingSchemaQueryObject
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QFilterCondition> {}

extension OnboardingSchemaQueryLinks
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QFilterCondition> {}

extension OnboardingSchemaQuerySortBy
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QSortBy> {
  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      sortByHasReadOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReadOnboarding', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      sortByHasReadOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReadOnboarding', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      sortByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      sortByReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension OnboardingSchemaQuerySortThenBy
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QSortThenBy> {
  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      thenByHasReadOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReadOnboarding', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      thenByHasReadOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReadOnboarding', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      thenByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      thenByReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension OnboardingSchemaQueryWhereDistinct
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QDistinct> {
  QueryBuilder<OnboardingSchema, OnboardingSchema, QDistinct>
      distinctByHasReadOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasReadOnboarding');
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QDistinct>
      distinctByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readAt');
    });
  }

  QueryBuilder<OnboardingSchema, OnboardingSchema, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension OnboardingSchemaQueryProperty
    on QueryBuilder<OnboardingSchema, OnboardingSchema, QQueryProperty> {
  QueryBuilder<OnboardingSchema, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OnboardingSchema, bool, QQueryOperations>
      hasReadOnboardingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasReadOnboarding');
    });
  }

  QueryBuilder<OnboardingSchema, DateTime?, QQueryOperations> readAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readAt');
    });
  }

  QueryBuilder<OnboardingSchema, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
