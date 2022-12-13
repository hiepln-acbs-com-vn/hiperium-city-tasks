import {NgModule} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';
import {HTTP_INTERCEPTORS, HttpClientModule} from '@angular/common/http';
import {OAuthModule} from 'angular-oauth2-oidc';
import {AppRoutingModule} from './app-routing.module';
import {SharedModule} from './shared/shared.module';
import {AuthModule} from './auth/auth.module';
import {StoreModule} from '@ngrx/store';
import {EffectsModule} from '@ngrx/effects';
import {EntityDataModule} from '@ngrx/data';
import {NavigationActionTiming, RouterState, StoreRouterConnectingModule} from '@ngrx/router-store';
import {StoreDevtoolsModule} from '@ngrx/store-devtools';
import {RouteReuseStrategy} from '@angular/router';
import {IonicModule, IonicRouteStrategy} from '@ionic/angular';
import {AuthInterceptorService} from './auth/interceptors/auth-interceptor.service';
import {AppComponent} from './app.component';
import {environment} from '../environments/environment';
import {metaReducers, reducers} from './shared/reactive/app.reducer';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    IonicModule.forRoot(),
    HttpClientModule,
    AppRoutingModule,
    OAuthModule.forRoot(),
    AuthModule.forRoot(),
    SharedModule,
    StoreModule.forRoot(reducers, {
      metaReducers,
      runtimeChecks: {
        strictStateImmutability: true,
        strictActionImmutability: true,
        strictStateSerializability: true,
        strictActionSerializability: true,
      }
    }),
    StoreRouterConnectingModule.forRoot({
      stateKey: 'router',
      routerState: RouterState.Minimal,
      navigationActionTiming: NavigationActionTiming.PostActivation
    }),
    EffectsModule.forRoot([]),
    EntityDataModule.forRoot({}),
    environment.production ? [] : StoreDevtoolsModule.instrument({maxAge: 25}),
  ],
  providers: [
    {provide: RouteReuseStrategy, useClass: IonicRouteStrategy},
    {provide: HTTP_INTERCEPTORS, useClass: AuthInterceptorService, multi: true},
  ],
  bootstrap: [AppComponent],
})
export class AppModule {
}
