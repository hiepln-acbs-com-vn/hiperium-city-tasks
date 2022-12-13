import {Injectable} from '@angular/core';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {Observable} from 'rxjs';
import {filter, first, tap} from 'rxjs/operators';
import {TasksEntityService} from './tasks-entity.service';
import {Logger} from 'aws-amplify';
import {LogLevel} from '../../shared/utils/logger/log.level';

@Injectable()
export class TasksResolverService implements Resolve<boolean> {

  private logger = new Logger('TasksResolverService', LogLevel.debug);

  constructor(private taskEntityService: TasksEntityService) {
  }

  public resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<boolean> {
    return this.taskEntityService.loaded$
      .pipe(
        tap(areTasksLoaded => {
          if (!areTasksLoaded) {
            this.logger.debug('resolve(): Loading tasks from the EntityService.');
            this.taskEntityService.getAll();
          }
        }),
        filter(loaded => !!loaded),
        first()
      );
  }
}
