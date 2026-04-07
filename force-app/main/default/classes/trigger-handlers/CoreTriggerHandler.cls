public abstract class CoreTriggerHandler implements TriggerHandler {
    public void run() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) beforeInsert();
            if (Trigger.isUpdate) beforeUpdate();
            if (Trigger.isDelete) beforeDelete();
        }
        if (Trigger.isAfter) {
            if (Trigger.isInsert) afterInsert();
            if (Trigger.isUpdate) afterUpdate();
            if (Trigger.isDelete) afterDelete();
            if (Trigger.isUndelete) afterUndelete();
        }
    }

    public virtual void beforeInsert() {}
    public virtual void beforeUpdate() {}
    public virtual void afterInsert() {}
    public virtual void afterUpdate() {}
    public virtual void beforeDelete() {}
    public virtual void afterDelete() {}
    public virtual void afterUndelete() {}
}