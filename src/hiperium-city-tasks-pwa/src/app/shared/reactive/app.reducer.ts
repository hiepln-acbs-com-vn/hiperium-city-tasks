import {ActionReducer, ActionReducerMap, MetaReducer} from '@ngrx/store';
import {routerReducer} from '@ngrx/router-store';
import {environment} from '../../../environments/environment';

// eslint-disable-next-line @typescript-eslint/no-empty-interface
export interface AppState {}

export const reducers: ActionReducerMap<AppState> = {
  router: routerReducer
};

export const logger = (reducer: ActionReducer<any>): ActionReducer<any> => (state, action) => reducer(state, action);

export const metaReducers: MetaReducer<AppState>[] = environment.production ? [] : [logger];


