package com.hiperium.city.timer.api.tests.unit;

import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.utils.ResourcesPath;
import com.hiperium.city.timer.api.tests.utils.TestsUtil;
import io.quarkus.test.junit.QuarkusTest;
import io.quarkus.test.keycloak.client.KeycloakTestClient;
import io.restassured.RestAssured;
import org.junit.jupiter.api.Test;

import javax.ws.rs.core.MediaType;

import static io.restassured.RestAssured.given;
import static javax.ws.rs.core.Response.Status.*;

@QuarkusTest
public class TasksNotFoundTest {

    KeycloakTestClient keycloakClient = new KeycloakTestClient();

    protected String getAccessToken() {
        return keycloakClient.getAccessToken("admin");
    }

    @Test
    void taskNotFoundForUpdateTest() {
        String taskId = "999";
        Task task = TestsUtil.generateTestTask();
        task.setId(Long.valueOf(taskId));
        RestAssured.given()
                .when()
                .body(task)
                .contentType(MediaType.APPLICATION_JSON)
                .auth().oauth2(getAccessToken())
                .put(ResourcesPath.TASK.concat("/").concat(taskId))
                .then()
                .statusCode(NOT_FOUND.getStatusCode());
    }

    @Test
    void taskNotFoundForDelete() {
        RestAssured.given()
                .when()
                .auth().oauth2(getAccessToken())
                .delete(ResourcesPath.TASK + "/999")
                .then()
                .statusCode(NOT_FOUND.getStatusCode());
    }
}
