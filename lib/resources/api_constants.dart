const baseUrl = 'https://gatewaylicensing-qa.tecnologiatransaccional.com';

const loginPath = '/controldashboard/web/v1/User/Login';
const createCompanyPath = '/controldashboard/web/v1/Company';
const getCompaniesPath =
    '/controldashboard/web/v1/Company/GetAll/false?PageNumber=1&PageSize=10';
const createCompanyLicensesPath = '/controldashboard/web/v1/License';
const getCompanyLicensesPath = '/controldashboard/web/v1/License/GetAll';
const createUserPath = '/controldashboard/web/v1/User';
const getUsersPath =
    '/controldashboard/web/v1/User/GetAll/false?PageNumber=1&PageSize=10';
const getDashboardsPath =
    '/controldashboard/web/v1/Dashboard/GetAll/true?PageNumber=1&PageSize=10';
const getDashboardByCompanyIdPath =
    '/controldashboard/web/v1/Dashboard/GetDashboardsByCompanyId/';
const getLicensesFromCompanyPath =
    '/controldashboard/web/v1/License/GetAll?PageNumber=1&PageSize=10&all=false&assigned=true&';
const getUserDetailsPath = '/controldashboard/web/v1/User/Get/';
const updateCompanyLogoPath = '/controldashboard/web/v1/Company/UpdateLogo/';
