# 🪙 OurToken – Custom ERC20 Token with Robust Testing

This repository contains a secure and minimal implementation of an ERC20 token (`OurToken`) using Solidity and OpenZeppelin. It includes an extensive suite of tests written in Foundry to cover all key ERC20 behaviors and edge cases.

---

## 🔧 Tech Stack

* **Solidity** – Smart contract language
* **OpenZeppelin** – Secure ERC20 base
* **Foundry** – For fast, efficient testing (`forge`, `cast`, `anvil`)
* **vm.prank / expectRevert** – For simulating call contexts and reverts in tests

---

## 📦 Contract Overview

### `src/OurToken.sol`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initial) ERC20("OurToken", "KC") {
        _mint(msg.sender, initial);
    }
}
```

* ✅ Uses OpenZeppelin’s secure and audited `ERC20` implementation
* ✅ Accepts initial supply in constructor and mints to deployer

---

## 📊 Testing Approach

All tests are written in **Foundry** using `forge-std/Test.sol`. The testing strategy covers:

### ✅ **Core Functional Tests**

* Transfer tokens correctly
* Approve and transferFrom work as expected
* Balances and allowances behave as per ERC20 spec

### ❌ **Failure/Edge Case Tests**

* Transfer more than balance should revert
* TransferFrom without approval should revert
* Approve to zero address should revert
* Transfer to zero address should revert
* Revoke allowance and prevent further transferFrom
* Transfer zero tokens (should succeed)
* Self-transfer (balance unchanged)


### ALl tests have been covered 
[https://raw.githubusercontent.com/kaushalya4s5s7/EVM_packStack/refs/heads/main/ERC20/assests/Screenshot%202025-07-16%20at%2011.36.22%E2%80%AFPM.png]
 
### 🔥 **Event Emission Tests**

* `Transfer` and `Approval` events are emitted correctly
* `vm.expectEmit()` used for validation

---

## 📁 Project Structure

```
ERC20/
│
├── src/
│   └── OurToken.sol           # The ERC20 token contract
│
├── script/
│   └── DeployOurToken.s.sol  # Script for deploying the token
│
├── test/
│   └── OurTokentest.t.sol    # All unit tests for ERC20 functionality
│
├── foundry.toml              # Foundry config file
└── README.md                 # You're here!
```

---

## 🚀 Quick Start

### Install Foundry (if not already)

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Run Tests

```bash
forge test
```

### View Coverage Report

```bash
forge coverage
```

---

## 🚪 License

This project is licensed under the [MIT License](LICENSE).
