// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_programmer_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitProgrammerBodyImpl _$$VisitProgrammerBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$VisitProgrammerBodyImpl(
      datesDemandeVisite: (json['datesDemandeVisite'] as List<dynamic>)
          .map((e) => DateDemandeVisite.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$VisitProgrammerBodyImplToJson(
        _$VisitProgrammerBodyImpl instance) =>
    <String, dynamic>{
      'datesDemandeVisite': instance.datesDemandeVisite,
    };
