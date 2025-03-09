/**
 * @description       : Classe controller para busca de dados de fabricantes de veículos
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/09
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
	public static List<VehicleManufacturerClient.ManufacturerData> getAllManufacturers() {
		try {
			return (List<VehicleManufacturerClient.ManufacturerData>) service.call();
		} catch (VehicleManufacturerClient.ManufacturerServiceException e) {
			throw new AuraHandledException('Failed to retrieve manufacturers');
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}
