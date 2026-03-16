# FUNDEX

# API 相关报文数据

## 来源与范围（重要）

- 基金/会员相关（含登录、注册、用户资料）接口来源以 funding Swagger 为准（双分支）：
  - Swagger UI: `https://sit-admin.gutingjun.com/api/swagger-ui.html#/`
  - OpenAPI JSON（crowdfunding）: `https://sit-admin.gutingjun.com/api/crowdfunding/v2/api-docs`
  - OpenAPI JSON（member）: `https://sit-admin.gutingjun.com/api/member/v2/api-docs`
- 选型规则：
  - `/crowdfunding/**` 接口优先以 `crowdfunding` 分支定义为准。
  - `/member/**` 接口优先以 `member` 分支定义为准。
  - 若接口仅在某一个分支有定义，则以该分支实现，并在代码注释中标记来源。
- 用户相关主要查看：
  - `user-rest`
  - `off-rest`
  - member 分支对应用户接口定义
- 除酒店业务外，后续 API 实现不再以老工程 `http_conf.dart` 作为来源。
- 本文件的作用是补充“真实请求/响应样例报文”，用于 DTO/错误处理/兼容性测试；若与 Swagger 冲突，以 Swagger 为准，并在此文件更新样例。

- 1.登录与Token 获取
  - [HTTP] REQ POST:
  https://testoa.gutingjun.com/api/uaa/oauth/token 
  headers={content-type: application/x-www-form-urlencoded, Authorization: ***} query={} body={"password":"2508","username":"Aaron.hou@51fanxing.co.jp","grant_type":"password","auth_type":"email","scope":"app"}

  - Response:
  {"msg":"success","code":200,"data":
    {
      "access_token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJBYXJvbi5ob3VANTFmYW54aW5nLmNvLmpwIiwibWVtYmVyTGV2ZWwiOjEwLCJzY29wZSI6WyJhcHAiXSwibW9iaWxlIjpudWxsLCJ1c2VuYW1lIjoiQWFyb24uaG91QDUxZmFueGluZy5jby5qcCIsImV4cCI6MTc3MTk2NDkyNCwidXNlcklkIjoxMjY1NzUsImF1dGhvcml0aWVzIjpbIm1lbWJlciIsInN1cGVyIiwiYWRtaW4iLCJlbXBsb3llZSJdLCJqdGkiOiJiYmMwYzc2Ni1jNzI0LTQ4YTMtOWQ3MS0yMGIwOGMzMmE4ZTIiLCJjbGllbnRfaWQiOiJ3ZWJBcHAiLCJpbnRsVGVsQ29kZSI6IiJ9.hDSOxrqI76lEAVIfoB1MzCT21Bt0Ik5ppir21S2e-mI",
      "token_type" : "bearer",
      "refresh_token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJBYXJvbi5ob3VANTFmYW54aW5nLmNvLmpwIiwibWVtYmVyTGV2ZWwiOjEwLCJzY29wZSI6WyJhcHAiXSwiYXRpIjoiYmJjMGM3NjYtYzcyNC00OGEzLTlkNzEtMjBiMDhjMzJhOGUyIiwibW9iaWxlIjpudWxsLCJ1c2VuYW1lIjoiQWFyb24uaG91QDUxZmFueGluZy5jby5qcCIsImV4cCI6MTc3NDUxMzcyNCwidXNlcklkIjoxMjY1NzUsImF1dGhvcml0aWVzIjpbIm1lbWJlciIsInN1cGVyIiwiYWRtaW4iLCJlbXBsb3llZSJdLCJqdGkiOiJjNmY1YzhjNy0zYTkwLTQyMzQtYjJlYi1hNTg2MDFhMTQ1NzkiLCJjbGllbnRfaWQiOiJ3ZWJBcHAiLCJpbnRsVGVsQ29kZSI6IiJ9._5KHCNChlLhXL20PLmyi-IGfODZzVxE9rJgt7h8Bgb0",
      "expires_in" : 43199,
      "scope" : "app",
      "mobile" : null,
      "usename" : "Aaron.hou@51fanxing.co.jp",
      "userId" : 126575,
      "memberLevel" : 10,
      "intlTelCode" : "",
      "jti" : "bbc0c766-c724-48a3-9d71-20b08c32a8e2"
    }
  }

