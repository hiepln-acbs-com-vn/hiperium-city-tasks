import {Component, OnInit} from '@angular/core';
import {NavigationEnd, NavigationStart, Router} from '@angular/router';
import {AuthService} from './auth/services/auth.service';
import {TasksPagesEnum} from './tasks/utils/routes/tasks-pages.enum';
import {LogLevel} from './shared/utils/logger/log.level';
import {Logger} from 'aws-amplify';
import {SharedRoutesEnum} from './shared/utils/routes/shared-routes.enum';
import {User} from './auth/model/user';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss'],
})
export class AppComponent implements OnInit {
  public appPages = [
    {title: 'Tasks', url: TasksPagesEnum.tasksPage, icon: 'calendar-number'}
  ];
  public loading = true;
  public isUserLoggedIn = false;
  public username = '';

  private logger = new Logger('AppComponent', LogLevel.debug);

  constructor(private router: Router, private authService: AuthService) {
  }

  public async ngOnInit() {
    this.logger.debug('ngOnInit - BEGIN');
    this.authService.userProfileSubject$.subscribe(async (user: User) => {
      this.isUserLoggedIn = true;
      this.username = user.info.name;
    });
    this.router.events.subscribe(event => {
      if (event instanceof NavigationStart) {
        this.loading = true;
      } else if (event instanceof NavigationEnd) {
        this.loading = false;
      }
    });
    this.logger.debug('ngOnInit - END');
  }

  public async login() {
    this.authService.logIn();
  }

  public async logout() {
    this.logger.debug('logout() - BEGIN');
    this.authService.logOut();
    this.isUserLoggedIn = false;
    await this.router.navigate([SharedRoutesEnum.homeRoute]);
    this.logger.debug('logout() - END');
  }
}
