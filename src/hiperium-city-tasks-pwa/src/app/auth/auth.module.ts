import {ModuleWithProviders, NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {IonicModule} from '@ionic/angular';
import {AuthService} from './services/auth.service';
import {AuthGuardService} from './services/auth-guard.service';
import {ErrorHandlerService} from './services/error-handler.service';
import {AuthInterceptorService} from './interceptors/auth-interceptor.service';

@NgModule({
  imports: [
    CommonModule,
    IonicModule
  ],
  declarations: []
})
export class AuthModule {
  static forRoot(): ModuleWithProviders<AuthModule> {
    return {
      ngModule: AuthModule,
      providers: [
        AuthService,
        AuthGuardService,
        ErrorHandlerService,
        AuthInterceptorService
      ]
    };
  }
}
