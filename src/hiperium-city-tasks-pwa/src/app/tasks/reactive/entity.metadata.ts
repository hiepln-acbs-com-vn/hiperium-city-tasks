import {EntityMetadataMap} from '@ngrx/data';
import {compareTasks} from '../model/task';

export const entityMetadata: EntityMetadataMap = {
  task: {
    sortComparer: compareTasks,
    entityDispatcherOptions: {
      optimisticAdd: false,
      optimisticUpdate: false,
      optimisticDelete: false
    }
  }
};
