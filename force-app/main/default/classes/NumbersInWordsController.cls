/**
 * @description       :
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/08
 * @last modified by  : Wesley Prado (wesleyprado.dev@gmail.com)
 **/
public without sharing class NumbersInWordsController {
	@TestVisible
	private static NumbersInWordsCallable service1 {
		get {
			if (service1 == null) {
				service1 = new SOAPRequestExample();
			}
			return service1;
		}
		set;
	}

	private static NumbersInWordsCallable service2 = new Wsdl2ApexService();

	@AuraEnabled
	public static String convertNumberToWords1(String numberValue) {
		return service1.setNumber(numberValue).sendRequest();
	}

	@AuraEnabled
	public static String convertNumberToWords2(String numberValue) {
		return service2.setNumber(numberValue).sendRequest();
	}
}