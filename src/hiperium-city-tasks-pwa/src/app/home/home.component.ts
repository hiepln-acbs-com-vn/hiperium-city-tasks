import {Component} from '@angular/core';
import {PopoverController} from '@ionic/angular';
import {HomePopoverComponent} from './home.popover';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
})
export class HomeComponent {

  constructor(public popoverCtrl: PopoverController) { }

  async presentPopover(event: Event) {
    const popover = await this.popoverCtrl.create({
      component: HomePopoverComponent,
      event
    });
    await popover.present();
  }

}
