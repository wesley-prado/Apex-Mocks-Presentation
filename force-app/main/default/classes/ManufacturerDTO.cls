/**
 * @description Classe interna para armazenar os dados de um fabricante
 */
public without sharing class ManufacturerDTO {
	public ManufacturerDTO() {
	}

	@AuraEnabled
	public Integer id;
	@AuraEnabled
	public String country;
	@AuraEnabled
	public String name;
	@AuraEnabled
	public String commonName;

	/**
	 * @description Construtor para criar um objeto de dados do fabricante
	 * @param id Identificador numérico do fabricante
	 * @param country País de origem do fabricante
	 * @param name Nome completo do fabricante
	 * @param commonName Nome comum ou abreviado do fabricante (opcional)
	 */
	public ManufacturerDTO(
		Integer id,
		String country,
		String name,
		String commonName
	) {
		this.id = id;
		this.country = country;
		this.name = name;
		this.commonName = commonName;
	}
}
