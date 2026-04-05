/// Placeholder access token stored when [AppConfig.bypassAuth] is enabled.
/// Not a real JWT; API calls that require the backend will still fail.
const String kDevBypassAccessToken = '__dev_bypass__';
