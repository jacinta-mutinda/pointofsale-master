const rootUrl = 'https://nawiriapp.pythonanywhere.com/api/';

// Customer Urls --------------------------------------

const getCustomersUrl = '$rootUrl/getCustomers';
const addCustomerUrl = '$rootUrl/addCustomer';
const updateCustomerUrl = '$rootUrl/updateCustomer';

const getCustReceiptsUrl = '$rootUrl/getReceiptByCustomerID';
const addCustReceiptUrl = '$rootUrl/Customerreceipt';

// Category Urls --------------------------------------

const getCategoriesUrl = '$rootUrl/categories';
const addCategoryUrl = '$rootUrl/categories';
const updateCatUrl = '$rootUrl/updateCategory';

// Products Urls --------------------------------------

const getProductsUrl = '$rootUrl/products_all';
const addProductUrl = '$rootUrl/add_product';
const updateProdUrl = '$rootUrl/updateCategory';

// UoMs Urls --------------------------------------

const getUoMsUrl = '$rootUrl/getUom';
const addUoMUrl = '$rootUrl/addUom';
const updateUomUrl = '$rootUrl/updateUom';

// Bank Accounts Urls ----------------------------------

const getBankAccsUrl = '$rootUrl/banks';
const addBankAccUrl = '$rootUrl/addbank';
const updateBankUrl = '$rootUrl/updateBank';

const addBankTransUrl = '$rootUrl/addBankTransaction';
const getBankTransUrl = '$rootUrl/getBanksTrans';

// Expenses Urls --------------------------------------

const getExpensesUrl = '$rootUrl/getExpenses';
const addExpenseUrl = '$rootUrl/addExpense';

// Suppliers Urls --------------------------------------

const getSupplierUrl = '$rootUrl/supplier';
const addSupplierUrl = '$rootUrl/add_Supplier';
const updateSupUrl = '$rootUrl/updateSupplier';

const addSupPayUrl = '$rootUrl/paySupplier';
const getSupPayUrl = '$rootUrl/getTransactionsBySupplierID';

// PoS Urls --------------------------------------

const addCheckoutUrl = '$rootUrl/checkout';

// Auth Urls --------------------------------------
const addCompanyUrl = '$rootUrl/addCompany';
const signUpUrl = '$rootUrl/join';
const loginUrl = '$rootUrl/login';

// Drawer Urls
const getShiftSalesUrl = '$rootUrl/getSalesByShifts';
const getShiftFloat = '$rootUrl/getFloatsByShifts';
