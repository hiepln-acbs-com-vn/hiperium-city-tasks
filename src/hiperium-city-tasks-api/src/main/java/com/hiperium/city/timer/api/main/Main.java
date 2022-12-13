package com.hiperium.city.timer.api.main;

import com.hiperium.city.timer.api.vo.AuroraDBSecretVO;
import com.hiperium.city.timer.api.utils.TasksUtils;
import io.quarkus.runtime.Quarkus;
import io.quarkus.runtime.QuarkusApplication;
import io.quarkus.runtime.annotations.QuarkusMain;
import org.jboss.logging.Logger;

import java.text.MessageFormat;
import java.util.Objects;

/**
 * @author Andres Solorzano
 */
@QuarkusMain
public class Main {

    private static final Logger LOGGER = Logger.getLogger(Main.class.getName());
    private static final String SQL_CONNECTION = "jdbc:postgresql://{0}:{1}/{2}";

    public static void main(String[] args) {
        LOGGER.info("main() - BEGIN");
        setDataBaseProperties();
        setTimeZoneProperties();
        Quarkus.run(QuarkusApp.class, args);
        LOGGER.info("main() - END");
    }

    public static class QuarkusApp implements QuarkusApplication {
        @Override
        public int run(String... args) {
            Quarkus.waitForExit();
            return 0;
        }
    }

    public static void setDataBaseProperties() {
        AuroraDBSecretVO auroraSecretVO = TasksUtils.getAuroraDBSecretVO();
        if (Objects.isNull(auroraSecretVO)) {
            LOGGER.warn("HIPERIUM_CITY_TASKS_DB_CLUSTER_SECRET environment variable not found.");
            LOGGER.warn("Using the defined configuration properties for Datasource connection.");
        } else {
            String sqlConnection = MessageFormat.format(SQL_CONNECTION, auroraSecretVO.getHost(),
                    auroraSecretVO.getPort(), auroraSecretVO.getDbname());
            LOGGER.debug("Setting SQL Connection from Environment Variable: " + sqlConnection);
            System.setProperty("quarkus.datasource.jdbc.url", sqlConnection);
            System.setProperty("quarkus.datasource.username", auroraSecretVO.getUsername());
            System.setProperty("quarkus.datasource.password", auroraSecretVO.getPassword());
        }
    }

    public static void setTimeZoneProperties() {
        String timeZoneId = System.getenv("TIME_ZONE_ID");
        if (Objects.nonNull(timeZoneId) && !timeZoneId.isBlank()) {
            LOGGER.debug("Setting Time Zone ID from Environment Variable: " + timeZoneId);
            System.setProperty("time.zone.id", timeZoneId);
        }
    }
}
