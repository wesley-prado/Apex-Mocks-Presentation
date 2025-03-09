/**
 * Cliente para acesso à API de fabricantes de veículos da NHTSA
 * Utilizado para demonstrar técnicas de mock em testes
 */
public class VehicleManufacturerClient implements RESTServiceCallable {
	private static final String ENDPOINT = 'https://vpic.nhtsa.dot.gov/api/vehicles/getallmanufacturers';
	private final Map<String, Object> params = new Map<String, Object>();

	/**
	 * @description Define parâmetros para a chamada
	 * @param params Mapa de parâmetros
	 * @return Instância do cliente
	 */
	public RESTServiceCallable setParams(Map<String, Object> params) {
		// Adiciona todos os parâmetros recebidos ao mapa interno de parâmetros
		this.params.putAll(params);
		return this;
	}

	/**
	 * @description Obtém lista de todos os fabricantes de veículos
	 * @return Lista de fabricantes em formato de wrapper
	 */
	public List<ManufacturerData> call() {
		// Cria uma nova requisição HTTP
		HttpRequest req = new HttpRequest();
		req.setEndpoint(ENDPOINT);
		req.setMethod('GET');

		// Verifica se o formato foi especificado nos parâmetros e o adiciona à URL
		if (params.containsKey('format')) {
			req.setEndpoint(req.getEndpoint() + '?format=' + params.get('format'));
		}

		// Envia a requisição HTTP e obtém a resposta
		HttpResponse res = new Http().send(req);

		// Verifica se a resposta foi bem-sucedida (código 200)
		if (res.getStatusCode() == 200) {
			return parseResponse(res);
		} else {
			// Lança uma exceção caso a requisição falhe
			throw new ManufacturerServiceException(
				'Failed to retrieve manufacturers: ' + res.getStatusCode()
			);
		}
	}

	/**
	 * @description Analisa a resposta HTTP e redireciona para o parser adequado baseado no Content-Type
	 * @param res Resposta HTTP recebida da API
	 * @return Lista de fabricantes processados
	 */
	private List<ManufacturerData> parseResponse(HttpResponse res) {
		// Obtém o tipo de conteúdo da resposta
		String contentType = res.getHeader('Content-Type');

		// Direciona para o método de parsing adequado com base no tipo de conteúdo
		if (contentType.equalsIgnoreCase('application/xml')) {
			return parseXML(res);
		} else if (contentType.equalsIgnoreCase('application/json')) {
			return parseJSON(res);
		}

		// Lança exceção se o tipo de conteúdo não for suportado
		throw new ManufacturerServiceException(
			'Unsupported content type: ' + contentType
		);
	}

	/**
	 * @description Processa a resposta em formato XML e extrai os dados dos fabricantes
	 * @param res Resposta HTTP contendo XML
	 * @return Lista de fabricantes extraídos do XML
	 */
	private List<ManufacturerData> parseXML(HttpResponse res) {
		System.debug(LoggingLevel.INFO, '======= PARSING XML =======');

		// Inicializa a lista de fabricantes
		List<ManufacturerData> manufacturers = new List<ManufacturerData>();

		// Percorre os nós XML que representam os fabricantes
		for (
			Dom.XmlNode manufacturer : res.getBodyDocument()
				.getRootElement()
				.getChildElement('Results', null)
				.getChildElements()
		) {
			// Cria um objeto ManufacturerData para cada fabricante encontrado no XML
			manufacturers.add(
				new ManufacturerData(
					Integer.valueOf(
						manufacturer.getChildElement('Mfr_ID', null).getText()
					),
					manufacturer.getChildElement('Country', null).getText(),
					manufacturer.getChildElement('Mfr_Name', null).getText(),
					manufacturer.getChildElement('Mfr_CommonName', null)?.getText()
				)
			);
		}

		return manufacturers;
	}

	/**
	 * @description Processa a resposta em formato JSON e extrai os dados dos fabricantes
	 * @param res Resposta HTTP contendo JSON
	 * @return Lista de fabricantes extraídos do JSON
	 */
	private List<ManufacturerData> parseJSON(HttpResponse res) {
		System.debug(LoggingLevel.INFO, '======= PARSING JSON =======');

		// Obtém o corpo da resposta
		String responseBody = res.getBody();
		List<ManufacturerData> manufacturers = new List<ManufacturerData>();
		
		// Desserializa a resposta JSON para um mapa de objetos
		Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(
			responseBody
		);
		
		// Percorre cada resultado e cria um objeto ManufacturerData
		for (Object result : (List<Object>) response.get('Results')) {
			Map<String, Object> manufacturer = (Map<String, Object>) result;

			manufacturers.add(
				new ManufacturerData(
					(Integer) manufacturer.get('Mfr_ID'),
					(String) manufacturer.get('Country'),
					(String) manufacturer.get('Mfr_Name'),
					(String) manufacturer.get('Mfr_CommonName')
				)
			);
		}

		return manufacturers;
	}

	/**
	 * @description Classe interna para armazenar os dados de um fabricante
	 */
	public class ManufacturerData {
		public Integer id;
		public String country;
		public String name;
		public String commonName;

		/**
		 * @description Construtor para criar um objeto de dados do fabricante
		 * @param id Identificador numérico do fabricante
		 * @param country País de origem do fabricante
		 * @param name Nome completo do fabricante
		 * @param commonName Nome comum ou abreviado do fabricante (opcional)
		 */
		public ManufacturerData(
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

	/**
	 * @description Classe de exceção personalizada para erros relacionados ao serviço de fabricantes
	 */
	public class ManufacturerServiceException extends Exception {
	}
}