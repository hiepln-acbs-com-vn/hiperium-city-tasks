import {Injectable} from '@angular/core';
import {ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot} from '@angular/router';
import {AuthService} from './auth.service';
import {Logger} from 'aws-amplify';
import {LogLevel} from '../../shared/utils/logger/log.level';
import {ErrorPagesEnum} from '../../shared/utils/routes/error-pages.enum';

@Injectable()
export class AuthGuardService implements CanActivate {

  private logger = new Logger('AuthGuardService', LogLevel.debug);

  constructor(private router: Router, private authService: AuthService) {
  }

  public async canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Promise<boolean> {
    const isUserLoggedIn = this.authService.isUserLoggedIn();
    this.logger.debug('canActivate(): ', isUserLoggedIn);
    if (!isUserLoggedIn) {
      this.logger.debug('canActivate() - User is not logged in. Redirecting to home page.');
      await this.router.navigateByUrl(ErrorPagesEnum.unauthorizedPage);
    }
    return isUserLoggedIn;
  }
}
