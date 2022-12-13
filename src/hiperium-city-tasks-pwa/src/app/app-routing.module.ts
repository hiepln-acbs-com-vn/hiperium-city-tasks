import {NgModule} from '@angular/core';
import {PreloadAllModules, RouterModule, Routes} from '@angular/router';
import {AuthGuardService} from './auth/services/auth-guard.service';
import {TasksRoutesEnum} from './tasks/utils/routes/tasks-routes.enum';
import {HomeComponent} from './home/home.component';
import {SharedRoutesEnum} from './shared/utils/routes/shared-routes.enum';
import {ErrorRoutesEnum} from './shared/utils/routes/error-routes.enum';

const routes: Routes = [
  {
    path: '',
    redirectTo: SharedRoutesEnum.homeRoute,
    pathMatch: 'full'
  },
  {
    path: SharedRoutesEnum.homeRoute,
    component: HomeComponent
  },
  {
    path: TasksRoutesEnum.tasksRoute,
    canActivate: [AuthGuardService],
    loadChildren: () => import('./tasks/tasks.module').then(m => m.TasksModule)
  },
  {
    path: SharedRoutesEnum.errorRoute,
    loadChildren: () => import('./shared/shared.module').then(m => m.SharedModule)
  },
  {
    path: '**',
    redirectTo: ErrorRoutesEnum.notFoundRoute
  }
];

@NgModule({
  imports: [
    RouterModule.forRoot(routes, { preloadingStrategy: PreloadAllModules })
  ],
  exports: [RouterModule]
})
export class AppRoutingModule {}
