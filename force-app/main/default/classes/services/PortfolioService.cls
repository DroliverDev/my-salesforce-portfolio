public without sharing class PortfolioService {
    public class ValidationException extends Exception {}
    public class NotFoundException extends Exception {}

    public static void validateRequired(String value, String fieldName) {
        if (String.isBlank(value)) {
            throw new ValidationException(fieldName + ' is required.');
        }
    }

    public static Id parseId(String value, String fieldName) {
        if (String.isBlank(value)) {
            throw new ValidationException(fieldName + ' is required.');
        }

        try {
            return (Id) value;
        } catch (Exception ex) {
            throw new ValidationException(fieldName + ' is not a valid Salesforce Id.');
        }
    }
}
