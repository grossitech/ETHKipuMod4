// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../contracts/KipuBank.sol";

contract KipuBankTest is Test {
    KipuBank bank;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        vm.startPrank(owner);
        bank = new KipuBank(1 ether); // Cap = 1 ETH
        vm.stopPrank();
    }

    // Teste de depósito válido
    function testDeposit() public { 
        vm.deal(user, 0.5 ether);
        vm.startPrank(user);
        bank.deposit{value: 0.5 ether}();
        
        assertEq(bank.getContractBalance(), 0.5 ether);
        vm.stopPrank();
    }

    function testFuzz_Deposit(uint256 amount) public { 
        vm.assume(amount > 0 && amount <= 1 ether);
        vm.deal(user, amount);
        vm.startPrank(user);
        bank.deposit{value: amount}();
        assertEq(bank.getContractBalance(), amount);
        vm.stopPrank();
    }

    // Teste de limite de saque
    function testWithdrawLimitFails() public { 
        vm.deal(user, 1 ether);
        vm.startPrank(user);
        bank.deposit{value: 1 ether}();

        vm.expectRevert(abi.encodeWithSignature("KipuBank_ExceedsWithdrawalLimit(uint256,uint256)", 0.0011 ether, 0.001 ether));
        bank.withdraw(0.0011 ether); //MAX_WEI_WITHDRAWAL = 0.001 ether
    }

    // Teste de saque dando certo
    function testWithdrawOK() public { 
        // Configuração
        vm.deal(user, 0.5 ether); // Fornece 0.5 ETH ao usuário
        vm.startPrank(user); // Define `user` como `msg.sender`
        bank.deposit{value: 0.5 ether}(); // Depósito inicial de 0.5 ETH
        
        // Saldo inicial antes do saque
        uint256 initialUserBalance = user.balance;

        // Saque
        bank.withdraw(0.0005 ether);

        // Verificações
        assertEq(bank.getContractBalance(), 0.5 ether - 0.0005 ether); // Saldo do contrato reduzido
        assertEq(user.balance, initialUserBalance + 0.0005 ether); // Saldo do usuário aumentado pelo valor sacado
        vm.stopPrank();
    }
 
    //teste de saque com saldo insuficiente
    function testRevert_WithdrawInsufficientBalance() public { 
        vm.deal(user, 0.5 ether);
        vm.startPrank(user);
        bank.deposit{value: 0.5 ether}();
        
        // Tenta sacar mais que o saldo (0.6 ETH)
        vm.expectRevert(
            abi.encodeWithSelector(
                KipuBank.KipuBank_InsufficientBalance.selector,
                0.5 ether,   // Saldo atual do usuário (0.5 ETH)
                0.6 ether    // Valor do saque (0.6 ETH)
            )
        );
        bank.withdraw(0.6 ether);
        vm.stopPrank();
    }

    //teste de saque que excede o limite de saque do banco
    function testRevert_ExceedsWithdrawalLimit() public { 
        vm.deal(user, 1 ether);
        vm.startPrank(user);
        bank.deposit{value: 1 ether}(); //deposita 1 ether
        
        // Tenta sacar acima do limite
        vm.expectRevert(abi.encodeWithSignature("KipuBank_ExceedsWithdrawalLimit(uint256,uint256)", 1 ether, 0.001 ether));
        bank.withdraw(1 ether); // manda sacar 1 ether, porém o limite de saque é 0.001 ether
        vm.stopPrank();
    }

    //teste de depósito que excete do BankCap
    function testRevert_ExceedsBankCap() public {
        uint256 cap = 1 ether;
        vm.deal(user, cap + 1);
        vm.startPrank(user);
        
        // Saldo antes do depósito é 0 (contrato recém-criado)
        vm.expectRevert(
            abi.encodeWithSignature(
                "KipuBank_ExceedsBankCap(uint256,uint256,uint256)",
                0,          // balanceBefore (saldo antes do depósito)
                cap + 1,    // msg.value (valor do depósito)
                cap         // i_WeiBankCap (limite do banco)
            )
        );
        
        bank.deposit{value: cap + 1}();
        vm.stopPrank();
    }

    function testFuzz_Withdraw(uint256 amount) public { 
        // Garante 0 < amount <= MAX_WEI_WITHDRAWAL
        amount = bound(amount, 1, bank.MAX_WEI_WITHDRAWAL());
        
        // Configuração
        vm.deal(user, amount);
        vm.startPrank(user);
        bank.deposit{value: amount}();
        
        // Saque
        bank.withdraw(amount);
        
        // Verificações
        assertEq(bank.getContractBalance(), 0);
        assertEq(user.balance, amount); // ETH devolvido
        vm.stopPrank();
    }

    // testa o múltiplos depósitos de 1 usuário
    function testMultipleDeposits1user() public {
        // Configuração
        uint256 depositAmount1 = 0.3 ether;
        uint256 depositAmount2 = 0.2 ether;

        // Fornece ETH aos usuários
        vm.deal(user, depositAmount1 + depositAmount2);

        // Depósito do User1
        vm.startPrank(user);
        bank.deposit{value: depositAmount1}();
        bank.deposit{value: depositAmount2}();
        vm.stopPrank();

        // Verificações
        assertEq(bank.getContractBalance(), depositAmount1 + depositAmount2); // Saldo total do contrato
    }

    //testa depósitos de 2 usuários
    function testMultipleDeposits2users() public {
        // Configuração
        address user1 = address(3);
        address user2 = address(4);
        uint256 depositAmount1 = 0.3 ether;
        uint256 depositAmount2 = 0.2 ether;

        // Fornece ETH aos usuários
        vm.deal(user1, depositAmount1);
        vm.deal(user2, depositAmount2);

        // Depósito do User1
        vm.startPrank(user1);
        bank.deposit{value: depositAmount1}();
        vm.stopPrank();

        // Depósito do User2
        vm.startPrank(user2);
        bank.deposit{value: depositAmount2}();
        vm.stopPrank();

        // Verificações
        assertEq(bank.getContractBalance(), depositAmount1 + depositAmount2); // Saldo total do contrato
    }

    //Testa múltiplos saques de um mesmo usuário dentro do limite de saldo e de saque
    function testMultipleWithdrawalsWithinLimit() public {
        uint256 deposit = 0.5 ether;
        uint256 withdraw1 = 0.001 ether; //MAX_WEI_WITHDRAWAL = 0.001 ether
        uint256 withdraw2 = 0.0002 ether;
        uint256 withdraw3 = 0.001 ether; //MAX_WEI_WITHDRAWAL = 0.001 ether
        uint256 withdraw4 = 0.0004 ether;
        uint256 withdraw5 = 0.0001 ether;

        vm.deal(user, 0.5 ether); // Fornece 0.5 ETH ao usuário
        vm.startPrank(user); // Define `user` como `msg.sender`
        bank.deposit{value: deposit}(); // Depósito inicial 

        // Saque
        bank.withdraw(withdraw1);
        bank.withdraw(withdraw2);
        bank.withdraw(withdraw3);
        bank.withdraw(withdraw4);
        bank.withdraw(withdraw5);

        vm.stopPrank();

        uint256 remainingBalance = deposit - withdraw1 - withdraw2 - withdraw3 - withdraw4 - withdraw5;
        assertEq(bank.getContractBalance(), remainingBalance);
    }




}
