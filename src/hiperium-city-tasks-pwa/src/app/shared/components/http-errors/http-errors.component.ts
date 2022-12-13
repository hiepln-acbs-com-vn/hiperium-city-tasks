import {Component, OnInit} from '@angular/core';
import {ActivatedRoute} from '@angular/router';

@Component({
  selector: 'app-http-errors',
  templateUrl: './http-errors.component.html',
  styleUrls: ['./http-errors.component.scss'],
})
export class HttpErrorsComponent implements OnInit {

  public pageTitle = '';
  public errorMessage = '';
  constructor(private route: ActivatedRoute) {
  }

  ngOnInit() {
    const errorCode = this.route.snapshot.paramMap.get('errorCode');
    switch (errorCode) {
      case '401': {
        this.pageTitle = 'Unauthorized';
        this.errorMessage = 'You are not authorized to access this page.';
        break;
      }
      case '403': {
        this.pageTitle = 'Permission denied';
        this.errorMessage = 'You do not have permission to access this page.';
        break;
      }
      case '404': {
        this.pageTitle = 'Page not found';
        this.errorMessage = 'The page you are looking for does not exist.';
        break;
      }
      case '500': {
        this.pageTitle = 'Application Error';
        this.errorMessage = 'An error occurred while processing your request.';
        break;
      }
      case '503':
        this.pageTitle = 'Application Error';
        this.errorMessage = 'The requested service is not available.';
        break;
      default: {
        this.pageTitle = 'Unknown Error';
        this.errorMessage = 'An unknown error occurred.';
      }
    }
  }

}
