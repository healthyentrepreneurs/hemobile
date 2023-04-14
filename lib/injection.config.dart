// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i6;

import 'package:cloud_firestore/cloud_firestore.dart' as _i8;
import 'package:firebase_auth/firebase_auth.dart' as _i7;
import 'package:firebase_storage/firebase_storage.dart' as _i10;
import 'package:get_it/get_it.dart' as _i1;
import 'package:he/home/appupdate/apkdownload/bloc/appudate_bloc.dart' as _i5;
import 'package:he/home/appupdate/apkseen/bloc/apkseen_bloc.dart' as _i3;
import 'package:he/objects/blocs/apkupdate/bloc/apk_bloc.dart' as _i18;
import 'package:he/objects/blocs/repo/apk_repo.dart' as _i12;
import 'package:he/objects/blocs/repo/database_repo.dart' as _i14;
import 'package:he/objects/blocs/repo/impl/iapk_repo.dart' as _i11;
import 'package:he/objects/blocs/repo/impl/idatabase_repo.dart' as _i13;
import 'package:he/service/app_module.dart' as _i19;
import 'package:he/service/firebase_service.dart' as _i9;
import 'package:he/service/permit_fofi_service.dart' as _i15;
import 'package:he/service/rx_sharedpref_service.dart' as _i17;
import 'package:he_storage/he_storage.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;
import 'package:rx_shared_preferences/rx_shared_preferences.dart'
    as _i16; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i3.ApkseenBloc>(
        () => _i3.ApkseenBloc(repository: gh<_i4.ApkupdateRepository>()));
    gh.factory<_i5.AppudateBloc>(() => _i5.AppudateBloc());
    gh.lazySingleton<_i6.Directory>(() => appModule.getdirectory);
    gh.lazySingleton<_i7.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i8.FirebaseFirestore>(() => appModule.firestore);
    await gh.factoryAsync<_i9.FirebaseService>(
      () => appModule.fireService,
      preResolve: true,
    );
    gh.lazySingleton<_i10.FirebaseStorage>(() => appModule.storage);
    gh.lazySingleton<_i11.IApkRepository>(
        () => _i12.ApkRepository(gh<_i8.FirebaseFirestore>()));
    gh.lazySingleton<_i13.IDatabaseRepository>(
        () => _i14.DatabaseRepository(gh<_i8.FirebaseFirestore>()));
    await gh.factoryAsync<_i15.PermitFoFiService>(
      () => appModule.getfolderfileService,
      preResolve: true,
    );
    gh.lazySingleton<_i16.RxSharedPreferences>(
        () => appModule.getrxsharedprefrence);
    await gh.factoryAsync<_i17.RxSharedPreferencesService>(
      () => appModule.getRxStorageService,
      preResolve: true,
    );
    gh.lazySingleton<String>(() => appModule.getexternaldownlodpath);
    gh.factory<_i18.ApkBloc>(
        () => _i18.ApkBloc(repository: gh<_i11.IApkRepository>()));
    return this;
  }
}

class _$AppModule extends _i19.AppModule {}
