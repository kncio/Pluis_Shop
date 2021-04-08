
import 'package:dartz/dartz.dart';
import 'package:pluis_hv_app/commons/apiClient.dart';
import 'package:pluis_hv_app/commons/failure.dart';
import 'package:pluis_hv_app/injectorContainer.dart' as injectorContainer;
import 'package:pluis_hv_app/settings/settings.dart';

class SplashScreenRepository{
  Future<Either<Failure, bool>> initializeApp() async {
   try{
     var api = injectorContainer.sl<ApiClient>();
     var response = await api.getToken("get_token", null);
     //Set token on settings
     Settings.setApiToken(apiToken: response.data["message"]["token_hash"]);
     var sToken = await Settings.storedApiToken;
     return Right(true);
   }
   catch(error){
     return Left(Failure([error]));
   }
    return Right(false);
  }
}