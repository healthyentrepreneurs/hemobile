// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i4;

import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:firebase_storage/firebase_storage.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:he/home/appupdate/apkdownload/bloc/appudate_bloc.dart' as _i3;
import 'package:he/objects/blocs/apkupdate/bloc/apk_bloc.dart' as _i16;
import 'package:he/objects/blocs/repo/apk_repo.dart' as _i10;
import 'package:he/objects/blocs/repo/database_repo.dart' as _i18;
import 'package:he/objects/blocs/repo/impl/iapk_repo.dart' as _i9;
import 'package:he/objects/blocs/repo/impl/idatabase_repo.dart' as _i17;
import 'package:he/service/app_module.dart' as _i19;
import 'package:he/service/firebase_service.dart' as _i7;
import 'package:he/service/objectbox_service.dart' as _i12;
import 'package:he/service/permit_fofi_service.dart' as _i13;
import 'package:he/service/rx_sharedpref_service.dart' as _i15;
import 'package:he_storage/he_storage.dart' as _i11;
import 'package:injectable/injectable.dart' as _i2;
import 'package:rx_shared_preferences/rx_shared_preferences.dart' as _i14;

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
    gh.factory<_i3.AppudateBloc>(() => _i3.AppudateBloc());
    gh.lazySingleton<_i4.Directory>(() => appModule.getdirectory);
    gh.lazySingleton<_i5.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.lazySingleton<_i6.FirebaseFirestore>(() => appModule.firestore);
    await gh.factoryAsync<_i7.FirebaseService>(
      () => appModule.fireService,
      preResolve: true,
    );
    gh.lazySingleton<_i8.FirebaseStorage>(() => appModule.storage);
    gh.lazySingleton<_i9.IApkRepository>(() => _i10.ApkRepository(
          gh<_i6.FirebaseFirestore>(),
          gh<_i11.RxStgApkUpdateApi>(),
        ));
    await gh.factoryAsync<_i12.ObjectBoxService>(
      () => appModule.objectBoxService,
      preResolve: true,
    );
    await gh.factoryAsync<_i13.PermitFoFiService>(
      () => appModule.getfolderfileService,
      preResolve: true,
    );
    gh.lazySingleton<_i14.RxSharedPreferences>(
        () => appModule.getrxsharedprefrence);
    await gh.factoryAsync<_i15.RxSharedPreferencesService>(
      () => appModule.getRxStorageService,
      preResolve: true,
    );
    gh.lazySingleton<String>(() => appModule.getexternaldownlodpath);
    gh.factory<_i16.ApkBloc>(
        () => _i16.ApkBloc(repository: gh<_i9.IApkRepository>()));
    gh.lazySingleton<_i17.IDatabaseRepository>(() => _i18.DatabaseRepository(
          gh<_i6.FirebaseFirestore>(),
          gh<_i12.ObjectBoxService>(),
        ));
    return this;
  }
}

class _$AppModule extends _i19.AppModule {}
