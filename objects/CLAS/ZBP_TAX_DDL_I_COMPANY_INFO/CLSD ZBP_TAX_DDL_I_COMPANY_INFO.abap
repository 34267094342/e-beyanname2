class-pool .
*"* class pool for class ZBP_TAX_DDL_I_COMPANY_INFO

*"* local type definitions
include ZBP_TAX_DDL_I_COMPANY_INFO====ccdef.

*"* class ZBP_TAX_DDL_I_COMPANY_INFO definition
*"* public declarations
  include ZBP_TAX_DDL_I_COMPANY_INFO====cu.
*"* protected declarations
  include ZBP_TAX_DDL_I_COMPANY_INFO====co.
*"* private declarations
  include ZBP_TAX_DDL_I_COMPANY_INFO====ci.
endclass. "ZBP_TAX_DDL_I_COMPANY_INFO definition

*"* macro definitions
include ZBP_TAX_DDL_I_COMPANY_INFO====ccmac.
*"* local class implementation
include ZBP_TAX_DDL_I_COMPANY_INFO====ccimp.

*"* test class
include ZBP_TAX_DDL_I_COMPANY_INFO====ccau.

class ZBP_TAX_DDL_I_COMPANY_INFO implementation.
*"* method's implementations
  include methods.
endclass. "ZBP_TAX_DDL_I_COMPANY_INFO implementation
