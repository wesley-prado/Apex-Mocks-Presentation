/**
 * Interface para serviços que realizam chamadas SOAP
 */
public interface NumbersInWordsCallable {
	NumbersInWordsCallable setNumber(String numberValue);
	String sendRequest();
}