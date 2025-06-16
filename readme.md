# 🏦 KipuBank

KipuBank es un contrato inteligente escrito en Solidity que simula una bóveda de ahorro en ETH. Permite a los usuarios depositar ETH directamente al contrato y retirarlo posteriormente, sujeto a un límite por transacción. También existe un límite global de capital (`bankCap`) que restringe la cantidad total de ETH que puede ser depositada en el banco.

---

## ✨ Características

- ✅ Depósitos en ETH usando `receive()` o la función `deposit()`.
- 🔒 Retiros con límite fijo por transacción (`withdrawalLimit`).
- 📊 Registro individual de saldos, depósitos y retiros por usuario.
- 🛑 Límite total (`bankCap`) que impide que se supere la capacidad del banco.
- 📢 Emisión de eventos en depósitos, retiros y fallback.
- 🔐 Seguridad reforzada: `require`, errores personalizados, y patrón Checks-Effects-Interactions.

---

## ⚙️ Requisitos

- Cuenta en MetaMask o Remix para pruebas en testnet

---

## 🚀 Instrucciones de Despliegue (con Remix)

1. Abre [Remix IDE](https://remix.ethereum.org/)
2. Crea un archivo `KipuBank.sol` y copia el contrato completo.
3. Compila con la versión de Solidity `^0.8.20`.
4. Ve a la pestaña **Deploy & Run Transactions**:
   - Environment: `Injected Web3` o `JavaScript VM`
   - Agrega los argumentos del constructor:
     - `_withdrawalLimit`: por ejemplo `0.5 ether` → `500000000000000000`
     - `_bankCap`: por ejemplo `5 ether` → `5000000000000000000`
   - Haz clic en **Deploy**

---

## 💰 Cómo Interactuar

### Depositar ETH
1. Escribe la cantidad en el campo `VALUE` (ej: `0.1`)
2. Haz clic en `deposit()`  
→ Verás un evento `Deposit(...)` emitido.

### Retirar ETH
1. Llama a la función `withdraw(uint256 amount)`
2. El monto debe ser menor o igual al límite (`withdrawalLimit`) y a tu balance personal.

### Revisar Depositos
1. Click en el botón depositCount para revisar la cantidad de depositos.

### Revisar Retiros
1. Click en el botón withdrawalCount para revisar la cantidad de depositos.

### Revisar Capital del Banco
1. Click en el botón bankCap para revisar el capital del banco.

### Revisar Limite de deposito
1. Click en el botón withdrawalLimit para revisar el limite de deposito.