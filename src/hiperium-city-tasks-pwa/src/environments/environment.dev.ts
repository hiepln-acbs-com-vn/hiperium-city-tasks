import {AuthConfig} from 'angular-oauth2-oidc';

export const environment = {
  production: false,
  timeZone: 'America/Guayaquil',
  apiUrl: 'https://br66uzocyd.execute-api.us-east-1.amazonaws.com'
};

export const authConfig: AuthConfig = {
  issuer: 'https://cognito-idp.us-east-1.amazonaws.com/us-east-1_HJYHtrCgS',
  oidc: true,
  strictDiscoveryDocumentValidation: false,
  clientId: '7b8hijhtfl8hh8v1l25srj3apd',
  redirectUri: 'https://dev.d1nefgpeoeeqgd.amplifyapp.com/',    // MUST use the root domain for the Amplify Hosting.
  responseType: 'code',
  scope: 'phone email openid profile',
  showDebugInformation: !environment.production
};
