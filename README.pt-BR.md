# KipuBank - Trabalho de Conclusão do Módulo 4 EDP/ETH Kipu

Bem-vindo ao repositório do **KipuBank**, projeto desenvolvido como **Trabalho de Conclusão do Módulo 4** do **Ethereum Developer Pack da ETH Kipu**.  
Este projeto tem como objetivo implementar ajustes necessários no contrato inteligente `KipuBank` (criado no Módulo 2) e praticar a realização de testes utilizando o framework **Foundry**, com integração ao Scaffold-ETH 2.

- Contrato original (Módulo 2): https://sepolia.etherscan.io/address/0x976A85AbfA7F0D5F5Ea13B5e6143c83f7bF25336#code  
- Contrato atual (Módulo 4): https://sepolia.etherscan.io/address/0xfb110c367b306ce2d381fc194ab6b2914f854728#code

---

## 📋 Descrição do Projeto

O KipuBank é um contrato inteligente em Solidity que simula um banco descentralizado, permitindo que usuários realizem depósitos e saques com limites pré-definidos.  
Este projeto foca em:

- **Ajustes no contrato original**: Melhorias na lógica e segurança.  
- **Testes automatizados**: Utilização do Foundry para garantir a robustez do contrato.  
- **Integração com Scaffold-ETH 2**: Implementação de uma interface interativa para interação com os contratos.

---
## 🌍 Available Languages

- 🇺🇸 [English](README.md)
- 🇧🇷 [Português Brasileiro](README.pt-BR.md)

## 🛠️ Funcionalidades Principais

### Depósitos:
- Usuários podem depositar valores em ETH no contrato.  
- O valor total depositado não pode exceder o limite (`i_WeiBankCap`).

### Saques:
- Usuários podem sacar valores dentro do limite permitido (`MAX_WEI_WITHDRAWAL`).  
- O saldo do usuário deve ser suficiente para realizar o saque.

### Eventos:
- Emissão de eventos para rastrear depósitos e saques (`KipuBank_Deposit`, `KipuBank_Withdrawal`).

### Segurança:
- Uso de erros personalizados para validação.  
- Prevenção contra ataques de reentrância.

### Interface Interativa:
- Utilizando o Scaffold-ETH 2, o projeto inclui uma interface Next.js que permite interação direta com os contratos inteligentes.

---

## 🧪 Testes Automatizados

Os testes foram escritos utilizando o framework Foundry, garantindo que todas as funcionalidades do contrato sejam verificadas adequadamente.

**Principais Testes Implementados (`/packages/foundry/test/KipuBank.t.sol`)**
- `testDeposit`: Verifica se depósitos válidos são processados corretamente.  
- `testWithdrawOK`: Valida saques dentro do limite permitido.  
- `testRevert_WithdrawInsufficientBalance`: Garante que saques com saldo insuficiente revertam.  
- `testRevert_ExceedsBankCap`: Testa a tentativa de depósito acima do limite do banco.  
- `testMultipleDeposits`: Simula múltiplos depósitos de diferentes usuários.

---

## ✅ Como Executar os Testes

Certifique-se de ter o **Foundry** instalado:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Execute os testes:

```bash
forge test -vvv
```

---

## 🚀 Como Configurar o Projeto

### Pré-requisitos:
- Node.js (v18+)  
- Foundry instalado  
- Scaffold-ETH 2 configurado  
- Git configurado

### Passos para Configuração:

Clone este repositório:

```bash
git clone https://github.com/seu-usuario/kipubank-modulo4.git
cd kipubank-modulo4
```

Instale as dependências necessárias:

```bash
yarn install
```

Compile os contratos:

```bash
forge build
```

Inicie a blockchain local:

```bash
yarn chain
```

Implante os contratos na rede local:

```bash
yarn deploy
```

Inicie a interface Next.js:

```bash
yarn start
```

---

## 📂 Estrutura do Projeto

```
kipubank/
├── packages/
│   ├── foundry/
│   │   ├── contract/          # Contratos inteligentes (ex.: KipuBank.sol)
│   │   ├── test/              # Testes automatizados com Foundry (ex.: KipuBank.t.sol)
│   │   ├── script/            # Scripts de deploy (ex.: DeployKipuBank.s.sol)
│   │   └── foundry.toml       # Configuração do Foundry
│   ├── nextjs/                # Interface frontend baseada em Next.js
README.pt-BR.md                # Documentação do projeto (este arquivo)
```

---

## 📚 Referências

- [Ethereum Developer Pack - ETH Kipu](https://www.ethkipu.com/)
- [Documentação do Foundry](https://github.com/gobble/foundry)
- [Documentação Scaffold-ETH 2](https://github.com/scaffold-eth/scaffold-eth)
- [Documentação Solidity](https://soliditylang.org/docs/)

---

## 🏆 Sobre o Projeto

Este trabalho foi desenvolvido como parte do curso **Ethereum Developer Pack da ETH Kipu**, com foco em capacitar desenvolvedores para criar e testar contratos inteligentes robustos na blockchain Ethereum, além de integrar contratos inteligentes a interfaces modernas utilizando o **Scaffold-ETH 2**.

Se tiver dúvidas ou sugestões, sinta-se à vontade para abrir uma issue neste repositório!