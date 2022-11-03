public with sharing class CustomCurrencyManager implements Queueable {

    public void execute(QueueableContext QC) {
        Map<String, SObject> currencyTypeByIsoCode = Utils.mapByStringField(
                CurrencyService.getCurrencies(), 'IsoCode'
        );
        Map<String, SObject> customCurrencyByIsoCode = Utils.mapByStringField(
                CurrencyService.getCustomCurrencies(), 'Iso_Code__c'
        );

        List<Currency__c> customCurrenciesToUpdate = new List<Currency__c>();
        List<Currency__c> customCurrenciesToInsert = new List<Currency__c>();

        for (String currencyTypeIsoCode : currencyTypeByIsoCode.keySet()) {
            if (customCurrencyByIsoCode.containsKey(currencyTypeIsoCode)) {
                CurrencyType currencyType = (CurrencyType) currencyTypeByIsoCode.get(currencyTypeIsoCode);
                Currency__c customCurrencyToUpdate = (Currency__c) customCurrencyByIsoCode.get(currencyTypeIsoCode);

                customCurrencyToUpdate.Conversion_Rate__c = currencyType.ConversionRate;
                customCurrencyToUpdate.IsCorporate__c = currencyType.IsCorporate;

                customCurrenciesToUpdate.add(customCurrencyToUpdate);
            } else {
                CurrencyType currencyType = (CurrencyType) currencyTypeByIsoCode.get(currencyTypeIsoCode);
                Currency__c newCustomCurrencyToInsert = new Currency__c(
                        isAcitve__c = currencyType.IsActive,
                        Iso_Code__c = currencyType.IsoCode,
                        Name = currencyType.IsoCode,
                        CurrencyIsoCode = currencyType.IsoCode,
                        IsCorporate__c = currencyType.IsCorporate,
                        Conversion_Rate__c = currencyType.ConversionRate
                );
                customCurrenciesToInsert.add(newCustomCurrencyToInsert);
            }
        }

        if (customCurrenciesToUpdate.isEmpty() && customCurrenciesToInsert.isEmpty()) {
            return;
        }

        if (!customCurrenciesToUpdate.isEmpty()) {
            update customCurrenciesToUpdate;
        }

        if (!customCurrenciesToInsert.isEmpty()) {
            insert customCurrenciesToInsert;
        }
    }
}