- 2.获取用户数据
  [HTTP] REQ GET https://testoa.gutingjun.com/api/crowdfunding/user/index-new
  authorization:
  bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiIwODAwMDAwMDAwMyIsIm1lbWJlckxld....
  
  - Response:
  {
    "msg": "success",
    "code": 200,
    "data": {
        "id": "438786029784006656",
        "memberId": 125530,
        "accountId": "0125530",
        "email": "dennis.diao@51fanxing.co.jp",
        "firstName": "张",
        "lastName": "冠李戴",
        "firstNameEn": "AAAAA",
        "lastNameEn": "DDDDD",
        "katakana": "カタカナd",
        "taxRadio": 0.2042,
        "expiredTime": "2026-03-05",
        "taxcountry": "日本",
        "nationality": "中国",
        "taxOffice": "",
        "sex": 1,
        "liveJp": 1,
        "intlTelCode": 81,
        "phone": "09085309521",
        "birthday": "1994-02-10",
        "zipCode": "5370011",
        "address": "東今里１－７－２４",
        "bank": null,
        "registerTime": "2023-01-16 11:25:44",
        "checkEmailTime": "2023-01-16 11:28:48",
        "baseinfoTime": "2024-05-16 13:09:27",
        "checkBaseinfoTime": "2024-05-16 13:16:21",
        "status": 4,
        "frontUrl": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/id/438786171462615040.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260226T042621Z&X-Amz-SignedHeaders=host&X-Amz-Expires=38018&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260226%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=4bedcaccdd8d51ca902140f1952bc9d04272105ec47b012b47bb9b9630fd3af9",
        "backUrl": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/id/438786171516616704.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260226T042621Z&X-Amz-SignedHeaders=host&X-Amz-Expires=38018&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260226%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=c52f63b8b9a99dba6f857c020ffb59e8d392516eba6b6ba52d7f18621c69e2f1",
        "taxpayerNumber": "",
        "taxpayerManageStatus": 1
    }
}

- 10.RealPersonRest（实人认证，来源：member Swagger）

  - OpenAPI JSON: `https://sit-admin.gutingjun.com/api/member/v2/api-docs`
  - Tag: `RealPersonRest`

  1. `GET /member/real/person/token`
    - Query: `bizId` (required)
    - Response: `R<string>` (`data` 为 token)

  2. `GET /member/real/person/result`
    - Query: `bizId` (required)
    - Response: `R<object>`

  3. `GET /member/real/person/image`
    - Query: `userId` (required)
    - Response: `R<object>`

  4. `POST /member/real/person/upload`
    - Body: `multipart/form-data` (`file` required)
    - Response: `R<object>`

  5. `POST /member/real/person/upload/userId`
    - Body: `multipart/form-data` (`file` required)
    - Response: `R<object>`

  6. `POST /member/real/person/identify`
    - Body(JSON):
      - `photo`: base64 字符串（required）
      - `groupId`: string（optional）
    - Response: `R<object>`
    - 参考旧工程校验逻辑：`code == 200` 且 `data.userId` 非空视为识别成功。

- 3.注册
  - 待补：请按 funding Swagger（`user-rest` / `off-rest`）实际接口定义与真实报文补充。

- 4.获取验证码
  - [HTTP] REQ GET https://testoa.gutingjun.com/api/member/user/emailLoginCode?email=Aaron.hou%4051fanxing.co.jp headers={content-type: application/json} query={email: Aaron.hou@51fanxing.co.jp} body=null

  - Response:
  {"msg":"success","code":200,"data":true}

- 5.获取Fund 产品列表

Request URL
https://testoa.gutingjun.com/api/crowdfunding/offline/project/list
Request Method GET

Response
{
    "msg": "success",
    "code": 200,
    "data": [
        {
            "id": "453461223669231137",
            "projectName": "繁星優選Fund商品20241123",
            "expectedDistributionRatioMax": 0.02,
            "expectedDistributionRatioMin": 0.01,
            "expectedDistributionRatioTaxMax": null,
            "expectedDistributionRatioTaxMin": null,
            "investmentPeriod": "１４ヶ月",
            "scheduledStartDate": "2024-05-01",
            "scheduledEndDate": "2026-09-30",
            "distributionDate": null,
            "typeOfOffering": null,
            "offeringStartDatetime": "2024-03-15 12:00:00",
            "offeringEndDatetime": "2024-04-30 17:59:00",
            "offeringMethod": null,
            "investmentUnit": 100000,
            "maximumInvestmentPerPerson": 100,
            "createTime": "2024-12-03 19:12:04",
            "achievementRate": 1.01,
            "amountApplication": 10000000,
            "currentlySubscribed": 10100000,
            "daysRemaining": 0,
            "photos": [],
            "investorTypeList": [
                {
                    "id": "45045227042211224",
                    "projectId": "453461223669231137",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": 5000000
                },
                {
                    "id": "45045227042211125",
                    "projectId": "453461223669231137",
                    "investorType": "BORROWING",
                    "investorCode": "優先出資者B",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.055,
                    "interestRadio": 0.055,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": 3000000
                },
                {
                    "id": "45045227042211125",
                    "projectId": "453461223669231137",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者B",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.055,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": 3000000
                },
                {
                    "id": "45045227042111126",
                    "projectId": "453461223669231137",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者C",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.05,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": 2000000
                }
            ],
            "projectStatus": 4,
            "operatingCompany": "運営会社",
            "operatingCompanyAccount": 127005,
            "createUser": "刁文阳",
            "updateTime": "2024-12-12 15:16:36",
            "currentOpenInvestor": null,
            "updateUser": "刁文阳",
            "detail": "{}",
            "times": 10,
            "pdfs": [
                {
                    "projectId": "453461223669231137",
                    "type": 1,
                    "desc": "契約成立前書面",
                    "urls": null
                },
                {
                    "projectId": "453461223669231137",
                    "type": 2,
                    "desc": "電子取引に係る重要事項説明書",
                    "urls": null
                },
                {
                    "projectId": "453461223669231137",
                    "type": 3,
                    "desc": "契約成立時書面",
                    "urls": null
                }
            ],
            "liveJapanBank": {
                "id": null,
                "bankType": null,
                "relatedId": null,
                "bankAccountOwnerName": null,
                "bankAccountOwnerAddress": null,
                "bankAccountOwnerNationality": null,
                "bankAccountSwiftCode": null,
                "bankName": null,
                "branchBankName": null,
                "branchBankAddress": null,
                "bankCountry": null,
                "branchBankNumber": null,
                "bankNumber": null,
                "bankAccountType": null,
                "liveType": null
            },
            "notLiveJapanBank": {
                "id": null,
                "bankType": null,
                "relatedId": null,
                "bankAccountOwnerName": null,
                "bankAccountOwnerAddress": null,
                "bankAccountOwnerNationality": null,
                "bankAccountSwiftCode": null,
                "bankName": null,
                "branchBankName": null,
                "branchBankAddress": null,
                "bankCountry": null,
                "branchBankNumber": null,
                "bankNumber": null,
                "bankAccountType": null,
                "liveType": null
            },
            "accountId": "48978",
            "periodType": "SEASON"
        },
        
    ]
}

