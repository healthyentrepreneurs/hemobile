import 'package:he_api/he_api.dart';

const successMessage = {'message': 'Success'};
const errorMessage = {'message': 'error'};
const baseUrl = 'http://${Endpoints.localEmulatorIp}:5051';
const loginData = {'username': '11206', 'password': 'Newuser123!'};
const usernameWrong = 'XX11206';
const passwordWrong = 'Newuser123!XX';
const password = 'Newuser123!';
const header = {'Content-Type': 'application/json'};
const profileHash = '1670505457';
const profile =
    'http://${Endpoints.localEmulatorIp}/moodle/theme/image.php/_s/boost/core/${profileHash}/u';
const profileSmall = '$profile/f2';
const profileimageurl = '$profile/f1';
const id = 3;
const username = '11206';
const firstname = 'Aannet';
const lastname = 'Hanga';
const email = '11206@healthyentrepreneurs.nl';
const lang = 'en';
const country = 'UG';
const imageUrlSmall =
    'http://${Endpoints.localEmulatorIp}/moodle/webservice/pluginfile.php/1691/course/overviewfiles/education.png?token=0404e892bb10bf68e08e1c2d55b30e3d';
const imageUrl =
    'http://${Endpoints.localEmulatorIp}/moodle/webservice/pluginfile.php/1691/course/overviewfiles/education.png?token=0404e892bb10bf68e08e1c2d55b30e3d';
