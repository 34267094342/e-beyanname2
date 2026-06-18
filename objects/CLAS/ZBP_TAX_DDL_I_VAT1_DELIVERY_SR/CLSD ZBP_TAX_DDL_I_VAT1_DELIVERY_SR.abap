class-pool .
*"* class pool for class ZBP_TAX_DDL_I_VAT1_DELIVERY_SR

*"* local type definitions
include ZBP_TAX_DDL_I_VAT1_DELIVERY_SRccdef.

*"* class ZBP_TAX_DDL_I_VAT1_DELIVERY_SR definition
*"* public declarations
  include ZBP_TAX_DDL_I_VAT1_DELIVERY_SRcu.
*"* protected declarations
  include ZBP_TAX_DDL_I_VAT1_DELIVERY_SRco.
*"* private declarations
  include ZBP_TAX_DDL_I_VAT1_DELIVERY_SRci.
endclass. "ZBP_TAX_DDL_I_VAT1_DELIVERY_SR definition

*"* macro definitions
include ZBP_TAX_DDL_I_VAT1_DELIVERY_SRccmac.
*"* local class implementation
include ZBP_TAX_DDL_I_VAT1_DELIVERY_SRccimp.

*"* test class
include ZBP_TAX_DDL_I_VAT1_DELIVERY_SRccau.

class ZBP_TAX_DDL_I_VAT1_DELIVERY_SR implementation.
*"* method's implementations
  include methods.
endclass. "ZBP_TAX_DDL_I_VAT1_DELIVERY_SR implementation
