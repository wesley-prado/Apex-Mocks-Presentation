/**
 * @description       : Interface para classes de serviço REST que podem ser chamadas para executar uma requisição
 * @author            : Wesley Prado (wesleyprado.dev@gmail.com)
 * @last modified on  : 2025/03/09
 * @last modified by  : Wesley Prado (wesleyprado.dev@gmail.com)
**/
public interface RESTServiceCallable {
	RESTServiceCallable setParams(Map<String, String> params);
	Object call();
}