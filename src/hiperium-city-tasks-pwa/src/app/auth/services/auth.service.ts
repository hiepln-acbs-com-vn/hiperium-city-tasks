import {Injectable} from '@angular/core';
import {OAuthService, OAuthStorage} from 'angular-oauth2-oidc';
import {Subject} from 'rxjs';
import {Logger} from 'aws-amplify';
import {User} from '../model/user';
import {LogLevel} from '../../shared/utils/logger/log.level';
import {authConfig} from '../../../environments/environment';

@Injectable()
export class AuthService {

  private logger = new Logger('AuthService', LogLevel.debug);
  private userProfileSubject = new Subject<User>();

  constructor(private oAuthService: OAuthService) {
    this.logger.debug('constructor - BEGIN');
    this.oAuthService.configure(authConfig);
    this.oAuthService.loadDiscoveryDocumentAndTryLogin().then(() => {
      this.logger.debug('constructor - Discovery document loaded.');
      if (this.oAuthService.hasValidAccessToken()) {
        this.logger.debug('constructor - User logged in.');
        this.oAuthService.loadUserProfile().then((userProfile) => {
          this.userProfileSubject.next(userProfile as User);
        });
      } else {
        this.logger.debug('constructor - User is not logged in.');
      }
    });
    this.logger.debug('constructor - END');
  }

  get userProfileSubject$(): Subject<User> {
    return this.userProfileSubject;
  }

  public logIn() {
    this.oAuthService.initCodeFlow();
  }

  public logOut() {
    this.oAuthService.logOut();
  }

  public isUserLoggedIn(): boolean {
    return this.oAuthService.hasValidAccessToken();
  }
}
