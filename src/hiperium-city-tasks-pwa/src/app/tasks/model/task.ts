export interface Task {
  id: number;
  name: string;
  jobId: string;
  description?: string;
  hour: number;
  minute: number;
  executionDays: string;
  executionCommand: string;
  executeUntil: string;
  createdAt: Date;
  updatedAt: Date;
}

export const compareTasks = (t1: Task, t2: Task) => {
  const result = t1.hour - t2.hour;
  if (result === 0) {
    const result2 = t1.minute - t2.minute;
    return taskComparatorResult(result2);
  } else {
    return taskComparatorResult(result);
  }
};

const taskComparatorResult = (result: number) => {
  if (result > 0) {
    return 1;
  } else if (result < 0) {
    return -1;
  } else {
    return 0;
  }
};
