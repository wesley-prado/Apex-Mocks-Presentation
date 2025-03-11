/**
 * @description       : Classe controller para busca de dados de fabricantes de veículos
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/11
 * @last modified by  : Wesley Prado (wesleyprado.dev@gmail.com)
 **/
public without sharing class VehicleManufacturerController {
	@TestVisible
	private static RESTServiceCallable service {
		get {
			if (service == null) {
				service = new VehicleManufacturerClient();
			}
			return service;
		}
		private set;
	}

	@AuraEnabled
	public static List<ManufacturerDTO> getAllManufacturers() {
		try {
			return (List<ManufacturerDTO>) service.call();

			// if(Test.isRunningTest()){
			// 	throw new CalloutException('Failed to retrieve manufacturers');
			// }
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}
