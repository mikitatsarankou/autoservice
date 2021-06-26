public class DailyCurrencyJob implements Schedulable {

    public void execute(SchedulableContext SC) {
        CurrencyService.getCurRate();
    }
}