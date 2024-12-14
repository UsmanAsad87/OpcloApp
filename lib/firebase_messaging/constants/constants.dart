import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class Constants {
  static const String project_Id = 'opclo-d01dd';
  static const String BASE_URL =
      'https://fcm.googleapis.com/v1/projects/$project_Id/messages:send';
  static const String allUsers = 'AllUsers';
  // static const String sellerTopic = 'sellers';

  static Future<String> getAccessToken() async {
    try {
      final serviceAccountjson = {
        "type": "service_account",
        "project_id": "opclo-d01dd",
        "private_key_id": "ab7c76ddf220be74f9b628d72d6689900ef24735",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDQ9ToEhBKJw87X\niKr31n3IF6zpSli+mBGeCmWhrWjC7s+pECvuEdphOlqU2GczVlDfSw6B/96f48WX\n4P2Pe/LOLTS93wRRgosjsQjjvPsWA3rMUZKwoT/y4t+spWn1dc5ZYFWkgYFh9az9\nzydbKqZSi5W6qVb4Kju/eLxT42XTmmd1t6/CfH1b+GznoCoJSua99NOBenRtvcdx\n8I8yyJe/GnhyHoTgq49O/D80tU+ZzgeAfNPZojJQrltV0TmQnKyOF6whOq/viOGb\nyr0zN3de5r75j4B1fot4jo0f3RdmiddA7q+YBw6bd888UGCsTcskD0b5Oz7uSzfV\nGj0+gW2xAgMBAAECggEAB2AKZ8+mDFr/BVQ3bZcyWhI82gCT5Ik/QO/ewa+6TXwK\nlA3kMQtMBQe/W/bN4K3cnZ77cHrwl33dcuR/6pUuPxjxHjz9fOeBw/UbCle4mICv\nsD+2UNnmJQtdJ+2wMVfSvEyWRT/FamjWjeBGhDUbiPkQhDW3IjvyXyoSopbZeJgP\nmCPj+ehHsTrUQdcWocfWZWtoaUkqIjWRTNa2r+ynjrtlCz/mk3+1LfN2jnk1YaYv\noxKm5rl1GHmnyIFHUZYNwZqx+aNQUn8DS3PdU5LPspNNpDKXDkV0nLZJR2Pr1JHu\nf1XcxMbgKGfaRPjS1RPmWZEsr2/8zQZonDq1UF+GyQKBgQDpxSYMpU5GbMHiB4xH\n4XncDRXXdf5zKUW/N+TuqrxggS9KxuwHGjvWOcbEYgmZ0+un0lfsnrGbac0ig1kk\nlR3+4mVUFwRxiNhw+5f0IZGDFoAX1g+out1YU7JwZw5w3j1pTBPE5EK251kLoFKZ\nHahOVtCt+mqiR3xjDX35+RYDOQKBgQDk1A4W9JcwxvQVvLF8C/VEfS5M4jyOjiQO\n4KJVN5efvk3sXqGx+3j8ZVWEyl5dptVE08hM906D5ro8ja3Y0ay1Qw+XPRptg3De\nI+xBh3/hZeGgu77l7J/3tT5kANjO2JALCnAiOw/0AvkvZXmE/5qUlhJJaMPUm/BW\nEmBJg+JmOQKBgBYu4iRzD1F5gpB7XOF5UQIDr93pUYMGGJtDp5LKWuPhfmZfKAio\ngaMbinQaRYT2ajdbq4JFsN7plFDBHBVvnRAR1cG8CWzoqnlWNp4xDUjeOruIUaYW\nTWjTUGyAKwuk2zkBwiJ98qK+o2GKDix/dvgwHs9TowjRNcmEfz7YVzFpAoGBAJ8I\nDV7A0E6zBrIQuNz4RpY51bLTTLjaao74aXmGMFdx4CAVSJU0q0nmdz/ZkSnPJ8s0\n0LFE8wlSkj5BTQAyALDdEXnPmo1f21JXbvu/2w1gTCX0NWEASdDS4rCHsiZXdgxm\nTbZMi/LPGjVpdcIMDneTsNPZ/rfFRIvdK5QMF41pAoGAKCVCsQt8zuOnt0lpv4fi\nqlQ5S5rif7VXvnL39knmiRTHtd3aZL92hyW6T6gOSc+hSOedJIahT8pfEYCHzY/e\nkQXVdlyUjQF4UGLbPEmIGTuH1nKL8f3Dc/aA9+CLwDmFHRJl/kGcBj9ZnNRJimV9\nHJMjUqse+jiMCzHE5fVFoLE=\n-----END PRIVATE KEY-----\n",
        "client_email": "opclo-messaging@opclo-d01dd.iam.gserviceaccount.com",
        "client_id": "108829581811558271661",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/opclo-messaging%40opclo-d01dd.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      };

      List<String> scopes = [
        "https://www.googleapis.com/auth/userinfo.email",
        "https://www.googleapis.com/auth/firebase.database",
        "https://www.googleapis.com/auth/firebase.messaging"
      ];

      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountjson), scopes);
      // get access token
      auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountjson),
          scopes,
          client);

      return credentials.accessToken.data;
    } catch (e) {
      return '';
    }
  }
}
