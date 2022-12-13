import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {IonicModule} from '@ionic/angular';
import {SharedRoutingModule} from './shared-routing.module';
import {HeaderComponent} from './components/header/header.component';
import {FormErrorsComponent} from './components/form-errors/form-errors.component';
import {HttpErrorsComponent} from './components/http-errors/http-errors.component';

@NgModule({
  imports: [
    CommonModule,
    IonicModule,
    SharedRoutingModule
  ],
  declarations: [
    HeaderComponent,
    FormErrorsComponent,
    HttpErrorsComponent,
  ],
  exports: [
    HeaderComponent,
    FormErrorsComponent,
  ]
})
export class SharedModule {
}
