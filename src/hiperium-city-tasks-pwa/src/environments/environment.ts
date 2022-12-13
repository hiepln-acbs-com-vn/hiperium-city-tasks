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
  issuer: 'https://cognito-idp.us-east-1.amazonaws.com/us-east-1_HJYHtrCgS',
  oidc: true,
  strictDiscoveryDocumentValidation: false,
  clientId: '7b8hijhtfl8hh8v1l25srj3apd',
  redirectUri: 'http://localhost:8100/',    // MUST use the root domain for the Amplify Hosting.
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
