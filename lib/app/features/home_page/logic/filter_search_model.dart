// ignore_for_file: unused_element

import 'package:immoplus/app/logic/app_state.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}

class FilterSearchModel {
  String? keyWord;
  String? sort = 'date_created';
  int? minPrice = 0;
  int? maxPrice = 500000000;
  int? ville = 0;
  int? category = 0;
  int? page = 1;
  int? perPage = 10;
  bool displayList = false;

  static final FilterSearchModel _singleton = FilterSearchModel._internal();

  factory FilterSearchModel() {
    return _singleton;
  }

  FilterSearchModel._internal({
    this.keyWord,
    this.sort = 'date_created',
    this.minPrice = 0,
    this.maxPrice = 500000000,
    this.ville = 0,
    this.category = 0,
    this.page = 1,
    this.perPage = 10,
  });

  String getFilter() {
    return '''search=${(_singleton.keyWord != null) ? _singleton.keyWord!.trim() : ''}&sort=${_singleton.sort}&meta=*&page=${_singleton.page}&limit=${_singleton.perPage}&filter={
    "_and":[
        {"status": {"_eq": "published"}}, 
        {"price": {"_lte": "${_singleton.maxPrice}"}},
        {"price": {"_gte": "${_singleton.minPrice}"}}
        {"category": {"_eq": ${AppState.getCurrentCategory() ?? 0}}}
        ${(ville != 0) ? ''',{"commune": {"_eq": ${_singleton.ville}}},{}''' : ''}
       
    ]
}''';
  }

  Map<String, dynamic> getFilterToMap() => {
        'search':
            (_singleton.keyWord != null) ? _singleton.keyWord!.trim() : '',
        'fields': '*,category.*,images.*',
        'sort': _singleton.sort,
        // 'meta': '*',
        'page': _singleton.page,
        'limit': _singleton.perPage,
        'filter': '''{
          "_and":[
              {"status": {"_eq": "published"}},
              {"price": {"_lte": "${_singleton.maxPrice}"}},
              {"price": {"_gte": "${_singleton.minPrice}"}},
              {"category": {"_eq": ${AppState.getCurrentCategory() ?? 0}}}
              ${(ville != 0) ? ''',{"city": {"_eq": ${_singleton.ville}}},{}''' : ''}
             
            
          ]
      }''',
      };
  // ${(category != 0) ? ''',{"category": {"_eq": ${_singleton.category}}},{}''' : ''}
  Map<String, dynamic> getFilterToMapLogment() => {
        'search':
            (_singleton.keyWord != null) ? _singleton.keyWord!.trim() : '',
        // 'fields': '*,category.*,images.*',
        'sort': _singleton.sort,
        // 'meta': '*',
        'page': _singleton.page,
        'limit': _singleton.perPage,
        'filter': '''{
          "_and":[
              {"status": {"_eq": "published"}},
              {"prix_reservation": {"_lte": "${_singleton.maxPrice}"}},
              {"prix_reservation": {"_gte": "${_singleton.minPrice}"}}

          ]
      }''',
      };
  void resetFilter() {
    _singleton.keyWord = null;
    _singleton.ville = 0;
    _singleton.category = 0;
    _singleton.sort = 'date_created';
    _singleton.minPrice = 0;
    _singleton.maxPrice = 500000000;
    _singleton.page = 1;
    _singleton.perPage = 10;
  }

  @override
  String toString() {
    return getFilterToMap().toString();
  }

  restoreFilter() {
    minPrice = 0;
    maxPrice = 500000000;
    sort = 'date_created';
    ville = 0;
    category = 0;
  }
}
