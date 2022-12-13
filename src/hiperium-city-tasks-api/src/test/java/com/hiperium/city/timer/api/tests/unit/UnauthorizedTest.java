package com.hiperium.city.timer.api.tests.unit;

import com.hiperium.city.timer.api.utils.ResourcesPath;
import io.quarkus.test.junit.QuarkusTest;
import io.restassured.RestAssured;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static javax.ws.rs.core.Response.Status.UNAUTHORIZED;

@QuarkusTest
public class UnauthorizedTest {

    @Test
    void mustGetAuthErrorFindingTaskTest() {
        RestAssured.given()
                .auth()
                .oauth2("invalid-token")
                .when()
                .get(ResourcesPath.TASK + "/1")
                .then()
                .statusCode(UNAUTHORIZED.getStatusCode());
    }

    @Test
    void mustGetAuthErrorDeletingTaskTest() {
        RestAssured.given()
                .when()
                .auth().oauth2("invalid-token")
                .delete(ResourcesPath.TASK + "/1")
                .then()
                .statusCode(UNAUTHORIZED.getStatusCode());
    }
}
