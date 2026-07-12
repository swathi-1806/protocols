https://www.edaplayground.com/x/CAbS

Ethernet Protocol Verification using UVM

Objective:

Verify Ethernet frame transmission and reception between Ethernet nodes based on the Ethernet protocol.

                           Ethernet Medium
                 -----------------------------------

             Master Node                  Slave Node

        +----------------+          +----------------+
        | Master Agent   |          | Slave Agent    |
        |                |          |                |
        | Sequencer      |          |                |
        | Driver         |--------->| Monitor        |
        | Monitor        |          |                |
        +----------------+          +----------------+

                       |
                       |
                  Scoreboard

When the master wants to send to Slave 2:

tx.src_mac = master_mac;
tx.dst_mac = slave2_mac;

The Slave 2 monitor checks:
if (tx.dst_mac == slave2_mac)
    // Accept the frame
else
    // Drop the frame

//==================================

MII sends 4 bits (a nibble) per clock.
GMII sends 8 bits (1 byte) per clock.
RGMII sends 4 bits on both clock edges, effectively transferring a byte over one clock cycle.

For our learning project, we'll use an 8-bit byte-stream interface, because it's much simpler while still accurately representing the Ethernet frame format and protocol behavior.