- 6.fund 项目详情

    - Request URL
    https://testoa.gutingjun.com/api/crowdfunding/offline/project/detail?id=453461223669231137
    Request Method
    GET
    - Response
    {
    "msg": "success",
    "code": 200,
    "data": {
        "id": "453461223669231137",
        "projectName": "繁星優選Fund商品20241123",
        "expectedDistributionRatioMax": 0.02,
        "expectedDistributionRatioMin": 0.01,
        "expectedDistributionRatioTaxMax": null,
        "expectedDistributionRatioTaxMin": null,
        "investmentPeriod": "１４ヶ月",
        "scheduledStartDate": "2024-05-01",
        "scheduledEndDate": "2026-09-30",
        "distributionDate": null,
        "typeOfOffering": null,
        "offeringStartDatetime": "2024-03-15 12:00:00",
        "offeringEndDatetime": "2024-04-30 17:59:00",
        "offeringMethod": null,
        "investmentUnit": 100000,
        "maximumInvestmentPerPerson": 100,
        "createTime": "2024-12-03 19:12:04",
        "achievementRate": 1.01,
        "amountApplication": 10000000,
        "currentlySubscribed": 10100000,
        "daysRemaining": 0,
        "photos": [],
        "investorTypeList": [
            {
                "id": "45045227042211224",
                "projectId": "453461223669231137",
                "investorType": "INVESTMENT",
                "investorCode": "優先出資者A",
                "earningsType": "FLOATING",
                "earningsRadio": 0.0,
                "interestRadio": 0.0,
                "remark": null,
                "isOpen": false,
                "isOpenType": 2,
                "currentAmountApplication": 5000000
            },
            {
                "id": "45045227042211125",
                "projectId": "453461223669231137",
                "investorType": "BORROWING",
                "investorCode": "優先出資者B",
                "earningsType": "FIXED",
                "earningsRadio": 0.055,
                "interestRadio": 0.055,
                "remark": null,
                "isOpen": false,
                "isOpenType": 3,
                "currentAmountApplication": 3000000
            },
            {
                "id": "45045227042211125",
                "projectId": "453461223669231137",
                "investorType": "INVESTMENT",
                "investorCode": "優先出資者B",
                "earningsType": "FIXED",
                "earningsRadio": 0.055,
                "interestRadio": 0.0,
                "remark": null,
                "isOpen": false,
                "isOpenType": 3,
                "currentAmountApplication": 3000000
            },
            {
                "id": "45045227042111126",
                "projectId": "453461223669231137",
                "investorType": "INVESTMENT",
                "investorCode": "優先出資者C",
                "earningsType": "FIXED",
                "earningsRadio": 0.05,
                "interestRadio": 0.0,
                "remark": null,
                "isOpen": false,
                "isOpenType": 2,
                "currentAmountApplication": 2000000
            }
        ],
        "projectStatus": 4,
        "operatingCompany": "運営会社",
        "operatingCompanyAccount": 127005,
        "createUser": "刁文阳",
        "updateTime": "2024-12-12 15:16:36",
        "currentOpenInvestor": null,
        "updateUser": "刁文阳",
        "detail": "{}",
        "times": 10,
        "pdfs": [
            {
                "projectId": "453461223669231137",
                "type": 1,
                "desc": "契約成立前書面",
                "urls": null
            },
            {
                "projectId": "453461223669231137",
                "type": 2,
                "desc": "電子取引に係る重要事項説明書",
                "urls": null
            },
            {
                "projectId": "453461223669231137",
                "type": 3,
                "desc": "契約成立時書面",
                "urls": null
            }
        ],
        "liveJapanBank": {
            "id": null,
            "bankType": null,
            "relatedId": null,
            "bankAccountOwnerName": null,
            "bankAccountOwnerAddress": null,
            "bankAccountOwnerNationality": null,
            "bankAccountSwiftCode": null,
            "bankName": null,
            "branchBankName": null,
            "branchBankAddress": null,
            "bankCountry": null,
            "branchBankNumber": null,
            "bankNumber": null,
            "bankAccountType": null,
            "liveType": null
        },
        "notLiveJapanBank": {
            "id": null,
            "bankType": null,
            "relatedId": null,
            "bankAccountOwnerName": null,
            "bankAccountOwnerAddress": null,
            "bankAccountOwnerNationality": null,
            "bankAccountSwiftCode": null,
            "bankName": null,
            "branchBankName": null,
            "branchBankAddress": null,
            "bankCountry": null,
            "branchBankNumber": null,
            "bankNumber": null,
            "bankAccountType": null,
            "liveType": null
        },
        "accountId": "48978",
        "periodType": "SEASON",
        "apply": null
    }
}

