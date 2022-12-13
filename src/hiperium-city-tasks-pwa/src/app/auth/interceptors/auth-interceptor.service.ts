import {Injectable} from '@angular/core';
import {OAuthStorage} from 'angular-oauth2-oidc';
import {ErrorHandlerService} from '../services/error-handler.service';
import {HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest} from '@angular/common/http';
import {catchError, map, Observable, retry, throwError, timer} from 'rxjs';
import {Logger} from 'aws-amplify';
import {LogLevel} from '../../shared/utils/logger/log.level';
import {environment} from '../../../environments/environment';

@Injectable()
export class AuthInterceptorService implements HttpInterceptor {

  private logger = new Logger('AuthInterceptorService', LogLevel.debug);
  private apiUrl = environment.apiUrl;

  constructor(private errorHandler: ErrorHandlerService,
              private authStorage: OAuthStorage) {
  }

  public intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    request = this.verifyAndUpdateRequestUrl(request);
    request = this.setRequestAuthHeader(request);
    this.logger.debug('intercept() - HTTP Request: ', request);
    return next.handle(request).pipe(
      map(res => {
        console.log('Passed through the interceptor in response.');
        return res;
      }),
      retry({count: 2, delay: this.shouldRetry}),
      catchError((error) => {
        this.errorHandler.handleError(error);
        return throwError(error);
      })
    );
  }

  private verifyAndUpdateRequestUrl(request: HttpRequest<any>) {
    if (!request.url.toLowerCase().startsWith('http')) {
      request = request.clone({
        url: `${this.apiUrl}/${request.url}`
      });
    }
    return request;
  }

  private setRequestAuthHeader(request: HttpRequest<any>): HttpRequest<any> {
    const token = this.authStorage.getItem('access_token');
    if (token) {
      request = request.clone({
        headers: request.headers.set('Authorization', `Bearer ${this.authStorage.getItem('access_token')}`)
      });
    }
    return request;
  }

  private shouldRetry(error: HttpErrorResponse) {
    if (error.status >= 500) {
      return timer(1000);
    }
    throw error;
  }
}
