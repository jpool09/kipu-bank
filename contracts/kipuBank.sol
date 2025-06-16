// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title KipuBank - Bóveda de ETH con límite global y retiros controlados por transacción
contract kipuBank {
    // -------- Errors --------
    error ExceedsWithdrawalLimit(uint256 attempted, uint256 limit);
    error InsufficientFunds(uint256 attempted, uint256 available);
    error ExceedsBankCap(uint256 attempted, uint256 remaining);
    error BankCapReached();

    // -------- Events --------
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    event FallbackCalled(address sender, uint256 value, bytes data);

    // -------- State Variables --------

    /// @notice Límite máximo por transacción de retiro
    uint256 public immutable withdrawalLimit;

    /// @notice Límite total de depósitos permitidos en el contrato
    uint256 public immutable bankCap;

    /// @notice Total de ETH actualmente en el contrato
    uint256 public totalDeposited;

    mapping(address => uint256) private vaults;
    mapping(address => uint256) public depositCount;
    mapping(address => uint256) public withdrawalCount;

    /// @notice Constructor
    /// @param _withdrawalLimit Límite de retiro por transacción (en wei)
    /// @param _bankCap Límite total de depósitos permitidos en el banco (en wei)
    constructor(uint256 _withdrawalLimit, uint256 _bankCap) {
        require(_withdrawalLimit > 0, "Withdrawal limit must be > 0");
        require(_bankCap > 0, "Bank cap must be > 0");
        withdrawalLimit = _withdrawalLimit;
        bankCap = _bankCap;
    }

    /// @notice Recibe ETH directamente como depósito a la cuenta del usuario
    receive() external payable {
        if (totalDeposited + msg.value > bankCap) {
            revert ExceedsBankCap(msg.value, bankCap - totalDeposited);
        }

        if (totalDeposited + msg.value > bankCap) {
            revert ExceedsBankCap(msg.value, bankCap - totalDeposited);
        }

        vaults[msg.sender] += msg.value;
        totalDeposited += msg.value;
        depositCount[msg.sender]++;
        emit Deposit(msg.sender, msg.value);
    }

    /// @notice Fallback para funciones inexistentes
    fallback() external payable {
        emit FallbackCalled(msg.sender, 0, msg.data);
    }

    /// @notice Permite al usuario retirar una cantidad de su balance
    function withdraw(uint256 amount) external {
        if (amount > withdrawalLimit) {
            revert ExceedsWithdrawalLimit(amount, withdrawalLimit);
        }

        if (amount > vaults[msg.sender]) {
            revert InsufficientFunds(amount, vaults[msg.sender]);
        }

        vaults[msg.sender] -= amount;
        totalDeposited -= amount;
        withdrawalCount[msg.sender]++;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "ETH transfer failed");

        emit Withdrawal(msg.sender, amount);
    }

    /// @notice Devuelve el balance de un usuario específico
    function getVaultBalance(address user) external view returns (uint256) {
        return vaults[user];
    }

    /// @dev Verifica si un usuario tiene fondos en su bóveda (uso interno)
    function _hasFunds(address user) private view returns (bool) {
        return vaults[user] > 0;
    }

    /// @notice Función explícita para depositar ETH desde interfaces como Remix
    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");

        if (totalDeposited + msg.value > bankCap) {
            revert ExceedsBankCap(msg.value, bankCap - totalDeposited);
        }

        if (totalDeposited + msg.value > bankCap) {
            revert ExceedsBankCap(msg.value, bankCap - totalDeposited);
        }

        vaults[msg.sender] += msg.value;
        totalDeposited += msg.value;
        depositCount[msg.sender]++;

        emit Deposit(msg.sender, msg.value);
    }
}
