/**
 * @description       :
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/08
 * @last modified by  : Wesley Prado (wesleyprado.dev@gmail.com)
 **/
@IsTest
public without sharing class NumbersInWordsControllerTest {
	/*
	 * StaticResourceCalloutMock: Trabalha diretamente com HTTP simulando corpo, status e cabeçalhos
	 * WebServiceMock: Trabalha no nível de objetos de resposta gerados pelo WSDL2Apex
	 */

	// Sucesso
	@IsTest
	static void convertNumberToWords1_WithStaticResourceCalloutMock() {
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('xml_numbers_in_words_response_example');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'text/xml; charset=utf-8');
		Test.setMock(HttpCalloutMock.class, mock);

		Test.startTest();
		String numberValue = '123';
		String expected = 'one hundred and twenty three';
		String actual = NumbersInWordsController.convertNumberToWords1(numberValue);
		Assert.areEqual(expected, actual);
		Test.stopTest();
	}

	// Falha - Methods defined as TestMethod do not support Web service callouts
	@IsTest
	static void convertNumberToWords1_WithWebServiceMock1() {
		Test.setMock(WebServiceMock.class, new NumbersInWordsSOAPRequestMock1());

		Test.startTest();
		String numberValue = '123';
		String expected = 'one hundred and twenty three';
		String actual = NumbersInWordsController.convertNumberToWords1(numberValue);
		Assert.areEqual(expected, actual);
		Test.stopTest();
	}

	// Falha - Methods defined as TestMethod do not support Web service callouts
	@IsTest
	static void convertNumberToWords1_WithWebServiceMock2() {
		Test.setMock(WebServiceMock.class, new NumbersInWordsSOAPRequestMock2());

		Test.startTest();
		String numberValue = '123';
		String expected = 'one hundred and twenty three';
		String actual = NumbersInWordsController.convertNumberToWords1(numberValue);
		Assert.areEqual(expected, actual);
		Test.stopTest();
	}

	// Sucesso
	@IsTest
	static void convertNumberToWords2_WithStaticResourceCalloutMock() {
		Test.setMock(WebServiceMock.class, new NumbersInWordsSOAPRequestMock1());

		Test.startTest();
		String numberValue = '123';
		String expected = 'one hundred and twenty three';
		String actual = NumbersInWordsController.convertNumberToWords2(numberValue);
		Assert.areEqual(expected, actual);
		Test.stopTest();
	}

	// Sucesso
	@IsTest
	static void convertNumberToWords2_WithWebServiceMock() {
		Test.setMock(WebServiceMock.class, new NumbersInWordsSOAPRequestMock1());

		Test.startTest();
		String numberValue = '123';
		String expected = 'one hundred and twenty three';
		String actual = NumbersInWordsController.convertNumberToWords2(numberValue);
		Assert.areEqual(expected, actual);
		Test.stopTest();
	}

	private class NumbersInWordsSOAPRequestMock1 implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType
		) {
			// Configuração do objeto de resposta específico do serviço
			wwwDataaccessComWebservicesserver.NumberToWordsResponse_element response_x = new wwwDataaccessComWebservicesserver.NumberToWordsResponse_element();
			response_x.NumberToWordsResult = 'one hundred and twenty three ';

			response.put('response_x', response_x);
		}
	}
	private class NumbersInWordsSOAPRequestMock2 implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType
		) {
			String r =
				'<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
				'<soap:Body>' +
				'<m:NumberToWordsResponse xmlns:m="http://www.dataaccess.com/webservicesserver/">' +
				'<m:NumberToWordsResult>one hundred and twenty three </m:NumberToWordsResult>' +
				'</m:NumberToWordsResponse>' +
				'</soap:Body>' +
				'</soap:Envelope>';

			response.put('response_x', r);
		}
	}
}