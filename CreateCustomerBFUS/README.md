#CreateCustomerBFUS

##Info
This app is a supplement to the big LIME - BFUS integration that gathers data from BFUS and writes it to LIME. It could however, from a technical standpoint, also be used separately.

The app lets the user create a LIME Pro prospect customer in BFUS. The customer will then automatically be part of the main integration. It is also possible to udpate some data in LIME Pro and send it to BFUS.

If BFUS already has a customer with the same organizational number or civic registration number, the user will receive a warning. It is possible for the user to override that warning by clicking the Yes button that is automatically shown in case of a warning. LIME Pro will then resend the customer with a flag lettning BFUS know that it should suppress the registration number warning.

###Important Notices
* The BFUS version must be 6.1 or higher.
* In the current version, the app only says that there is information missing on the customer record if BFUS returns an error claiming that some required information is not provided. A future improvement of the app could be adding support for showing to the user which information BFUS wants.
* BFUS does not support updates of the address on an existing customer.
* BFUS does not accept combinations of zip code and city where either the zip code or the city is already used in another combination in BFUS. A future improvement of the BFUS side of the integration discussed is that this will generate a warning that can be overrun by the end user instead. The app is somewhat prepared for this. You would need to set the correct BFUS warning in the parameter BFUSWarnings.Address.

##Install
1. Add the app folder to your Actionpad folder.
2. Add the following localize records:
*	app_CreateCustomerBFUS.btnCreate
*	app_CreateCustomerBFUS.btnUpdate
*	app_CreateCustomerBFUS.loader
*	app_CreateCustomerBFUS.i_sentToBFUS
*	app_CreateCustomerBFUS.e_recordNotSaved
*	app_CreateCustomerBFUS.e_couldNotSend
*	app_CreateCustomerBFUS.e_missingData
*	app_CreateCustomerBFUS.btnWarningYes
*	app_CreateCustomerBFUS.btnWarningNo
*	app_CreateCustomerBFUS.warningTextPinCode
*	app_CreateCustomerBFUS.warningTextCompanyCode
*	app_CreateCustomerBFUS.warningTextAddressCreate
*	app_CreateCustomerBFUS.warningTextAddressUpdate
3. Add the VBA module app_CreateCustomerBFUS.
4. Remove the readonly setting done in VBA if the customer is integrated with BFUS on the fields that can be updated in BFUS by this app. Currently these are (stated by BFUS API name):
* FirstName
* LastName
* AcceptEMail
* EMail1
* EMail2
* EMail3
* AcceptSMS
* All phone numbers integrated.



##Setup
Use the below JSON configuration to instantiate the app.
```html
<div data-app="{app:'CreateCustomerBFUS',
				config:{
					baseURI: 'http://...',
					ewiKey: '...',
					crossDomainCall: true,
					fieldMappings: {
						'FirstName': 'firstname',
						'LastName': 'lastname',	
						'IsBusinessCustomer': 'category',
						'PinCode': 'orgnr',
						'CompanyCode': 'orgnr',
						'AcceptEMail': 'accepts_email',
						'EMail1': 'email1',
						'EMail2': 'email2',
						'EMail3': 'email3',
						'AcceptSMS': 'accepts_sms',
						'Phones': [
							{
								'PhoneTypeId': 10980000,
								'Number': 'phone2'
							},
							{
								'PhoneTypeId': 10980100,
								'Number': 'fax'
							},
							{
								'PhoneTypeId': 10980200,
								'Number': 'phonemisc'
							},
							{
								'PhoneTypeId': 10980300,
								'Number': 'phone1'
							},
							{
								'PhoneTypeId': 10980500,
								'Number': 'mobile'
							}
						],
						'Addresses': [
							{
								'AddressTypeId': 10090000,
								'StreetName': 'invoicestreet',
								'StreetQualifier': 'invoicestreet',
								'StreetNumberSuffix': 'invoicestreet',
								'PostOfficeCode': 'invoicezipcode',
								'City': 'invoicecity',
								'CountryCode': 'country',
								'ApartmentNumber': 'apartmentnumber',
								'FloorNumber': 'floornumber',
							}
						]
					}
				}
				}"></div>
```

###Phone Numbers
In BUFS it is possible to create new custom Phone Types. The main integration (that updates LIME Pro based on BFUS data) retreives the types defined in the example configuration JSON shown here. If the customer wants to use other Phone Types they must be changed both in the main integration and in the configuration JSON for this app. Which Phone Types that exist can be fetched by a GET to `Common/Phone/GetPhoneTypeInformation_v1/<a randomly chosen ExternalId>`. The EWI key must be set just as in the POST to create/update a customer.

###Addresses
The standard address type that is used in the main integration (that updates LIME Pro based on BFUS data) is the one set in the example configuration JSON for this app. If the customer wants to change this, it must be updated in both the main integration and the configuration JSON. Which Address Types that exist can be fetched here `Common/Address/GetAddressTypeInformation_v1/<a randomly chosen ExternalId>`. The EWI key must be set just as in the POST to create/update a customer.`.

The values for `StreetName`, `StreetQualifier` and `StreetNumberSuffix` will be treated according to the following logics:
* *StreetName*: If any of `StreetQualifier` and `StreetNumberSuffix` have been specified as the same field as `StreetName`, then the value from the LIME Pro field will be cut at the last existing space before it is sent to BFUS.
* *StreetQualifier*: If it is the same LIME Pro field as `StreetName` then that string will be cut at the last space and the value passed will be the numeric value of the last part of the string. Otherwise, if it is the same LIME Pro field as `StreetNumberSuffix`, that string will have everything but the numerical values removed before sending to BFUS.
* *StreetNumberSuffix*: If it is the same LIME Pro field as `StreetName` then that string will be cut at the last space and the value passed will be the string that is left when all numeric values have been removed from the string. Otherwise, if it is the same LIME Pro field as `StreetQualifier`, that string will have the numerical values removed before sending to BFUS.