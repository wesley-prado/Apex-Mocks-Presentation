/**
 * Cliente para acesso à API de fabricantes de veículos da NHTSA
 * Utilizado para demonstrar técnicas de mock em testes
 */
public class VehicleManufacturerClient implements RESTServiceCallable {
	private static final String ENDPOINT = 'callout:Vechile_Manufacturer_Credentials/getallmanufacturers';
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
	public List<ManufacturerDTO> call() {
		// Cria uma nova requisição HTTP
		HttpRequest req = new HttpRequest();
		req.setEndpoint(ENDPOINT);
		req.setMethod('GET');
		HttpResponse res;

		// Verifica se o formato foi especificado nos parâmetros e o adiciona à URL
		if (params.containsKey('format')) {
			req.setEndpoint(req.getEndpoint() + '?format=' + params.get('format'));
		}

		try {
			// Envia a requisição HTTP e obtém a resposta
			res = new Http().send(req);
		} catch (CalloutException e) {
			// Lança uma exceção personalizada em caso de falha na requisição
			throw new ManufacturerServiceException(
				'Failed to retrieve manufacturers: ' + e.getMessage()
			);
		}

		// Verifica se a resposta foi bem-sucedida (código 200)
		if (res.getStatusCode() == 200) {
			return parseResponse(res);
		}

		// Lança uma exceção caso a requisição falhe
		throw new ManufacturerServiceException(
			'Failed to retrieve manufacturers: ' +
				res.getStatusCode() +
				' ' +
				res.getBody()
		);
	}

	/**
	 * @description Analisa a resposta HTTP e redireciona para o parser adequado baseado no Content-Type
	 * @param res Resposta HTTP recebida da API
	 * @return Lista de fabricantes processados
	 */
	private List<ManufacturerDTO> parseResponse(HttpResponse res) {
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
	private List<ManufacturerDTO> parseXML(HttpResponse res) {
		System.debug(LoggingLevel.INFO, '======= PARSING XML =======');

		// Inicializa a lista de fabricantes
		List<ManufacturerDTO> manufacturers = new List<ManufacturerDTO>();

		// Percorre os nós XML que representam os fabricantes
		for (
			Dom.XmlNode manufacturer : res.getBodyDocument()
				.getRootElement()
				.getChildElement('Results', null)
				.getChildElements()
		) {
			// Cria um objeto ManufacturerDTO para cada fabricante encontrado no XML
			manufacturers.add(
				new ManufacturerDTO(
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
	private List<ManufacturerDTO> parseJSON(HttpResponse res) {
		System.debug(LoggingLevel.INFO, '======= PARSING JSON =======');

		// Obtém o corpo da resposta
		String responseBody = res.getBody();
		List<ManufacturerDTO> manufacturers = new List<ManufacturerDTO>();

		// Desserializa a resposta JSON para um mapa de objetos
		Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(
			responseBody
		);

		// Percorre cada resultado e cria um objeto ManufacturerDTO
		for (Object result : (List<Object>) response.get('Results')) {
			Map<String, Object> manufacturer = (Map<String, Object>) result;

			manufacturers.add(
				new ManufacturerDTO(
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
	 * @description Classe de exceção personalizada para erros relacionados ao serviço de fabricantes
	 */
	public class ManufacturerServiceException extends Exception {
	}
}
