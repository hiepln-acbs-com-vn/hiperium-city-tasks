import {enableProdMode} from '@angular/core';
import {platformBrowserDynamic} from '@angular/platform-browser-dynamic';
import {Amplify} from '@aws-amplify/core';
import {AppModule} from './app/app.module';
import awsconfig from './aws-exports';
import {environment} from './environments/environment';

Amplify.configure(awsconfig);

if (environment.production) {
  Amplify.Logger.LOG_LEVEL = 'INFO';
  enableProdMode();
}

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.log(err));
