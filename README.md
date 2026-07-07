# UART_UVM_Based_verifiction
UVM-based Coverage-Driven Verification (CDV) of a UART FIFO Transmitter using SystemVerilog, featuring constrained-random verification, scoreboard, functional coverage, parity/framing error checking, and reusable verification components.
# UART FIFO Transmitter Verification using SystemVerilog & UVM

<p align="center">

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-HDL-blue)
![UVM](https://img.shields.io/badge/UVM-IEEE%201800.2-green)
![Verification](https://img.shields.io/badge/Verification-Coverage--Driven-orange)
![License](https://img.shields.io/badge/License-MIT-blue)

</p>

---

# Overview

This repository presents a **Coverage-Driven Verification (CDV)** environment for a **UART FIFO Transmitter** developed using **SystemVerilog** and the **Universal Verification Methodology (UVM)**.

The project demonstrates the verification of a UART transmitter integrated with a FIFO buffer, ensuring reliable serial communication through reusable, scalable, and modular UVM verification components. The verification environment follows industry-standard methodologies including **constrained-random stimulus generation**, **transaction-level checking**, **functional coverage**, and **protocol-aware monitoring**.

The primary objective of this project is to verify the functional correctness of the UART transmitter, validate FIFO buffering behavior, detect protocol violations such as **parity errors** and **framing errors**, and achieve comprehensive verification using **Coverage-Driven Verification (CDV)**.

---

# Project Objectives

- Verify UART FIFO Transmitter functionality using SystemVerilog & UVM
- Develop a reusable and scalable UVM verification environment
- Validate UART frame generation (Start, Data, Parity, Stop)
- Verify FIFO buffering and data integrity
- Detect parity and framing errors
- Perform constrained-random verification
- Collect functional coverage for verification closure
- Demonstrate transaction-level checking using a scoreboard

---

# Key Features

- UVM-Based Verification Environment
- Coverage-Driven Verification (CDV)
- Constrained-Random Test Generation
- UART Protocol Verification
- FIFO Buffer Verification
- Functional Coverage Collection
- Transaction-Level Scoreboard
- Protocol-Aware UART Monitor
- Write Interface Monitor
- Reusable Verification Components
- Virtual Interface Configuration
- UVM Configuration Database
- TLM-Based Communication
- Directed & Random Test Scenarios
- Parity Error Detection
- Framing Error Detection

---

# UART Frame Format

The UART transmitter implements an **8-bit data frame with even parity**.

```
 Idle

   │

   ▼

+-------+----------+---------+--------+
| Start | 8 Data   | Parity  | Stop   |
|  Bit  |  Bits    |  Bit    |  Bit   |
+-------+----------+---------+--------+
```

---

# DUT Architecture

```
                   +-----------------------------------+
                   |      UART_FIFO_TX_TOP             |
                   |                                   |
Data Input ------->|          FIFO                     |
                   |            │                      |
                   |            ▼                      |
                   |        UART_TX                    |
                   |            │                      |
                   |            ▼                      |
                   |           TX                      |
                   |                                   |
                   |      Baud Generator               |
                   +-----------------------------------+
```

---

# UVM Verification Architecture

```
                  +----------------------+
                  |      Sequence        |
                  +----------+-----------+
                             |
                             ▼
                  +----------------------+
                  |      Sequencer       |
                  +----------+-----------+
                             |
                             ▼
                  +----------------------+
                  |       Driver         |
                  +----------+-----------+
                             |
                             ▼
                      +--------------+
                      |     DUT      |
                      +--------------+
                        │          │
                        │          │
                        ▼          ▼
                Write Monitor   TX Monitor
                        │          │
                        └────┬─────┘
                             ▼
                       Scoreboard
                             │
                             ▼
                    Functional Coverage
```

---

# Verification Flow

1. Sequence generates constrained-random UART transactions.
2. Driver converts transactions into DUT interface activity.
3. FIFO stores incoming data before transmission.
4. UART transmitter serializes FIFO data.
5. Write Monitor captures expected transactions.
6. UART TX Monitor reconstructs transmitted UART frames.
7. Scoreboard compares expected and actual transactions.
8. Functional Coverage measures verification completeness.
9. UVM Report summarizes pass/fail statistics.

---

# Verification Components

| Component | Purpose |
|-----------|---------|
| Sequence Item | Defines UART transaction |
| Sequence | Generates constrained-random stimulus |
| Sequencer | Supplies transactions to the driver |
| Driver | Drives FIFO write interface |
| Write Monitor | Captures expected transactions |
| UART TX Monitor | Decodes transmitted UART frames |
| Scoreboard | Compares expected vs actual data |
| Functional Coverage | Measures verification completeness |
| TX Agent | Active UVM Agent |
| RX Agent | Passive UVM Agent |
| Environment | Connects all verification components |
| Test | Builds environment and starts sequences |

---

# Functional Verification

The verification environment validates:

- UART Start Bit
- UART Data Bits
- UART Parity Bit
- UART Stop Bit
- FIFO Data Integrity
- UART Frame Sequence
- Constrained-Random Transactions
- Directed Test Cases
- Functional Coverage
- Scoreboard Comparison
- Protocol Compliance

---

# Error Detection

The UART monitor automatically detects:

- Parity Errors
- Framing Errors
- Unexpected UART Transactions
- Scoreboard Mismatches
- Protocol Violations

---

# Functional Coverage

Coverage is collected using **SystemVerilog Covergroups**.

Coverage includes:

- Data Pattern Coverage
- Gap Coverage
- Parity Coverage
- Framing Coverage
- Cross Coverage
- Corner Case Verification

The objective is to achieve high functional coverage while validating all important UART protocol scenarios.

---

# Test Scenarios

The verification environment includes:

- Basic UART Transmission
- Random UART Frames
- FIFO Burst Writes
- Corner Case Data Patterns
- Variable Inter-Frame Gap
- FIFO Boundary Conditions
- Parity Verification
- Framing Verification
- Directed Tests
- Constrained-Random Tests

---

# Repository Structure

```
UART_FIFO_TX_UVM/

├── rtl/
│   ├── UART_FIFO_TX_TOP.sv
│   ├── UART_TX.sv
│   ├── UART_RX.sv
│   ├── FIFO.sv
│   └── Baud_Generator.sv
│
├── tb/
│   ├── uart_if.sv
│   ├── uart_seq_item.sv
│   ├── uart_base_seq.sv
│   ├── uart_driver.sv
│   ├── uart_wr_monitor.sv
│   ├── uart_tx_monitor.sv
│   ├── uart_scoreboard.sv
│   ├── uart_coverage.sv
│   ├── uart_tx_agent.sv
│   ├── uart_rx_agent.sv
│   ├── uart_env.sv
│   ├── uart_base_test.sv
│   ├── uart_pkg.sv
│   └── testbench.sv
│
├── docs/
├── images/
├── waves/
├── coverage/
└── README.md
```

---

# Skills Demonstrated

- SystemVerilog
- Universal Verification Methodology (UVM)
- Coverage-Driven Verification (CDV)
- Constrained-Random Verification
- Functional Coverage
- UART Protocol Verification
- FIFO Verification
- Transaction-Level Modeling (TLM)
- Virtual Interface
- UVM Factory
- UVM Configuration Database
- Scoreboard-Based Verification
- Protocol Monitoring
- Waveform Debugging
- Functional Debugging

---

# Future Enhancements

- UART Receiver Verification
- Full-Duplex UART Verification
- Assertion-Based Verification (SVA)
- Code Coverage Integration
- Regression Automation
- Continuous Integration (CI)
- APB-to-UART Integration
- Interrupt Verification

---

# Author

**Kiran Gorajanal**

Electronics & Communication Engineering Graduate

ASIC Design & Verification Enthusiast

- GitHub: https://github.com/Kiran-G
- LinkedIn: *(Add your profile)*
- Email: kgorajanal@gmail.com

---

## License

This project is released under the **MIT License**.

---

⭐ If you found this repository useful, consider giving it a **Star**.
