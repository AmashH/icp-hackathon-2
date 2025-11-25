# 🌊 LiquidBTC

> Liquid staking for Bitcoin on the Internet Computer

**LiquidBTC** solves Bitcoin's staking liquidity problem. Stake your BTC, get liquid stBTC tokens, earn ~10% APY, and unstake anytime—no 6-12 month lock-ups.

Built for the **ICP Bitcoin DeFi Hackathon** to showcase how ICP's native Bitcoin integration enables "Lido for Bitcoin."

## 🎯 What It Does

Traditional Bitcoin staking (e.g., Babylon Protocol) locks your BTC for months with no exit. LiquidBTC provides:

- **Instant Liquidity**: Stake BTC → receive stBTC (1:1) → unstake anytime
- **Earn Yield**: ~10% APY through exchange rate appreciation
- **DeFi Ready**: Use stBTC in other protocols while earning rewards
- **Risk Management**: Exit immediately if concerns arise

## 🚀 Quick Start

### Option 1: Deploy via ICP Ninja (Recommended)

Click "Run" to deploy instantly to mainnet for free:

[![Open in ICP Ninja](https://icp.ninja/assets/open.svg)](https://icp.ninja/i?g=https://github.com/AmashH/icp-hackathon-2)

### Option 2: Local Development

**Prerequisites**: [dfx](https://internetcomputer.org/docs/current/developer-docs/getting-started/install), [Node.js](https://nodejs.org/), [Mops](https://docs.mops.one/quick-start)

```bash
# Clone the repo
git clone https://github.com/AmashH/icp-hackathon-2
cd icp-hackathon-2

# Install dependencies
npm install

# Start local replica
dfx start --background

# Deploy canisters
dfx deploy

# Open the frontend
# The URL will be shown in the deploy output
```

### Option 3: Deploy to Mainnet

```bash
# Make sure you have cycles
dfx deploy --network ic
```

See [BUILD.md](BUILD.md) for detailed instructions.

## 💡 How to Use

1. **Stake Bitcoin**: Enter BTC amount → Get stBTC (1:1 ratio)
2. **Fast-Forward Time**: Click "Simulate 30 days" to see rewards accrue
3. **Unstake & Profit**: Burn stBTC → Receive more BTC back with rewards

**Note**: This MVP simulates rewards via a demo button. Production would integrate with Babylon Protocol for real Bitcoin staking.

## 🏗️ Architecture

- **Backend**: Motoko canister ([backend/app.mo](backend/app.mo))
  - Manages stBTC minting/burning
  - Tracks exchange rate (starts at 1.0, increases with APY)
  - Stores user balances
- **Frontend**: Vite + Vanilla JS ([frontend/index.html](frontend/index.html))
  - Stake/unstake interface
  - Real-time protocol stats
  - Time simulation for demo

## 🎪 Hackathon Challenge

This project addresses the **"Unleashing the next era of BTCFi on the Internet Computer"** challenge by demonstrating:

- **ckBTC Integration**: Using ICP's native Bitcoin capabilities (simulated in MVP)
- **DeFi Composability**: stBTC as a liquid, tradeable receipt token
- **Threshold Signatures**: Concept of decentralized Bitcoin custody via ICP

While the current implementation simulates Bitcoin integration, it showcases the **potential** of ICP's unique capabilities for Bitcoin DeFi that aren't possible on Ethereum or Solana.

## 📁 Project Structure

```
icp-hackathon-2/
├── backend/
│   └── app.mo              # Motoko canister (staking logic)
├── frontend/
│   ├── index.html          # UI with stake/unstake forms
│   ├── vite.config.js      # Vite configuration
│   └── package.json        # Frontend dependencies
├── dfx.json                # ICP canister configuration
├── mops.toml               # Motoko package manager
├── BUILD.md                # Detailed build instructions
└── README.md               # This file
```

## 🔑 Key Features

- ✅ Liquid staking (stake/unstake anytime)
- ✅ 10% APY via exchange rate appreciation
- ✅ Real-time protocol statistics
- ✅ Principal-based user balances
- ✅ Deployed to IC mainnet
- ⚠️ MVP: Rewards simulated, uses anonymous Principal

## 🔮 Future Roadmap

- [ ] Real ckBTC integration
- [ ] Babylon Protocol connection for Bitcoin staking
- [ ] Internet Identity login
- [ ] Stable storage (BTree for upgrade persistence)
- [ ] DEX integrations for stBTC trading
- [ ] Lending protocol integrations

## 📚 Learn More

- [Full Technical Documentation](d:\Downloads\LiquidBTC_Project_Documentation.md)
- [Motoko Language Guide](https://internetcomputer.org/docs/current/motoko/main/motoko)
- [ICP Bitcoin Integration](https://internetcomputer.org/docs/current/developer-docs/integrations/bitcoin/ckbtc)
- [Babylon Protocol](https://babylonchain.io)

## 📄 License

MIT License - Built for ICP Bitcoin DeFi Hackathon
