# Projeto de Demonstração de Mocks e Injeção de Dependência em Salesforce

## Visão Geral

Este projeto demonstra técnicas avançadas de testes em Salesforce, com foco em mocks e injeção de dependência. Os exemplos práticos mostram como criar testes unitários para integrações externas e componentes que dependem de chamadas de API.

## Conteúdo do Projeto

### Interfaces e Classes de Mock

O projeto apresenta exemplos e explicações sobre as seguintes interfaces e classes para teste:

- **WebServiceMock**: Para simular chamadas a web services SOAP
- **HttpCalloutMock**: Para simular chamadas HTTP REST
- **StaticResourceCalloutMock**: Para utilizar recursos estáticos como respostas simuladas
- **MultiStaticResourceCalloutMock**: Para simular múltiplas chamadas usando diferentes recursos estáticos
- **StubProvider**: Para criar implementações dinâmicas de interfaces

### Componente LWC de Demonstração

Um componente Lightning Web Component que demonstra como testar cenários com Named Credentials:

- Testes com Named Credentials ativados
- Testes com Named Credentials desativados
- Estratégias para simular diferentes respostas

## Como Usar Este Projeto

1. Clone este repositório para sua organização Salesforce (via SFDX)
2. Examine as classes de exemplo na pasta `classes`
3. Analise os testes correspondentes para ver como implementar mocks
4. Experimente o componente LWC na pasta `lwc`
5. Opcionalmente, instale todos os componentes do projeto na ORG para executar os testes

## Benefícios

- Isolamento de testes para integrações externas
- Aumento da cobertura de código sem dependências externas
- Testes mais rápidos e determinísticos
- Padrões para código mais manutenível e testável

## Pré-requisitos

- Conhecimento básico de Apex e testes unitários
- Familiaridade com LWC (para os exemplos de componentes)
- Organização Salesforce (Developer Edition, Sandbox ou Scratch Org) para instalar as dependências

## Exemplos Incluídos

- Simulação de respostas SOAP usando WebServiceMock
- Mock de API REST externa usando HttpCalloutMock
- Uso de recursos estáticos para simular payloads de resposta
- Implementação de StubProvider
- Componente LWC que se adaptam com base na disponibilidade de Named Credentials

## Contribuições

Sinta-se à vontade para contribuir com exemplos adicionais, melhorias ou correções. Abra um Pull Request ou uma Issue para discussão.
