# KipuBank – Final Project of Module 4 EDP/ETH Kipu

Welcome to the **KipuBank** repository, a project developed as the **Final Project of Module 4** of the **Ethereum Developer Pack by ETH Kipu**.  
The goal of this project is to implement necessary adjustments to the `KipuBank` smart contract (originally created in Module 2) and to practice testing using the **Foundry** framework, integrated with Scaffold-ETH 2.

- Original Contract (Module 2): https://sepolia.etherscan.io/address/0x976A85AbfA7F0D5F5Ea13B5e6143c83f7bF25336#code  
- Current Contract (Module 4): https://sepolia.etherscan.io/address/0xfb110c367b306ce2d381fc194ab6b2914f854728#code

---

## 📋 Project Description

KipuBank is a Solidity smart contract that simulates a decentralized bank, allowing users to make deposits and withdrawals with predefined limits.  
This project focuses on:

- **Adjustments to the original contract**: Logic and security improvements.  
- **Automated testing**: Using Foundry to ensure contract robustness.  
- **Integration with Scaffold-ETH 2**: Implementing an interactive interface for contract interaction.

---

## 🌍 Available Languages

- 🇺🇸 [English](README.md)
- 🇧🇷 [Português Brasileiro](README.pt-BR.md)

## 🛠️ Main Features

### Deposits:
- Users can deposit ETH into the contract.  
- The total deposited amount cannot exceed the cap (`i_WeiBankCap`).

### Withdrawals:
- Users can withdraw amounts within the allowed limit (`MAX_WEI_WITHDRAWAL`).  
- The user must have enough balance to withdraw.

### Events:
- Emission of events to track deposits and withdrawals (`KipuBank_Deposit`, `KipuBank_Withdrawal`).

### Security:
- Custom errors used for validation.  
- Protection against reentrancy attacks.

### Interactive Interface:
- Using Scaffold-ETH 2, the project includes a Next.js interface for interacting with the smart contracts.

---

## 🧪 Automated Testing

Tests are written using the Foundry framework, ensuring that all contract functionalities are properly verified.

**Key Tests Implemented (`/packages/foundry/test/KipuBank.t.sol`)**
- `testDeposit`: Checks that valid deposits are correctly processed.  
- `testWithdrawOK`: Validates withdrawals within the allowed limit.  
- `testRevert_WithdrawInsufficientBalance`: Ensures withdrawals with insufficient balance revert.  
- `testRevert_ExceedsBankCap`: Tests deposit attempts above the bank cap.  
- `testMultipleDeposits`: Simulates multiple deposits from different users.

---

## ✅ How to Run the Tests

Make sure you have **Foundry** installed:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Run the tests:

```bash
forge test -vvv
```

---

## 🚀 How to Set Up the Project

### Prerequisites:
- Node.js (v18+)  
- Foundry installed  
- Scaffold-ETH 2 configured  
- Git configured

### Setup Steps:

Clone this repository:

```bash
git clone https://github.com/your-user/kipubank-modulo4.git
cd kipubank-modulo4
```

Install the required dependencies:

```bash
yarn install
```

Compile the contracts:


```bash
forge build
```

Start the local blockchain:

```bash
yarn chain
```

Deploy the contracts to the local network:

```bash
yarn deploy
```

Start the Next.js interface:

```bash
yarn start
```

---

## 📂 Project Structure

```
kipubank/
├── packages/
│   ├── foundry/
│   │   ├── contract/          # Smart contracts (e.g., KipuBank.sol)
│   │   ├── test/              # Automated tests with Foundry (e.g., KipuBank.t.sol)
│   │   ├── script/            # Deployment scripts (e.g., DeployKipuBank.s.sol)
│   │   └── foundry.toml       # Foundry configuration
│   ├── nextjs/                # Frontend interface built with Next.js
README.md                      # Project documentation (this file)
```

---

## 📚 References

- [Ethereum Developer Pack - ETH Kipu](https://www.ethkipu.com/)
- [Foundry Documentation](https://github.com/gobble/foundry)
- [Scaffold-ETH 2 Documentation](https://github.com/scaffold-eth/scaffold-eth)
- [Solidity Documentation](https://soliditylang.org/docs/)

---

## 🏆 About the Project

This project was developed as part of the **Ethereum Developer Pack by ETH Kipu**, aiming to train developers in building and testing robust smart contracts on the Ethereum blockchain, as well as integrating those contracts into modern interfaces using **Scaffold-ETH 2**.

If you have any questions or suggestions, feel free to open an issue in this repository!