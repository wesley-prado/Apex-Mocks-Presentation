/**
 * @description       : Classe de teste para a classe VehicleManufacturerClient
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/11
 * @last modified by  : Wesley Prado (wesleyprado.dev@gmail.com)
 **/

@IsTest
private class VehicleManufacturerClientTest {
	private static final String JSON_RESPONSE =
		'{"Results":[' +
		'{"Mfr_ID":987,"Country":"UNITED STATES (USA)","Mfr_Name":"TESLA, INC.","Mfr_CommonName":"TESLA"},' +
		'{"Mfr_ID":956,"Country":"GERMANY","Mfr_Name":"VOLKSWAGEN AG","Mfr_CommonName":"VOLKSWAGEN"}' +
		'],"Count":2,"Message":"Results returned successfully"}';
	private static final String XML_RESPONSE =
		'<?xml version="1.0" encoding="UTF-8"?>' +
		'<Response>' +
		'  <Results>' +
		'    <Result>' +
		'      <Mfr_ID>987</Mfr_ID>' +
		'      <Country>UNITED STATES (USA)</Country>' +
		'      <Mfr_Name>TESLA, INC.</Mfr_Name>' +
		'      <Mfr_CommonName>TESLA</Mfr_CommonName>' +
		'    </Result>' +
		'    <Result>' +
		'      <Mfr_ID>956</Mfr_ID>' +
		'      <Country>GERMANY</Country>' +
		'      <Mfr_Name>VOLKSWAGEN AG</Mfr_Name>' +
		'      <Mfr_CommonName>VOLKSWAGEN</Mfr_CommonName>' +
		'    </Result>' +
		'  </Results>' +
		'  <Count>2</Count>' +
		'  <Message>Results returned successfully</Message>' +
		'</Response>';
	@IsTest
	static void testSuccessfulJSONResponse() {
		// Configura o mock para retornar uma resposta JSON válida
		Test.setMock(HttpCalloutMock.class, new ManufacturerJSONMock());

		// Instancia o cliente e configura os parâmetros
		VehicleManufacturerClient client = new VehicleManufacturerClient();
		client.setParams(new Map<String, Object>{ 'format' => 'json' });

		// Executa o método a ser testado
		Test.startTest();
		List<VehicleManufacturerClient.ManufacturerData> result = client.call();
		Test.stopTest();

		// Verifica os resultados
		Assert.isNotNull(result, 'A lista de resultados não deve ser nula');
		Assert.areEqual(2, result.size(), 'Deveria retornar 2 fabricantes');
		Assert.areEqual(
			'TESLA, INC.',
			result[0].name,
			'O nome comum do segundo fabricante deve ser TESLA, INC.'
		);
		Assert.areEqual(
			'TESLA',
			result[0].commonName,
			'O nome comum do primeiro fabricante deve ser TESLA'
		);
		Assert.areEqual(
			987,
			result[0].id,
			'O ID do primeiro fabricante deve ser 987'
		);
		Assert.areEqual(
			'UNITED STATES (USA)',
			result[0].country,
			'O país deve estar correto'
		);
	}

	@IsTest
	static void testSuccessfulXMLResponse() {
		// Configura o mock para retornar uma resposta XML válida
		Test.setMock(HttpCalloutMock.class, new ManufacturerXMLMock());

		// Instancia o cliente
		VehicleManufacturerClient client = new VehicleManufacturerClient();

		// Executa o método a ser testado
		Test.startTest();
		List<VehicleManufacturerClient.ManufacturerData> result = client.call();
		Test.stopTest();

		// Verifica os resultados
		Assert.isNotNull(result, 'A lista de resultados não deve ser nula');
		Assert.areEqual(2, result.size(), 'Deveria retornar 2 fabricantes');
		Assert.areEqual(
			'VOLKSWAGEN AG',
			result[1].name,
			'O nome comum do primeiro fabricante deve ser TESLA'
		);
		Assert.areEqual(
			'VOLKSWAGEN',
			result[1].commonName,
			'O nome comum do primeiro fabricante deve ser VOLKSWAGEN'
		);
		Assert.areEqual(
			956,
			result[1].id,
			'O ID do primeiro fabricante deve ser 956'
		);
		Assert.areEqual('GERMANY', result[1].country, 'O país deve estar correto');
	}

	@IsTest
	static void testErrorResponse() {
		// Configura o mock para retornar erro 500
		Test.setMock(HttpCalloutMock.class, new ErrorResponseMock());

		// Instancia o cliente
		VehicleManufacturerClient client = new VehicleManufacturerClient();

		// Executa o método a ser testado e verifica que uma exceção foi lançada
		Test.startTest();
		try {
			client.call();
			Assert.fail('Deveria ter lançado uma exceção');
		} catch (Exception e) {
			Assert.isInstanceOfType(
				e,
				VehicleManufacturerClient.ManufacturerServiceException.class,
				'Deveria ser uma exceção do tipo ManufacturerServiceException'
			);
			Assert.isTrue(
				e.getMessage().contains('500'),
				'A mensagem de erro deve conter o código de status 500'
			);
		}
		Test.stopTest();
	}