- 7 登录后 用户申购列表
    Request URL
    https://testoa.gutingjun.com/api/crowdfunding/user/apply/list
    Request Method
    POST
    Request payload
    {startPage: 1, limit: 20}

    - response
    {
    "msg": "success",
    "code": 200,
    "data": {
        "total": 11,
        "limit": 20,
        "currentPage": 1,
        "rows": [
            {
                "projecId": "450450835221118978",
                "secondaryMarketSellId": "453396674568650752",
                "fromProcessId": "1657646",
                "investorCode": "優先出資者A",
                "investorType": {
                    "id": "450452278402220034",
                    "projectId": "450450835221118978",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FIXED_FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": null
                },
                "projectName": "「TEST_」繁星優選Fund第1号商品",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 2,
                "applyNum": 1,
                "applyMoney": 950000,
                "feeRatio": 0.0135,
                "sellerFeeRatio": 0.0125,
                "applyTime": "2024-11-08 11:40:31",
                "passNum": 1,
                "passMoney": 950000,
                "passTime": "2024-11-08 11:43:06",
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2668676",
                "flowDetail": null,
                "serviceFee": 0
            },
            {
                "projecId": "450450835221118978",
                "secondaryMarketSellId": "453396674568650752",
                "fromProcessId": "1657646",
                "investorCode": "優先出資者A",
                "investorType": {
                    "id": "450452278402220034",
                    "projectId": "450450835221118978",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FIXED_FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": null
                },
                "projectName": "「TEST_」繁星優選Fund第1号商品",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 2,
                "applyNum": 1,
                "applyMoney": 950000,
                "feeRatio": 0.0117,
                "sellerFeeRatio": 0.0127,
                "applyTime": "2024-10-23 11:33:30",
                "passNum": 1,
                "passMoney": 950000,
                "passTime": "2024-10-30 15:34:44",
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2665171",
                "flowDetail": null,
                "serviceFee": 0
            },
            {
                "projecId": "450450835221118978",
                "secondaryMarketSellId": "453396674568650752",
                "fromProcessId": "1657646",
                "investorCode": "優先出資者A",
                "investorType": {
                    "id": "450452278402220034",
                    "projectId": "450450835221118978",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FIXED_FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": null
                },
                "projectName": "「TEST_」繁星優選Fund第1号商品",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 3,
                "applyNum": 10,
                "applyMoney": 9500000,
                "feeRatio": 0.0165,
                "sellerFeeRatio": 0.0165,
                "applyTime": "2024-10-22 18:03:55",
                "passNum": 10,
                "passMoney": 9500000,
                "passTime": "2024-10-28 14:20:37",
                "actualArrivalTime": null,
                "investNum": 7,
                "investMoney": 6650000,
                "processId": "2665153",
                "flowDetail": null,
                "serviceFee": 109725
            },
            {
                "projecId": "450450835221118979",
                "secondaryMarketSellId": "453375041109622784",
                "fromProcessId": "1657662",
                "investorCode": "優先出資者A",
                "investorType": {
                    "id": "450452278402220044",
                    "projectId": "450450835221118979",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FIXED_FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": null
                },
                "projectName": "「TEST2」繁星優選Fund第2号商品",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 3,
                "applyNum": 22,
                "applyMoney": 26400000,
                "feeRatio": 0.0117,
                "sellerFeeRatio": 0.0127,
                "applyTime": "2024-10-10 14:55:58",
                "passNum": 22,
                "passMoney": 26400000,
                "passTime": "2024-10-10 14:59:27",
                "actualArrivalTime": null,
                "investNum": 12,
                "investMoney": 14400000,
                "processId": "2665115",
                "flowDetail": null,
                "serviceFee": 168480
            },
            {
                "projecId": "449678867350552576",
                "secondaryMarketSellId": null,
                "fromProcessId": null,
                "investorCode": "元投资人",
                "investorType": {
                    "id": "449678867355009024",
                    "projectId": "449678867350552576",
                    "investorType": "INVESTMENT",
                    "investorCode": "元投资人",
                    "earningsType": "FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": true,
                    "isOpenType": 1,
                    "currentAmountApplication": null
                },
                "projectName": "测试项目240511",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 2,
                "applyNum": 12,
                "applyMoney": 12,
                "feeRatio": 0.0165,
                "sellerFeeRatio": 0.0,
                "applyTime": "2024-05-17 11:19:25",
                "passNum": 12,
                "passMoney": 12,
                "passTime": "2024-10-25 10:21:02",
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2650282",
                "flowDetail": null,
                "serviceFee": 0
            },
            {
                "projecId": "447760959036588033",
                "secondaryMarketSellId": null,
                "fromProcessId": null,
                "investorCode": null,
                "investorType": null,
                "projectName": "测试项目240218",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 3,
                "applyNum": 30,
                "applyMoney": 3000000,
                "feeRatio": 0.0,
                "sellerFeeRatio": 0.0,
                "applyTime": "2024-02-18 13:56:59",
                "passNum": 30,
                "passMoney": 3000000,
                "passTime": "2024-02-18 13:59:04",
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2610371",
                "flowDetail": null,
                "serviceFee": 0
            },
            {
                "projecId": "447760959036588032",
                "secondaryMarketSellId": null,
                "fromProcessId": null,
                "investorCode": null,
                "investorType": null,
                "projectName": "测试项目240216",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 5,
                "applyNum": 30,
                "applyMoney": 3000000,
                "feeRatio": 0.0,
                "sellerFeeRatio": 0.0,
                "applyTime": "2024-02-18 11:11:53",
                "passNum": null,
                "passMoney": null,
                "passTime": null,
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2610172",
                "flowDetail": null,
                "serviceFee": 0
            },
            {
                "projecId": "447505248391921664",
                "secondaryMarketSellId": null,
                "fromProcessId": null,
                "investorCode": null,
                "investorType": null,
                "projectName": "测试项目新大阪项目1",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 5,
                "applyNum": 1,
                "applyMoney": 100000,
                "feeRatio": 0.0,
                "sellerFeeRatio": 0.0,
                "applyTime": "2024-02-16 09:58:45",
                "passNum": null,
                "passMoney": null,
                "passTime": null,
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2610134",
                "flowDetail": null,
                "serviceFee": 0
            },
            {
                "projecId": "447505248391921664",
                "secondaryMarketSellId": null,
                "fromProcessId": null,
                "investorCode": null,
                "investorType": null,
                "projectName": "测试项目新大阪项目1",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 5,
                "applyNum": 1,
                "applyMoney": 100000,
                "feeRatio": 0.0,
                "sellerFeeRatio": 0.0,
                "applyTime": "2024-02-14 16:31:20",
                "passNum": null,
                "passMoney": null,
                "passTime": null,
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2610112",
                "flowDetail": null,
                "serviceFee": 0
            },
            {
                "projecId": "447505248391921664",
                "secondaryMarketSellId": null,
                "fromProcessId": null,
                "investorCode": null,
                "investorType": null,
                "projectName": "测试项目新大阪项目1",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 5,
                "applyNum": 2,
                "applyMoney": 200000,
                "feeRatio": 0.0165,
                "sellerFeeRatio": 0.0,
                "applyTime": "2024-02-14 11:38:24",
                "passNum": null,
                "passMoney": null,
                "passTime": null,
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2610090",
                "flowDetail": null,
                "serviceFee": 0
            },
            {
                "projecId": "447505248391921664",
                "secondaryMarketSellId": null,
                "fromProcessId": null,
                "investorCode": null,
                "investorType": null,
                "projectName": "测试项目新大阪项目1",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": "馬文軍",
                "status": 5,
                "applyNum": 5,
                "applyMoney": 500000,
                "feeRatio": 0.0165,
                "sellerFeeRatio": 0.0,
                "applyTime": "2024-02-14 11:08:33",
                "passNum": null,
                "passMoney": null,
                "passTime": null,
                "actualArrivalTime": null,
                "investNum": 0,
                "investMoney": 0,
                "processId": "2610068",
                "flowDetail": null,
                "serviceFee": 0
            }
        ]
    }
}

