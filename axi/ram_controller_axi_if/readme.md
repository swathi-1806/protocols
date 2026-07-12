# AXI4-Lite RAM Controller Verification using UVM

## Project Overview
* This project implements and verifies a simple **AXI-based RAM Controller** using **SystemVerilog** and **UVM (Universal Verification Methodology)**.
 
* The RAM Controller acts as an **AXI Slave**, receives read/write requests from an AXI Master, and communicates with a simple RAM model through a custom RAM interface.

* The verification environment is developed using UVM and demonstrates the complete verification flow including sequences, driver, monitor, scoreboard, and functional tests.

---

## Project Architecture

```
                +----------------------+
                |      AXI Master      |
                | (UVM Driver/BFM)     |
                +----------+-----------+
                           |
                    AXI Interface
                           |
                           v
                +----------------------+
                |    RAM Controller    |
                |      (DUT)           |
                +----------+-----------+
                           |
                    RAM Interface
                           |
                           v
                +----------------------+
                |      RAM Model       |
                +----------------------+
```

---

## Features

- Single-beat AXI read transactions
- Single-beat AXI write transactions
- Separate Read and Write FSMs
- AXI Handshake Protocol
- Simple synchronous RAM model
- UVM-based verification environment
- Reference memory scoreboard
- Randomized transactions
- Modular and reusable verification components

---

## AXI Channels Implemented

### Write Address Channel (AW)

- AWID
- AWADDR
- AWLEN
- AWSIZE
- AWBURST
- AWLOCK
- AWCACHE
- AWPROT
- AWVALID
- AWREADY

---

### Write Data Channel (W)

- WDATA
- WSTRB
- WLAST
- WVALID
- WREADY

---

### Write Response Channel (B)

- BID
- BRESP
- BVALID
- BREADY

---

### Read Address Channel (AR)

- ARID
- ARADDR
- ARLEN
- ARSIZE
- ARBURST
- ARLOCK
- ARCACHE
- ARPROT
- ARVALID
- ARREADY

---

### Read Data Channel (R)

- RID
- RDATA
- RRESP
- RLAST
- RVALID
- RREADY

---

## RAM Interface

The RAM Controller communicates with the RAM model using a simple interface.

Signals:

| Signal | Description |
|---------|-------------|
| wr_rd | Read/Write control |
| ram_addr | RAM Address |
| ram_wdata | Data to RAM |
| ram_rdata | Data from RAM |

---

## RTL Modules

### ram_controller.sv

Implements

- AXI Slave Interface
- Write FSM
- Read FSM
- RAM Interface Control

---

### ram_model.v

Simple synchronous memory model

- 16 memory locations
- 32-bit data width

---

### axi_if.sv

AXI Interface containing all AXI signals used between DUT and verification environment.

---

### ram_if.sv

Simple RAM interface definition.

---

## UVM Testbench Architecture

```
                     Test
                       |
                 Base Test
                       |
                  Environment
                  /         \
             Agent      Scoreboard
               |
        -------------------
        |        |        |
   Sequencer  Driver   Monitor
        |
    Sequences
```

---

## UVM Components

### Transaction

- `axi_tx`

Contains

- Read transaction fields
- Write transaction fields
- Constraints
- Randomization

---

### Sequencer

- `axi_sequencer`

Supplies sequence items to the driver.

---

### Driver

- Converts transaction objects into AXI pin-level activity.
- Drives AXI Read and Write channels.
- Performs AXI handshaking.

---

### Monitor

Passively monitors DUT signals.

Captures

- Write Transactions
- Read Transactions

Sends collected transactions to the scoreboard.

---

### Agent

Contains

- Driver
- Sequencer
- Monitor

Connects Driver and Sequencer.

---

### Scoreboard

Implements a simple reference memory.

For every

- Write → Updates reference memory
- Read → Compares DUT output with expected value

Reports

- PASS
- FAIL

---

### Environment

Contains

- AXI Agent
- Scoreboard

Connects Monitor Analysis Port to Scoreboard.

---

## Testcase 
### write_test
Performs randomized AXI write transactions.
<img width="1770" height="265" alt="image" src="https://github.com/user-attachments/assets/85dfb95b-2d97-4655-b024-1cd0bc2677aa" />

<img width="1765" height="133" alt="image" src="https://github.com/user-attachments/assets/759d433a-adb7-4ead-b7b9-13cf965141c3" />

<img width="1762" height="273" alt="image" src="https://github.com/user-attachments/assets/37f2cb16-f6e8-444d-8fcd-8b6a23662159" />

<img width="1762" height="78" alt="image" src="https://github.com/user-attachments/assets/7f45d8bf-ca7d-49bc-8dac-517bda56b73f" />



---
### wr_rd_test
Performs randomized AXI write and read transactions.
<img width="1807" height="255" alt="image" src="https://github.com/user-attachments/assets/dd00adde-a9d5-4cb7-ae7b-7eb7177f3fff" />
<img width="1795" height="277" alt="image" src="https://github.com/user-attachments/assets/f26dd973-a696-47ac-8ec4-5df43e4103fa" />
<img width="1796" height="32" alt="image" src="https://github.com/user-attachments/assets/4ab76148-19ad-4f37-bb01-49f0d2965e81" />
<img width="1797" height="30" alt="image" src="https://github.com/user-attachments/assets/c82c5fbe-84fd-4284-902a-aa9531f08bdd" />
<img width="1795" height="281" alt="image" src="https://github.com/user-attachments/assets/c0c11fe5-81cb-4684-a8df-b2fdd4fa1056" />
<img width="1796" height="236" alt="image" src="https://github.com/user-attachments/assets/4a777a78-73a3-4b13-9568-99581cf7acc7" />
<img width="1798" height="57" alt="image" src="https://github.com/user-attachments/assets/c7cd9b7c-8df8-40a0-af18-f056a022ba13" />


---

### random_test
Generates a mix of random read and write transactions.

---

## Sequences

### write_sequence
Generates only write transactions.

---

### read_sequence
Generates only read transactions.

---

### random_sequence
Generates both read and write transactions.

---

## Verification Flow

```
Sequence
    ↓
Sequencer
    ↓
Driver
    ↓
AXI Interface
    ↓
RAM Controller (DUT)
    ↓
RAM Model

Monitor
    ↓
Scoreboard
```

---

## Simulation

Top-level files

- top.sv
- tb_top.sv

Simulation includes

- Clock generation
- Reset generation
- Virtual interface configuration
- UVM test execution
- Waveform dump

---


---

## Current Limitations

- Supports only single-beat transfers (`AWLEN = 0`, `ARLEN = 0`)
- No burst transfers
- No multiple outstanding transactions
- No AXI IDs management
- No coverage collection
- No assertions
- Simple reference-memory scoreboard
- No functional coverage

---

## Future Improvements

- Burst read/write support
- Multiple outstanding transactions
- Functional Coverage
- SystemVerilog Assertions (SVA)
- Protocol Checker
- AXI VIP comparison
- Register Layer (RAL)
- Constrained random verification
- Error response verification
- Performance testing

---

## Learning Objectives

This project demonstrates:

- AXI protocol fundamentals
- AXI handshaking
- FSM-based controller design
- RAM interface design
- UVM component hierarchy
- Transaction-level modeling
- Driver and monitor implementation
- Scoreboard-based checking
- Random stimulus generation
- End-to-end RTL verification

---

