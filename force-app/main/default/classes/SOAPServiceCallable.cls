/**
 * Interface para serviços que realizam chamadas SOAP
 */
public interface SOAPServiceCallable {
	SOAPServiceCallable setEndpoint(String endpoint);
	String sendRequest();
}