- 8 注文照会 
    Request URL
    https://testoa.gutingjun.com/api/crowdfunding/secondary/market/page
    Request Method
    POST
    Payload
    {startPage: 1, limit: 20, userId: 58350}
    - response
    {
    "msg": "success",
    "code": 200,
    "data": {
        "total": 2,
        "limit": 20,
        "currentPage": 1,
        "rows": [
            {
                "id": "453375149503545344",
                "memberId": 58350,
                "fromProcessId": "2665115",
                "investorType": {
                    "id": "450452278402220044",
                    "projectId": "450450835221118979",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FIXED_FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": null
                },
                "projectName": "「TEST2」繁星優選Fund第2号商品",
                "sellNum": 3,
                "soldNum": 0,
                "price": 1000000,
                "status": "VALID",
                "createTime": "2024-10-21 14:35:43",
                "updateTime": "2024-10-21 14:35:43",
                "pdfs": [
                    {
                        "projectId": "450450835221118979",
                        "type": 1,
                        "desc": "契約成立前書面",
                        "urls": [
                            {
                                "name": "????????? SR??801.pdf",
                                "createTime": "2024-10-22 16:36:26",
                                "url": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/project/450450835221118979/453399697362649088.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260304T061508Z&X-Amz-SignedHeaders=host&X-Amz-Expires=31491&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260304%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=cc587661b8d0adb400cc510539e6ccbee674e7b1f69998b50321fdff7ec7a5ce"
                            }
                        ]
                    },
                    {
                        "projectId": "450450835221118979",
                        "type": 2,
                        "desc": "電子取引に係る重要事項説明書",
                        "urls": [
                            {
                                "name": "????????? SR??801.pdf",
                                "createTime": "2024-10-22 16:36:31",
                                "url": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/project/450450835221118979/453399698726060032.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260304T061508Z&X-Amz-SignedHeaders=host&X-Amz-Expires=31491&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260304%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=671279dc498ffc242c010ab3f15d65130d795e4bb00b2cff50da0dadde23dde7"
                            }
                        ]
                    },
                    {
                        "projectId": "450450835221118979",
                        "type": 3,
                        "desc": "契約成立時書面",
                        "urls": [
                            {
                                "name": "????????? SR??801.pdf",
                                "createTime": "2024-10-22 16:36:36",
                                "url": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/project/450450835221118979/453399699963641856.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260304T061508Z&X-Amz-SignedHeaders=host&X-Amz-Expires=31491&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260304%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=a747363225330c135d913a687bd90f03b598fa204e3bae3d813401281350e574"
                            }
                        ]
                    },
                    {
                        "projectId": "450450835221118979",
                        "type": 4,
                        "desc": "財産管理報告書",
                        "urls": null
                    }
                ],
                "applyList": null,
                "applyResultList": null
            },
            {
                "id": "453417597721509888",
                "memberId": 58350,
                "fromProcessId": "2665115",
                "investorType": {
                    "id": "450452278402220044",
                    "projectId": "450450835221118979",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FIXED_FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": null,
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": null
                },
                "projectName": "「TEST2」繁星優選Fund第2号商品",
                "sellNum": 3,
                "soldNum": 0,
                "price": 1000000,
                "status": "VALID",
                "createTime": "2024-10-23 11:34:30",
                "updateTime": "2024-10-23 11:34:30",
                "pdfs": [
                    {
                        "projectId": "450450835221118979",
                        "type": 1,
                        "desc": "契約成立前書面",
                        "urls": [
                            {
                                "name": "????????? SR??801.pdf",
                                "createTime": "2024-10-22 16:36:26",
                                "url": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/project/450450835221118979/453399697362649088.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260304T061508Z&X-Amz-SignedHeaders=host&X-Amz-Expires=31491&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260304%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=cc587661b8d0adb400cc510539e6ccbee674e7b1f69998b50321fdff7ec7a5ce"
                            }
                        ]
                    },
                    {
                        "projectId": "450450835221118979",
                        "type": 2,
                        "desc": "電子取引に係る重要事項説明書",
                        "urls": [
                            {
                                "name": "????????? SR??801.pdf",
                                "createTime": "2024-10-22 16:36:31",
                                "url": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/project/450450835221118979/453399698726060032.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260304T061508Z&X-Amz-SignedHeaders=host&X-Amz-Expires=31491&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260304%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=671279dc498ffc242c010ab3f15d65130d795e4bb00b2cff50da0dadde23dde7"
                            }
                        ]
                    },
                    {
                        "projectId": "450450835221118979",
                        "type": 3,
                        "desc": "契約成立時書面",
                        "urls": [
                            {
                                "name": "????????? SR??801.pdf",
                                "createTime": "2024-10-22 16:36:36",
                                "url": "https://s3-ap-northeast-1.amazonaws.com/gutingjun/ESTATE_SIT/crowdfunding/project/450450835221118979/453399699963641856.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20260304T061508Z&X-Amz-SignedHeaders=host&X-Amz-Expires=31491&X-Amz-Credential=AKIAQCBDBFIFTQ7QHL5V%2F20260304%2Fap-northeast-1%2Fs3%2Faws4_request&X-Amz-Signature=a747363225330c135d913a687bd90f03b598fa204e3bae3d813401281350e574"
                            }
                        ]
                    },
                    {
                        "projectId": "450450835221118979",
                        "type": 4,
                        "desc": "財産管理報告書",
                        "urls": null
                    }
                ],
                "applyList": null,
                "applyResultList": null
            }
        ]
    }
}

