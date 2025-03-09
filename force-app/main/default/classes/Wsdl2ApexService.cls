/**
 * @description       : Classe de serviço que implementa a interface NumbersInWordsCallable e utiliza o
 * webservice NumberConversionSoap para converter números em palavras.
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/09
 * @last modified by  : Wesley Prado (wesleyprado.dev@gmail.com)
 **/
public without sharing class Wsdl2ApexService implements NumbersInWordsCallable {
	private final wwwDataaccessComWebservicesserver.NumberConversionSoap service = new wwwDataaccessComWebservicesserver.NumberConversionSoap();
	private Long numberValue = 0L;

	/**
	 * @description Construtor padrão da classe
	 */
	public Wsdl2ApexService() {
	}

	/**
	 * @description Define o número a ser convertido em palavras
	 * @param numberValue String contendo o número a ser convertido
	 * @return Instance da própria classe para permitir encadeamento de métodos
	 */
	public NumbersInWordsCallable setNumber(String numberValue) {
		this.numberValue = Long.valueOf(numberValue);
		return this;
	}

	/**
	 * @description Envia a requisição para o webservice e retorna o número convertido em palavras
	 * @return String contendo o número convertido em palavras
	 */
	public String sendRequest() {
		return service.NumberToWords(numberValue).trim();
	}
}