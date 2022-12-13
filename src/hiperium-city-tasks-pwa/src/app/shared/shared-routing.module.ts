import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {HttpErrorsComponent} from './components/http-errors/http-errors.component';

const routes: Routes = [
  {
    path: ':errorCode',
    component: HttpErrorsComponent
  },
  {
    path: '**',
    redirectTo: '404'
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SharedRoutingModule {
}
