import {ChangeDetectionStrategy, Component, OnInit} from '@angular/core';
import {FormBuilder, FormGroup, Validators} from '@angular/forms';
import {Logger} from 'aws-amplify';
import {Task} from '../../model/task';
import {ActivatedRoute, Router} from '@angular/router';
import {ToastController} from '@ionic/angular';
import {TasksPagesEnum} from '../../utils/routes/tasks-pages.enum';
import {ZonedDateUtil} from '../../utils/dates/zoned.date';
import {ButtonsState} from '../../utils/buttons/buttons.state';
import {TasksEntityService} from '../../services/tasks-entity.service';
import {LogLevel} from '../../../shared/utils/logger/log.level';

@Component({
  selector: 'app-save',
  templateUrl: './save.component.html',
  styleUrls: ['./save.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SaveComponent extends ButtonsState implements OnInit {

  public taskPageTitle = '';
  public taskForm: FormGroup = this.formBuilder.group({
    name: [null, [Validators.required, Validators.minLength(5), Validators.maxLength(25)]],
    description: [null, [Validators.minLength(10), Validators.maxLength(150)]],
    hour: [null, [Validators.required, Validators.min(0), Validators.max(23)]],
    minute: [null, [Validators.required, Validators.min(0), Validators.max(59)]],
    executionTime: [null, Validators.required],       // Used only for Time 'HH:mm' formatting.
    executionDays: [null, Validators.required],
    executionDaysList: [null, Validators.required],   // Used only for Days of Week selection.
    executeUntil: [null]
  });

  private logger = new Logger('SaveComponent', LogLevel.debug);
  private originalTask: Task;

  constructor(private route: ActivatedRoute,
              private router: Router,
              private formBuilder: FormBuilder,
              private toastController: ToastController,
              private taskEntityService: TasksEntityService) {
    super();
  }

  public async ngOnInit() {
    this.logger.debug('ngOnInit() - START');
    if (this.router.url.endsWith('create')) {
      this.taskPageTitle = 'Create Task';
      super.setCreateButtonsState();
    } else {
      this.taskPageTitle = 'Update Task';
      const taskId = this.route.snapshot.paramMap.get('taskId');
      this.taskEntityService.getByKey(taskId).subscribe(async registeredTask => {
        if (registeredTask) {
          this.originalTask = registeredTask;
          this.assignExistingTaskToForm(this.originalTask);
        } else {
          await this.presentToast(`Task <b>${taskId}</b> not found.`);
          await this.router.navigate([TasksPagesEnum.tasksPage]);
        }
      });
    }
    this.logger.debug('ngOnInit() - END');
  }

  public formatExecutionTimeValue(value): void {
    const executeUntilFormatted: string = ZonedDateUtil.getParsedZonedDate(value, 'HH:mm');
    const taskTimeValues: string[] = executeUntilFormatted.split(':');
    this.taskForm.patchValue({
      hour: taskTimeValues[0]
    });
    this.taskForm.patchValue({
      minute: taskTimeValues[1]
    });
    this.taskForm.patchValue({
      executionTime: executeUntilFormatted
    });
  }

  public formatExecuteUntilValue(value): void {
    this.logger.debug('formatExecuteUntilValue() - START: ', value);
    if (value) {
      this.taskForm.patchValue({
        executeUntil: ZonedDateUtil.getParsedZonedDate(value, 'dd MMM yyyy')
      });
    } else {
      this.taskForm.patchValue({
        executeUntil: null
      });
    }
  }

  public executionDaysListChanged(event): void {
    this.logger.debug('executionDaysListChanged() - START: ', event);
    const executionDaysList = [];
    event.detail.value.forEach(day => {
      executionDaysList.push(day);
    });
    this.taskForm.patchValue({
      executionDays: executionDaysList.join(',')
    });
  }

  public formatExecuteUntilTimeValue(task: Task): void {
    if (task.executeUntil) {
      task.executeUntil = ZonedDateUtil.getStringZonedDate(ZonedDateUtil.setTimeToMidnight(new Date(task.executeUntil)));
    }
  }

  public async save() {
    if (this.taskForm.invalid) {
      this.taskForm.markAllAsTouched();
      return;
    }
    if (super.isCreatingState()) {
      this.createTask();
    } else if (super.isUpdatingState()) {
      this.updateTask();
    }
    await this.router.navigateByUrl(TasksPagesEnum.tasksPage);
  }

  public async cancel(): Promise<void> {
    if (super.isCreatingState()) {
      this.taskForm.reset();
    } else if (super.isUpdatingState()) {
      this.taskForm.patchValue(this.originalTask);
      this.initTaskDates(this.originalTask);
    }
    await this.router.navigateByUrl(TasksPagesEnum.tasksPage);
  }

  private assignExistingTaskToForm(registeredTask: Task) {
    this.taskForm.patchValue(registeredTask);
    this.initTaskDates(registeredTask);
    this.initExecutionDaysList(registeredTask);
    super.setUpdateButtonsState();
  }

  private initTaskDates(registeredTask: Task) {
    const executionTime: Date = new Date(1985, 4, 8, registeredTask.hour, registeredTask.minute, 0, 0);
    this.formatExecutionTimeValue(ZonedDateUtil.getStringZonedDate(executionTime));
    this.formatExecuteUntilValue(registeredTask.executeUntil);
  }

  private initExecutionDaysList(registeredTask: Task) {
    const executionDaysList = [];
    registeredTask.executionDays.split(',').forEach(day => {
      executionDaysList.push(day);
    });
    this.taskForm.patchValue({
      executionDaysList
    });
  }

  private createTask() {
    const formValues = {...this.taskForm.value};
    delete formValues.executionTime;
    delete formValues.executionDaysList;
    const newTask: Task = formValues;
    newTask.executionCommand = 'python3 /home/pi/faker/faker.py';
    this.formatExecuteUntilTimeValue(newTask);
    this.taskEntityService.add(newTask).subscribe(async (createdTask: Task) => {
      this.logger.debug('createTask() - Task created successfully: ', createdTask);
      await this.presentToast('Task created successfully.');
    });
  }

  private updateTask() {
    const formValues = {...this.taskForm.value};
    delete formValues.executionTime;
    delete formValues.executionDaysList;
    const updatedTask: Task = formValues;
    this.setImmutableValues(updatedTask);
    this.formatExecuteUntilTimeValue(updatedTask);
    this.taskEntityService.update(updatedTask).subscribe(async (taskUpdated: Task) => {
      this.logger.debug('updateTask() - Task updated successfully: ', taskUpdated);
      await this.presentToast('Task updated successfully.');
    });
  }

  private setImmutableValues(updatedTask: Task) {
    updatedTask.id = this.originalTask.id;
    updatedTask.executionCommand = this.originalTask.executionCommand;
    updatedTask.jobId = this.originalTask.jobId;
    updatedTask.createdAt = this.originalTask.createdAt;
  }

  private async presentToast(message: string) {
    const toast = await this.toastController.create({
      message,
      duration: 3000
    });
    await toast.present();
  }

}
