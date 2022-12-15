// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.
import {AuthConfig} from 'angular-oauth2-oidc';

export const environment = {
  production: false,
  timeZone: 'America/Guayaquil',
  apiUrl: 'http://localhost'
};

export const authConfig: AuthConfig = {
  issuer: 'https://cognito-idp.AWS_REGION.amazonaws.com/COGNITO_USER_POOL_ID',
  oidc: true,
  strictDiscoveryDocumentValidation: false,
  clientId: 'COGNITO_APP_CLIENT_ID_WEB',
  redirectUri: 'http://localhost:8100/home',
  responseType: 'code',
  scope: 'phone email openid profile',
  showDebugInformation: !environment.production
};

/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.
