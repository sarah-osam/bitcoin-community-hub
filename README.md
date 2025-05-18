# 🟠 Bitcoin Community Hub

[![Built on Stacks](https://img.shields.io/badge/Built%20on-Stacks%20L2-5546ff.svg)](https://www.stacks.co)

**A decentralized identity and profile management system for Bitcoin and Stacks communities.**
Empowering user-controlled profiles, private social discovery, and transparent on-chain analytics—secured by Bitcoin, powered by Stacks L2.

---

## 🔍 Overview

Bitcoin Community Hub allows participants in the Bitcoin ecosystem to create verifiable, non-custodial identities with privacy-respecting social discovery and analytics. It enables modular, interest-tagged profiles, permission-controlled access, and secure engagement tracking on-chain.

---

## ✨ Key Features

* ✅ **Self-Sovereign Identity** — Full user control over profiles and updates
* 🔐 **Privacy Control** — Granular, observer-based visibility permissions
* 🧠 **Interest Discovery** — Tag-driven profile search and community mapping
* 📈 **On-Chain Analytics** — Immutable participation tracking
* ⛓️ **Bitcoin-Secured Integrity** — Anchored via Stacks L2 with Bitcoin finality

---

## ⚙️ Architecture

![System Architecture](docs/architecture-diagram.png)

### Layers

1. **Identity Layer**

   * Decentralized registry (`participant-profile-registry`)
   * Immutable Bitcoin-anchored records
   * Ownership tied to cryptographic keys

2. **Privacy Control Layer**

   * Fine-grained visibility management (`information-access-permissions`)
   * Principal-based permission logic
   * Self-sovereign data exposure policies

3. **Social Graph Layer**

   * Interest-tag indexing
   * Community discovery and analytics (`participation-analytics-store`)
   * Reverse lookups for tag-to-user mapping (planned)

4. **Blockchain Integration**

   * Smart contract on Stacks L2
   * Bitcoin settlement assurance
   * Block height-based temporal state

---

## 📜 Smart Contract Interface

### 🔧 Public Functions

| Function                               | Purpose                                        |
| -------------------------------------- | ---------------------------------------------- |
| `register-new-participant`             | Create a new participant profile               |
| `update-interest-tags`                 | Modify interest tags associated with a profile |
| `change-display-identifier`            | Change the participant’s public display name   |
| `perform-comprehensive-profile-update` | Update name, description, and tags at once     |
| `manage-profile-visibility`            | Assign visibility permissions to observers     |

### 🔎 Query Functions

| Function                         | Return Type | Description                              |
| -------------------------------- | ----------- | ---------------------------------------- |
| `verify-participant-credentials` | `bool`      | Validates identity ownership credentials |
| `participant-registered?`        | `bool`      | Checks if a participant is registered    |

### Governance & Errors

* **Admin Role**: Set at deployment (`tx-sender`)
* **Error Codes**:

  * `500`: Access denied
  * `501`: Participant not found
  * `502`: Duplicate registration
  * `503`: Invalid input
  * `504`: Unauthorized action

---

## 🏗️ Suggested Architecture Stack

```
                        +----------------------------+
                        |   Bitcoin Community Hub    |
                        |   (Clarity Smart Contract) |
                        +----------------------------+
                                  ▲
        +-------------------------|--------------------------+
        |                         |                          |
+------------------+   +-------------------+     +---------------------+
| Identity Manager |   | Interest Discovery|     | Access Controller   |
|  (UI + API)      |   |  (Tag Matching)   |     |  (Privacy Settings) |
+------------------+   +-------------------+     +---------------------+
        ▲                      ▲                           ▲
+------------------+   +-------------------+     +---------------------+
| Stacks Wallet    |   | Interaction Logs  |     | Analytics Dashboard |
+------------------+   +-------------------+     +---------------------+
```

---

## 🚀 Usage Examples

### Profile Registration (Stacks.js)

```ts
import { callReadOnlyFunction } from '@stacks/transactions';

const result = await callReadOnlyFunction({
  contractAddress: 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE',
  contractName: 'community-hub',
  functionName: 'register-new-participant',
  functionArgs: [
    stringAsciiCV('BitcoinMaxi'),
    stringAsciiCV('Long-term holder since 2016'),
    listCV([
      stringAsciiCV('Lightning Network'),
      stringAsciiCV('Self-Custody')
    ])
  ],
  network: stacksNetwork,
  senderAddress: userAddress,
});
```

---

## 🛠️ Development Setup

### Requirements

* [Clarinet v2.0+](https://docs.stacks.co/docs/clarity-reference/clarinet-cli/)
* Node.js 18+
* [Stacks.js SDK](https://docs.stacks.co/build-apps/overview)

### Installation

```bash
git clone https://github.com/your-org/bitcoin-community-hub.git
cd bitcoin-community-hub
clarinet install
npm install @stacks/transactions
```

### Deployment

```bash
clarinet check        # Validate contract
clarinet deployments       # Deploy to localnet/testnet
```

---

## 🧪 Testing & Contribution

### Contribution Workflow

1. Fork the repo
2. Create a new branch: `git checkout -b feature/your-feature`
3. Commit with signed-off messages
4. Add or update tests
5. Submit a pull request to `develop`

---

## 🧭 Roadmap Highlights

* 🔁 Reverse-interest lookup engine
* 🧱 DAO-based governance hooks
* 🛡️ zk-SNARK interest proofs (privacy-enhanced)
* ⚡ Off-chain profile indexer
* 🧬 Integration with Verifiable Credentials (DID/VC)
