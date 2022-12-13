import {Injectable} from '@angular/core';
import {HttpErrorResponse} from '@angular/common/http';
import {Router} from '@angular/router';
import {Logger} from 'aws-amplify';
import {LogLevel} from '../../shared/utils/logger/log.level';
import {ErrorPagesEnum} from '../../shared/utils/routes/error-pages.enum';

@Injectable()
export class ErrorHandlerService {

  private logger = new Logger('ErrorHandlerService', LogLevel.debug);

  constructor(private router: Router) {
  }

  public handleError(error) {
    if (error instanceof HttpErrorResponse) {
      this.logger.debug('intercept() - HTTP Error Response: ', error);
      switch (error.status) {
        // case 401: The unauthorized error is handled by the AuthGuardService.
        case 403: {
          this.router.navigateByUrl(ErrorPagesEnum.forbiddenPage);
          break;
        }
        case 500: {
          this.router.navigateByUrl(ErrorPagesEnum.serverErrorPage);
          break;
        }
        case 503: {
          this.router.navigateByUrl(ErrorPagesEnum.serviceUnavailablePage);
          break;
        }
      }
    }
  }
}
