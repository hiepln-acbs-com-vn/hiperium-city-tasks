package com.hiperium.city.timer.api.utils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.vo.AuroraDBSecretVO;
import org.jboss.logging.Logger;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Objects;
import java.util.UUID;

/**
 * @author Andres Solorzano
 */
public final class TasksUtils {

    private static final Logger LOGGER = Logger.getLogger(TasksUtils.class.getName());
    private static final char[] hexArray = "HiperiumTasksService".toCharArray();

    private TasksUtils() {
    }

    public static AuroraDBSecretVO getAuroraDBSecretVO() {
        String auroraSecret = System.getenv("HIPERIUM_CITY_TASKS_DB_CLUSTER_SECRET");
        if (Objects.isNull(auroraSecret) || auroraSecret.isBlank()) {
            return null;
        }
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.readValue(auroraSecret, AuroraDBSecretVO.class);
        } catch (JsonProcessingException e) {
            LOGGER.error("Error to parsing JSON to Java object: " + e.getMessage());
            return null;
        }
    }

    public static void copyMutableProperties(Task source, Task target) {
        LOGGER.debug("copyMutableProperties() - BEGIN");
        // target.setId(source.getId());                    Must not be overwritten.
        // target.setCreatedAt(source.getCreatedAt());      Must not be overwritten.
        target.setName(source.getName());
        target.setJobId(source.getJobId());                 // Could be updated by a new Quartz Job.
        target.setDescription(source.getDescription());
        target.setHour(source.getHour());
        target.setMinute(source.getMinute());
        target.setExecutionDays(source.getExecutionDays());
        target.setExecutionCommand(source.getExecutionCommand());
        target.setExecuteUntil(source.getExecuteUntil());
        target.setUpdatedAt(source.getUpdatedAt());
        LOGGER.debug("copyMutableProperties() - END");
    }

    public static String generateUUID(int maxLength) {
        MessageDigest salt;
        try {
            salt = MessageDigest.getInstance("SHA-256");
            salt.update(UUID.randomUUID().toString().getBytes(StandardCharsets.UTF_8));
        } catch (NoSuchAlgorithmException e) {
            throw new UnsupportedOperationException(e.getMessage());
        }
        String uuid = bytesToHex(salt.digest());
        return maxLength > 0 ? uuid.substring(0, maxLength) : uuid;
    }

    private static String bytesToHex(byte[] bytes) {
        char[] hexChars = new char[bytes.length * 2];
        for (int j = 0; j < bytes.length; j++) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }
}
