public without sharing virtual class TriggerHandler {

    //constants
    public static String TYPE_AFTER_DELETE = 'afterDelete';
    public static String TYPE_AFTER_UPDATE = 'afterUpdate';
    public static String TYPE_AFTER_INSERT = 'afterInsert';
    public static String TYPE_BEFORE_UPDATE = 'beforeUpdate';
    public static String TYPE_BEFORE_INSERT = 'beforeInsert';

    // static map of handlername, times run() was invoked
    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;

    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
    }

    public TriggerHandler() {
    }

    public String ObjectName;

    // main method that will be called during execution
    public void run() {

        if(!validateRun()) return;

        addToLoopCount();

        // dispatch to the correct handler method
        if(Trigger.isBefore && Trigger.isInsert) {
            this.beforeInsert();
        } else if(Trigger.isBefore && Trigger.isUpdate) {
            this.beforeUpdate();
        } else if(Trigger.isBefore && Trigger.isDelete) {
            this.beforeDelete();
        } else if(Trigger.isAfter && Trigger.isInsert) {
            this.afterInsert();
        } else if(Trigger.isAfter && Trigger.isUpdate) {
            this.afterUpdate();
        } else if(Trigger.isAfter && Trigger.isDelete) {
            this.afterDelete();
        } else if(Trigger.isAfter && Trigger.isUndelete) {
            this.afterUndelete();
        }

    }

    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if(!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }

    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }

    public static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }

    /***************************************
    * private methods
    ***************************************/

    private void addToLoopCount() {
        String handlerName = getHandlerName();
        if(TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
            if(exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }

    private void logTriggerRecords(String title, List<SObject> records) {
        if (records == null || records.isEmpty()) return;

        for (SObject record : records) {
            System.debug(LoggingLevel.ERROR, title + Pattern.compile('(.{299})').matcher(JSON.serialize(record)).replaceAll('$1\n'));
        }
    }

    // make sure this trigger should continue to run
    private Boolean validateRun() {
        if(!Trigger.isExecuting) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        if(TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
            return false;
        }
        return true;
    }

    private String getHandlerName() {
        return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    }

    /***************************************
    * context methods
    ***************************************/

    // context-specific methods for override
    protected virtual void beforeInsert(){}
    protected virtual void beforeUpdate(){}
    protected virtual void beforeDelete(){}
    protected virtual void afterInsert(){}
    protected virtual void afterUpdate(){}
    protected virtual void afterDelete(){}
    protected virtual void afterUndelete(){}

    /***************************************
    * inner classes
    ***************************************/

    // inner class for managing the loop count per handler
    private class LoopCount {
        private Integer max;
        private Integer count;

        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }

        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }

        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }

        public Boolean exceeded() {
            if(this.max < 0) return false;
            if(this.count > this.max) {
                return true;
            }
            return false;
        }

        public Integer getMax() {
            return this.max;
        }

        public Integer getCount() {
            return this.count;
        }

        public void setMax(Integer max) {
            this.max = max;
        }
    }

    // exception class
    public class TriggerHandlerException extends Exception {}
}