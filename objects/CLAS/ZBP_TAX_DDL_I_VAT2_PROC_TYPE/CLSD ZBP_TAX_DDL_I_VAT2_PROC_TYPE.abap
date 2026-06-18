class-pool .
*"* class pool for class ZBP_TAX_DDL_I_VAT2_PROC_TYPE

*"* local type definitions
include ZBP_TAX_DDL_I_VAT2_PROC_TYPE==ccdef.

*"* class ZBP_TAX_DDL_I_VAT2_PROC_TYPE definition
*"* public declarations
  include ZBP_TAX_DDL_I_VAT2_PROC_TYPE==cu.
*"* protected declarations
  include ZBP_TAX_DDL_I_VAT2_PROC_TYPE==co.
*"* private declarations
  include ZBP_TAX_DDL_I_VAT2_PROC_TYPE==ci.
endclass. "ZBP_TAX_DDL_I_VAT2_PROC_TYPE definition

*"* macro definitions
include ZBP_TAX_DDL_I_VAT2_PROC_TYPE==ccmac.
*"* local class implementation
include ZBP_TAX_DDL_I_VAT2_PROC_TYPE==ccimp.

*"* test class
include ZBP_TAX_DDL_I_VAT2_PROC_TYPE==ccau.

class ZBP_TAX_DDL_I_VAT2_PROC_TYPE implementation.
*"* method's implementations
  include methods.
endclass. "ZBP_TAX_DDL_I_VAT2_PROC_TYPE implementation