- 9 我的投资
    Request URL
    https://testoa.gutingjun.com/api/crowdfunding/user/invest/list
    Request Method
    POST
    Payload
    {startPage: 1, limit: 20}
    {
    "msg": "success",
    "code": 200,
    "data": {
        "total": 8,
        "limit": 20,
        "currentPage": 1,
        "rows": [
            {
                "benefitDetails": null,
                "projectName": "「TEST_」繁星優選Fund第1号商品",
                "investNum": 7,
                "investMoney": 6650000,
                "investNumValid": 7,
                "investMoneyValid": 6650000,
                "investNumRemaining": 7,
                "processId": "2665153",
                "changeToBorrow": 0,
                "investorType": {
                    "id": "450452278402220034",
                    "projectId": "450450835221118978",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FIXED_FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": "優先出資者A",
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": null
                },
                "status": 0,
                "projectStatus": 4,
                "createTime": "2024-10-28 15:01:39",
                "withdrawalTime": null,
                "projectId": "450450835221118978",
                "investorCode": "優先出資者A",
                "earningType": "FIXED_FLOATING",
                "earningRadio": 0.0,
                "remark": "優先出資者A",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": null,
                "hiwariJobs": [
                    {
                        "id": "453534102066429952",
                        "processId": "2665153",
                        "fromProcessId": "2665153",
                        "headId": "452057999914172417",
                        "memberId": 58350,
                        "num": 7,
                        "startDate": "2024-10-28",
                        "endDate": "2024-12-31",
                        "headStartDate": "2024-10-01",
                        "headEndDate": "2024-12-31",
                        "headStatus": 1,
                        "createTime": "2024-10-28 15:01:39",
                        "updateTime": "2024-10-28 15:01:39",
                        "operator": "system"
                    }
                ],
                "earnings": 170238,
                "checkTimes": 0
            },
            {
                "benefitDetails": null,
                "projectName": "「TEST2」繁星優選Fund第2号商品",
                "investNum": 12,
                "investMoney": 14400000,
                "investNumValid": 12,
                "investMoneyValid": 14400000,
                "investNumRemaining": 6,
                "processId": "2665115",
                "changeToBorrow": 0,
                "investorType": {
                    "id": "450452278402220044",
                    "projectId": "450450835221118979",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者A",
                    "earningsType": "FIXED_FLOATING",
                    "earningsRadio": 0.0,
                    "interestRadio": 0.0,
                    "remark": "優先出資者A",
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": null
                },
                "status": 0,
                "projectStatus": 4,
                "createTime": "2024-10-10 15:07:13",
                "withdrawalTime": null,
                "projectId": "450450835221118979",
                "investorCode": "優先出資者A",
                "earningType": "FIXED_FLOATING",
                "earningRadio": 0.0,
                "remark": "優先出資者A",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": null,
                "hiwariJobs": null,
                "earnings": 25000,
                "checkTimes": 0
            },
            {
                "benefitDetails": null,
                "projectName": "「TEST_」繁星優選Fund第1号商品",
                "investNum": 2,
                "investMoney": 2000000,
                "investNumValid": 2,
                "investMoneyValid": 2000000,
                "investNumRemaining": 2,
                "processId": "1657641",
                "changeToBorrow": 0,
                "investorType": {
                    "id": "450452278402220036",
                    "projectId": "450450835221118978",
                    "investorType": "BORROWING",
                    "investorCode": "優先出資者C",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.05,
                    "interestRadio": 0.0321,
                    "remark": "優先出資者C",
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": null
                },
                "status": 0,
                "projectStatus": 4,
                "createTime": "2024-08-24 11:23:37",
                "withdrawalTime": null,
                "projectId": "450450835221118978",
                "investorCode": "優先出資者C",
                "earningType": "FIXED",
                "earningRadio": 0.05,
                "remark": "優先出資者C",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": null,
                "hiwariJobs": null,
                "earnings": 170238,
                "checkTimes": 2
            },
            {
                "benefitDetails": null,
                "projectName": "「TEST_」繁星優選Fund第1号商品",
                "investNum": 1,
                "investMoney": 1000000,
                "investNumValid": 1,
                "investMoneyValid": 1000000,
                "investNumRemaining": 1,
                "processId": "1657641",
                "changeToBorrow": 0,
                "investorType": {
                    "id": "450452278402220036",
                    "projectId": "450450835221118978",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者C",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.05,
                    "interestRadio": 0.0,
                    "remark": "優先出資者C",
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": null
                },
                "status": 0,
                "projectStatus": 4,
                "createTime": "2024-05-20 14:44:40",
                "withdrawalTime": null,
                "projectId": "450450835221118978",
                "investorCode": "優先出資者C",
                "earningType": "FIXED",
                "earningRadio": 0.05,
                "remark": "優先出資者C",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": null,
                "hiwariJobs": null,
                "earnings": 170238,
                "checkTimes": 2
            },
            {
                "benefitDetails": null,
                "projectName": "「TEST2」繁星優選Fund第2号商品",
                "investNum": 3,
                "investMoney": 3000000,
                "investNumValid": 3,
                "investMoneyValid": 3000000,
                "investNumRemaining": 3,
                "processId": "1657657",
                "changeToBorrow": 0,
                "investorType": {
                    "id": "450452278402220046",
                    "projectId": "450450835221118979",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者C",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.05,
                    "interestRadio": 0.0,
                    "remark": "優先出資者C",
                    "isOpen": false,
                    "isOpenType": 3,
                    "currentAmountApplication": null
                },
                "status": 0,
                "projectStatus": 4,
                "createTime": "2024-05-20 14:44:40",
                "withdrawalTime": null,
                "projectId": "450450835221118979",
                "investorCode": "優先出資者C",
                "earningType": "FIXED",
                "earningRadio": 0.05,
                "remark": "優先出資者C",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": null,
                "hiwariJobs": null,
                "earnings": 25000,
                "checkTimes": 0
            },
            {
                "benefitDetails": null,
                "projectName": "「TEST_」繁星優選Fund商品20241016",
                "investNum": 5,
                "investMoney": 5000000,
                "investNumValid": 5,
                "investMoneyValid": 5000000,
                "investNumRemaining": 5,
                "processId": "262044",
                "changeToBorrow": 0,
                "investorType": {
                    "id": "45045227840222036",
                    "projectId": "4504508352211198",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者C",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.05,
                    "interestRadio": 0.0,
                    "remark": "優先出資者C",
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": null
                },
                "status": 0,
                "projectStatus": 4,
                "createTime": "2024-05-20 14:44:40",
                "withdrawalTime": null,
                "projectId": "4504508352211198",
                "investorCode": "優先出資者C",
                "earningType": "FIXED",
                "earningRadio": 0.05,
                "remark": "優先出資者C",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": null,
                "hiwariJobs": null,
                "earnings": 0,
                "checkTimes": 0
            },
            {
                "benefitDetails": null,
                "projectName": "「TEST_」繁星優選Fund第11号商品",
                "investNum": 5,
                "investMoney": 3000,
                "investNumValid": 5,
                "investMoneyValid": 3000,
                "investNumRemaining": 5,
                "processId": "2620854",
                "changeToBorrow": 0,
                "investorType": {
                    "id": "450452278402220146",
                    "projectId": "450450835221118981",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者C",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.05,
                    "interestRadio": 0.0,
                    "remark": "優先出資者C",
                    "isOpen": false,
                    "isOpenType": 0,
                    "currentAmountApplication": null
                },
                "status": 0,
                "projectStatus": 5,
                "createTime": "2024-05-20 14:44:40",
                "withdrawalTime": null,
                "projectId": "450450835221118981",
                "investorCode": "優先出資者C",
                "earningType": "FIXED",
                "earningRadio": 0.05,
                "remark": "優先出資者C",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": null,
                "hiwariJobs": null,
                "earnings": 96,
                "checkTimes": 0
            },
            {
                "benefitDetails": null,
                "projectName": "「TEST_」繁星優選Fund商品20241017",
                "investNum": 5,
                "investMoney": 5000000,
                "investNumValid": 5,
                "investMoneyValid": 5000000,
                "investNumRemaining": 5,
                "processId": "262144",
                "changeToBorrow": 0,
                "investorType": {
                    "id": "4504522784022036",
                    "projectId": "450450835211198",
                    "investorType": "INVESTMENT",
                    "investorCode": "優先出資者C",
                    "earningsType": "FIXED",
                    "earningsRadio": 0.05,
                    "interestRadio": 0.0,
                    "remark": "優先出資者C",
                    "isOpen": false,
                    "isOpenType": 2,
                    "currentAmountApplication": null
                },
                "status": 0,
                "projectStatus": 4,
                "createTime": "2024-05-20 14:44:40",
                "withdrawalTime": null,
                "projectId": "450450835211198",
                "investorCode": "優先出資者C",
                "earningType": "FIXED",
                "earningRadio": 0.05,
                "remark": "優先出資者C",
                "memberId": 58350,
                "accountId": "0058350",
                "memberName": null,
                "hiwariJobs": null,
                "earnings": 0,
                "checkTimes": 0
            }
        ]
    }
}
