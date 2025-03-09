/**
 * @description       :
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/08
 * @last modified by  : Wesley Prado (wesleyprado.dev@gmail.com)
 **/
public without sharing class SOAPRequestExample implements NumbersInWordsCallable {
	private static final String ENDPOINT = 'https://www.dataaccess.com/webservicesserver/numberconversion.wso';
	private static final String SOAP_NS = 'http://schemas.xmlsoap.org/soap/envelope/';
	private static final String SERVICE_NS = 'http://www.dataaccess.com/webservicesserver/';
	
	private String numberValue = '';

	public SOAPRequestExample() {
	}


	public NumbersInWordsCallable setNumber(String numberValue) {
		this.numberValue = numberValue;
		return this;
	}

	public String sendRequest() {
		HttpRequest req = new HttpRequest();
		req.setEndpoint(ENDPOINT);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'text/xml; charset=utf-8');
		req.setBodyDocument(createXMLDocument());

		return getResponseFromXML(new Http().send(req));
	}

	public DOM.Document createXMLDocument() {
		DOM.Document doc = new DOM.Document();
		DOM.XmlNode envelope = doc.createRootElement(
			'Envelope',
			SOAP_NS,
			'soapenv'
		);
		DOM.XmlNode body = envelope.addChildElement('Body', SOAP_NS, null);
		body.addChildElement('NumberToWords', SERVICE_NS, null)
			.addChildElement('ubiNum', SERVICE_NS, null)
			.addTextNode(numberValue);

		return doc;
	}

	private String getResponseFromXML(HttpResponse res) {
		DOM.Document doc = res.getBodyDocument();

		System.debug(LoggingLevel.DEBUG, doc.toXmlString());

		DOM.XmlNode envelope = doc.getRootElement();
		DOM.XmlNode body = envelope.getChildElement('Body', SOAP_NS);
		DOM.XmlNode response = body.getChildElement(
			'NumberToWordsResponse',
			SERVICE_NS
		);
		DOM.XmlNode result = response.getChildElement(
			'NumberToWordsResult',
			SERVICE_NS
		);

		return result.getText().trim();
	}
}