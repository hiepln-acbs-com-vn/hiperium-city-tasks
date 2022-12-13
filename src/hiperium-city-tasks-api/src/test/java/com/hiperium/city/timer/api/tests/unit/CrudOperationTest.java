package com.hiperium.city.timer.api.tests.unit;

import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.utils.ResourcesPath;
import com.hiperium.city.timer.api.tests.utils.TestsUtil;
import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.keycloak.client.KeycloakTestClient;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.junit.jupiter.api.Test;

import javax.ws.rs.core.MediaType;

import static javax.ws.rs.core.Response.Status.*;
import static org.hamcrest.CoreMatchers.containsString;

@QuarkusTest
public class CrudOperationTest {

    KeycloakTestClient keycloakClient = new KeycloakTestClient();

    protected String getAccessToken() {
        return keycloakClient.getAccessToken("admin");
    }

    @Test
    void mustCrudOperationTest() {
        Task createdTask = this.mustCreateTaskTest();
        this.mustReadAllTasksTest();
        Task task = this.mustReadSingleTaskTest(createdTask.getId());
        this.mustUpdateTaskTest(task);
        this.mustDeleteTaskTest(task.getId());

    }

    private Task mustCreateTaskTest() {
        Task task = TestsUtil.generateTestTask();
        Response response = RestAssured.given()
                .when()
                .body(task)
                .contentType(MediaType.APPLICATION_JSON)
                .auth().oauth2(getAccessToken())
                .post(ResourcesPath.TASK)
                .then()
                .statusCode(CREATED.getStatusCode())
                .body(
                        containsString("\"id\":"),
                        containsString("\"jobId\":"),
                        containsString("\"createdAt\":"))
                .extract().response();
        return response.as(Task.class);
    }

    private void mustReadAllTasksTest() {
        RestAssured.given()
                .when()
                .auth().oauth2(getAccessToken())
                .get(ResourcesPath.TASKS)
                .then()
                .statusCode(OK.getStatusCode())
                .extract().response();
    }

    private Task mustReadSingleTaskTest(Long taskId) {
        Response response = RestAssured.given()
                .when()
                .auth().oauth2(getAccessToken())
                .get(ResourcesPath.TASK + "/" + taskId)
                .then()
                .statusCode(OK.getStatusCode())
                .extract().response();
        return response.as(Task.class);
    }

    private void mustUpdateTaskTest(Task task) {
        task.setHour(23);
        task.setMinute(15);
        task.setDescription("Task description updated");
        Response response = RestAssured.given()
                .when()
                .body(task)
                .contentType(MediaType.APPLICATION_JSON)
                .auth().oauth2(getAccessToken())
                .put(ResourcesPath.TASK + "/" + task.getId())
                .then()
                .statusCode(OK.getStatusCode())
                .extract().response();
    }

    private void mustDeleteTaskTest(Long taskId) {
        RestAssured.given()
                .when()
                .auth().oauth2(getAccessToken())
                .delete(ResourcesPath.TASK + "/" + taskId)
                .then()
                .statusCode(NO_CONTENT.getStatusCode());
    }
}
