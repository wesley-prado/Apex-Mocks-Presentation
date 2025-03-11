/**
 * @description       : Classe de teste para VehicleManufacturerController
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/11
 * @last modified by  : Wesley Prado (wesleyprado.dev@gmail.com)
 **/
@IsTest
private class VehicleManufacturerControllerTest {
	// Testa o cenário de erro ao buscar os fabricantes
	@IsTest
	static void getAllManufacturersErrorTest() {
		// Mock do serviço de busca de fabricantes
		Stub serviceMock = new Stub(RESTServiceCallable.class);
		// Configura o mock para lançar uma exceção
		serviceMock.setException(
			'call',
			new CalloutException('Failed to retrieve manufacturers')
		);

		// Substitui o serviço padrão pelo mock
		VehicleManufacturerController.service = (RESTServiceCallable) serviceMock.instance;

		Test.startTest();
		try {
			// Chama o método que deverá lançar uma exceção
			VehicleManufacturerController.getAllManufacturers();

			// Se não lançar exceção, falha o teste
			Assert.fail('Era esperada uma exceção');
		} catch (Exception e) {
			// Não é possível capturar a mensagem de erro via Apex =´(
			Assert.isInstanceOfType(e, AuraHandledException.class);
		}
		Test.stopTest();
	}

	// Testa o cenário de sucesso ao buscar os fabricantes
	@IsTest
	static void getAllManufacturersSuccessTest() {
		Stub serviceMock = new Stub(RESTServiceCallable.class);

		// Configura o mock para retornar um fabricante
		serviceMock.setReturnValue(
			'call',
			new List<ManufacturerDTO>{
				new ManufacturerDTO(1, 'USA', 'Tesla Inc.', 'Tesla')
			}
		);

		VehicleManufacturerController.service = (RESTServiceCallable) serviceMock.instance;

		Test.startTest();
		try {
			// Chama o método que deverá retornar um fabricante
			List<ManufacturerDTO> response = VehicleManufacturerController.getAllManufacturers();

			// Verifica se o fabricante retornado é o esperado
			Assert.areEqual(1, response.size());
			Assert.areEqual(1, response[0].id);
			Assert.areEqual('USA', response[0].country);
			Assert.areEqual('Tesla Inc.', response[0].name);
			Assert.areEqual('Tesla', response[0].commonName);
		} catch (Exception e) {
			Assert.fail('Não era esperada uma exceção');
		}
		Test.stopTest();
	}
}