	@IsTest
	static void testUnsupportedContentType() {
		// Configura o mock para retornar um tipo de conteúdo não suportado
		Test.setMock(HttpCalloutMock.class, new UnsupportedContentTypeMock());

		// Instancia o cliente
		VehicleManufacturerClient client = new VehicleManufacturerClient();

		// Executa o método a ser testado e verifica que uma exceção foi lançada
		Test.startTest();
		try {
			client.call();
			Assert.fail('Deveria ter lançado uma exceção');
		} catch (VehicleManufacturerClient.ManufacturerServiceException e) {
			Assert.isTrue(
				e.getMessage().contains('Unsupported content type'),
				'A mensagem de erro deve indicar que o tipo de conteúdo não é suportado'
			);
		}
		Test.stopTest();
	}

	// Classes mock para simular diferentes tipos de resposta

	private class ManufacturerJSONMock implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest req) {
			HttpResponse res = new HttpResponse();
			res.setStatusCode(200);
			res.setHeader('Content-Type', 'application/json');
			res.setBody(JSON_RESPONSE);
			return res;
		}
	}

	private class ManufacturerXMLMock implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest req) {
			HttpResponse res = new HttpResponse();
			res.setStatusCode(200);
			res.setHeader('Content-Type', 'application/xml');
			res.setBody(XML_RESPONSE);
			return res;
		}
	}

	private class ErrorResponseMock implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest req) {
			HttpResponse res = new HttpResponse();
			res.setStatusCode(500);
			res.setStatus('Internal Server Error');
			res.setBody('{"error": "Server error occurred"}');
			return res;
		}
	}

	private class UnsupportedContentTypeMock implements HttpCalloutMock {
		public HttpResponse respond(HttpRequest req) {
			HttpResponse res = new HttpResponse();
			res.setStatusCode(200);
			res.setHeader('Content-Type', 'text/plain');
			res.setBody('Raw text data that is not supported');
			return res;
		}
	}

	@IsTest
	static void testMultipleEndpoints() {
		// Criar o mock para múltiplos endpoints
		MultiEndpointMock mock = new MultiEndpointMock();

		// Configurar resposta para endpoint de fabricantes no formato JSON
		mock.addResponse(
			'callout:Vechile_Manufacturer_Credentials/getallmanufacturers?format=json',
			200,
			'application/json',
			JSON_RESPONSE
		);

		// Configurar resposta para endpoint de fabricantes no formato XML
		mock.addResponse(
			'callout:Vechile_Manufacturer_Credentials/getallmanufacturers',
			200,
			'application/xml',
			XML_RESPONSE
		);

		// Configurar resposta para endpoint inválido
		mock.addResponse(
			'callout:Vechile_Manufacturer_Credentials/getallmanufacturers?format=invalid',
			500,
			'application/xml',
			''
		);

		Test.setMock(HttpCalloutMock.class, mock);

		VehicleManufacturerClient client = new VehicleManufacturerClient();

		// Testar o endpoint JSON
		client.setParams(new Map<String, Object>{ 'format' => 'json' });
		List<VehicleManufacturerClient.ManufacturerData> jsonResult = client.call();

		// Reconfigurar cliente para testar endpoint XML
		client = new VehicleManufacturerClient();
		List<VehicleManufacturerClient.ManufacturerData> xmlResult = client.call();

		Assert.isNotNull(
			jsonResult,
			'A lista de resultados JSON não deve ser nula'
		);
		Assert.isNotNull(xmlResult, 'A lista de resultados XML não deve ser nula');
		Assert.areEqual(
			2,
			jsonResult.size(),
			'Deveria retornar 2 fabricantes no JSON'
		);
		Assert.areEqual(
			2,
			xmlResult.size(),
			'Deveria retornar 2 fabricantes no XML'
		);

		try {
			client = new VehicleManufacturerClient();
			client.setParams(new Map<String, Object>{ 'format' => 'invalid' });
			client.call();
			Assert.fail('Deveria ter lançado uma exceção');
		} catch (VehicleManufacturerClient.ManufacturerServiceException e) {
			Assert.isTrue(
				e.getMessage().contains('500'),
				'A mensagem de erro deve conter o código de status 500'
			);
		}
	}

	// Mock para simular múltiplos endpoints semelhante ao MultiStaticResourceCalloutMock
	public class MultiEndpointMock implements HttpCalloutMock {
		// Mapa associando endpoints a respostas
		private Map<String, HttpResponse> endpointResponses;

		public MultiEndpointMock() {
			this.endpointResponses = new Map<String, HttpResponse>();
		}

		/**
		 * Adiciona uma resposta pré-configurada para um endpoint específico
		 */
		public void addResponse(String endpoint, HttpResponse response) {
			this.endpointResponses.put(endpoint, response);
		}

		/**
		 * Método auxiliar para adicionar rapidamente uma resposta com parâmetros comuns
		 */
		public void addResponse(
			String endpoint,
			Integer statusCode,
			String contentType,
			String body
		) {
			HttpResponse response = new HttpResponse();
			response.setStatusCode(statusCode);
			response.setHeader('Content-Type', contentType);
			response.setBody(body);
			this.endpointResponses.put(endpoint, response);
		}

		/**
		 * Implementação da interface HttpCalloutMock
		 */
		public HttpResponse respond(HttpRequest request) {
			// Verifica se o endpoint solicitado está no mapa
			if (endpointResponses.containsKey(request.getEndpoint())) {
				return endpointResponses.get(request.getEndpoint());
			}

			// Resposta padrão se o endpoint não foi configurado
			HttpResponse defaultResponse = new HttpResponse();
			defaultResponse.setStatusCode(404);
			defaultResponse.setStatus('Not Found');
			defaultResponse.setBody(
				'{"error": "Endpoint not mocked: ' + request.getEndpoint() + '"}'
			);
			return defaultResponse;
		}
	}
}
