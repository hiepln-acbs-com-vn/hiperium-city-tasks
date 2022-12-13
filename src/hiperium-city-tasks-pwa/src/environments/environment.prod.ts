import {AuthConfig} from 'angular-oauth2-oidc';

export const environment = {
  production: true,
  timeZone: 'America/Guayaquil',
  apiUrl: 'https://API_GATEWAY_ID.execute-api.AWS_REGION.amazonaws.com'
};

export const authConfig: AuthConfig = {
  issuer: 'https://cognito-idp.AWS_REGION.amazonaws.com/COGNITO_USER_POOL_ID',
  oidc: true,
  strictDiscoveryDocumentValidation: false,
  clientId: 'COGNITO_APP_CLIENT_ID_WEB',
  redirectUri: 'https://TASK_SERVICE_ENV.AMPLIFY_APP_ID.amplifyapp.com/',    // MUST use the root domain for the Amplify Hosting.
  responseType: 'code',
  scope: 'phone email openid profile',
  showDebugInformation: !environment.production
};
