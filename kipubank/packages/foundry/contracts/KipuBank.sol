// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract KipuBank {
    // Variáveis imutáveis
    uint256 public immutable i_WeiBankCap;
    address immutable i_owner;

    // Variáveis constantes
    uint256 public constant MAX_WEI_WITHDRAWAL = 1000000000000000; //0.001 ether

    // Mapeamento para armazenar saldos dos usuários
    mapping(address => uint256) private s_balances;

    // Eventos
    event KipuBank_Deposit(address indexed user, uint256 amount);
    event KipuBank_Withdrawal(address indexed user, uint256 amount);
    event KipuBank_BankClosed(address indexed owner, uint256 balanceTransferred);

    // Erros customizados
    error KipuBank_CallerNotAllowed(address caller, address owner);
    error KipuBank_ExceedsBankCap(uint256 current, uint256 attempted, uint256 cap);
    error KipuBank_InsufficientBalance(uint256 balance, uint256 withdrawalAmount);
    error KipuBank_ExceedsWithdrawalLimit(uint256 withdrawalAmount, uint256 limit);
    error KipuBank_InvalidDepositAmount();
    error KipuBank_TransferFailed();

    // Construtor
    constructor(uint256 _WeiBankCap) {
        i_owner = msg.sender;
        i_WeiBankCap = _WeiBankCap;
    }

    // Função de depósito (payable)
    function deposit() external payable {
        if (msg.value == 0) revert KipuBank_InvalidDepositAmount();
        
        // Calcula o saldo ANTES do depósito
        uint256 balanceBefore = address(this).balance - msg.value;
        
        if (balanceBefore + msg.value > i_WeiBankCap) {
            revert KipuBank_ExceedsBankCap(balanceBefore, msg.value, i_WeiBankCap);
        }
        
        s_balances[msg.sender] += msg.value;
        emit KipuBank_Deposit(msg.sender, msg.value);
    }

    // Função de saque
    function withdraw(uint256 WeiAmount) external {
        if (s_balances[msg.sender] < WeiAmount) {
            revert KipuBank_InsufficientBalance(s_balances[msg.sender], WeiAmount);
        }
        if (WeiAmount > MAX_WEI_WITHDRAWAL) {
            revert KipuBank_ExceedsWithdrawalLimit(WeiAmount, MAX_WEI_WITHDRAWAL);
        }
        s_balances[msg.sender] -= WeiAmount;
        _safeTransfer(msg.sender, WeiAmount);
        emit KipuBank_Withdrawal(msg.sender, WeiAmount);
    }

    // Função para consultar saldo do contrato
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Função interna para transferência segura
    function _safeTransfer(address to, uint256 amount) private {
        (bool success, ) = to.call{value: amount}("");
        if (!success) {
            revert KipuBank_TransferFailed();
        }
    }
}