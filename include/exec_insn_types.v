// exec_defs.v

// ARITHMETIC

`define AR_TYPE 4'b0000

// ---------------------- //

`define AR_LUI     4'b0000
`define AR_SLT     4'b0001
`define AR_GENERAL 4'b0010
`define AR_AUIPC   4'b0011

// ---------------------- //





// DIRECT BRANCH

`define DB_TYPE 4'b0001

// ---------------------- //

`define DB_BEQ    4'b0000
`define DB_BNE    4'b0001
`define DB_BLT    4'b0010
`define DB_BGE    4'b0011
`define DB_JAL    4'b0100

// ---------------------- //






// LOAD

`define L_TYPE 4'b0010

// ---------------------- //

`define L_B  4'b0000
`define L_BU 4'b0001
`define L_H  4'b0010
`define L_HU 4'b0011
`define L_W  4'b0100

// ---------------------- //





// STORE

`define S_TYPE 4'b0011

// ---------------------- //

`define S_B 4'b0000
`define S_H 4'b0001
`define S_W 4'b0010

// ---------------------- //




// INDIRECT BRANCH

`define IB_TYPE 4'b0100

// ---------------------- //

`define IB_JALR 4'b0000



