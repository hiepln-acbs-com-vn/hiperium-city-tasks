INSERT INTO HIP_CTY_TASKS(id, name, job_id, description, hour, minute, execution_days, execution_command, execute_until, created_at, updated_at)
VALUES (nextval('hibernate_sequence'), 'Task 1', '123abc', 'Task 1 description', 10, 0, 'WED,FRI', 'java -jar execute-robot.jar', '2025-01-01 00:00:00', '2022-10-01 00:00:00', '2022-10-01 00:00:00');

INSERT INTO HIP_CTY_TASKS(id, name, job_id, description, hour, minute, execution_days, execution_command, execute_until, created_at, updated_at)
VALUES (nextval('hibernate_sequence'), 'Task 2', '456def', 'Task 1 description', 12, 10, 'MON,SUN', 'java -jar execute-robot.jar', '2025-01-01 00:00:00', '2022-10-01 00:00:00', '2022-10-01 00:00:00');

INSERT INTO HIP_CTY_TASKS(id, name, job_id, description, hour, minute, execution_days, execution_command, execute_until, created_at, updated_at)
VALUES (nextval('hibernate_sequence'), 'Task 3', '789ghi', 'Task 1 description', 18, 59, 'TUE,THU', 'java -jar execute-robot.jar', '2025-01-01 00:00:00', '2022-10-01 00:00:00', '2022-10-01 00:00:00');
