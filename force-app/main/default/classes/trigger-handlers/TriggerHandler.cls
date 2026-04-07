public interface TriggerHandler {
    void beforeInsert();
    void beforeUpdate();
    void afterInsert();
    void afterUpdate();
    void beforeDelete();
    void afterDelete();
    void afterUndelete();
}