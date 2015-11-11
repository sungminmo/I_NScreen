//
//  CMConstants.m
//  I_NScreen
//
//  Created by 조백근 on 2015. 8. 17..
//  Copyright (c) 2015년 STVN. All rights reserved.
//

#import "CMConstants.h"

// 네이버 검색API 키.
NSString* const NAVER_SEARCH_API_KEY = @"7868041a52660445b7e1d4bb4f24709c";//발급 2015.09.08 com.voapp.I_NScreen

// 네이버 검색API(웹문서) 서버 URL.
NSString* const NAVER_SEARCH_API_SERVER_URL = @"http://openapi.naver.com/search?";

// DRM 호출 URL
NSString* const DRM_OPEN_API_SERVER_URL = @"https://api.cablevod.co.kr/api/";

// C&M SMApplicationSever openAPI 서버 IP.
//NSString* const CNM_OPEN_API_SERVER_URL = @"http://58.143.243.91/SMApplicationServer/";
//NSString* const CNM_OPEN_API_SERVER_URL = @"http://192.168.40.5:8080/HApplicationServer/";  // 라이브
NSString* const CNM_OPEN_API_SERVER_URL = @"http://58.141.255.79:8080/HApplicationServer/";  // 라이브
// private 터미널 키 발급 받을땐 테스트를 통해서 ..
NSString* const CNM_OPEN_API_SERVER_URL_VPN = @"http://58.141.255.70:8080/HApplicationServer/"; // 테스트

// Add By BJK
// C&M AirCode Server open API 서버 IP
NSString* const CNM_AIRCODE_OPEN_API_SERVER_URL = @"http://58.141.255.69:8080/nscreen/";
//NSString* const CNM_AIRCODE_OPEN_API_SERVER_URL = @"http://192.168.40.5:8080/HApplicationServer/";
//NSString* const CNM_AIRCODE_OPEN_API_SERVER_URL = @"http://moomin.italks.kr/json/brand/";

// C&M RUMPUS Server open API 서버 IP
NSString* const CNM_RUMPUS_OPEN_API_SERVER_URL = @"http://58.141.255.80/smapplicationserver/";

// C&M RUMPUS Server open API 서버 IP VPN용
NSString* const CNM_RUMPUS_OPEN_API_SERVER_URL_VPN = @"http://192.168.44.10/smapplicationserver/";

// C&M SMApplicationSever openAPI 프로토콜 버전.
//NSString* const CNM_OPEN_API_VERSION = @"SmartMobile_v1.0.0";
NSString* const CNM_OPEN_API_VERSION = @"1";

// 테스트용 터미널Key.
NSString* const CNM_TEST_TERMINAL_KEY = @"FAC7AE9F9936BBFEB468F2F6FBEA240";

// real 테스트용 터미널 Key
NSString* const CNM_REAL_TEST_TERMINAL_KEY = @"9CED3A20FB6A4D7FF35D1AC965F988D2";

/*<!
 WEBHAS 에선 터미널 키가 두개 존재 한다.
 Public 이랑 Private 키가 두개 존재하는데 public 터미널 키는 페어링 하지 않은 사용자가 쓸 터미널 키이고
 private 는 페어링 한 사용자가 서버에서 받은 터미널 키이다.
 현재 테스트용으로 private 도 박아놨지만 차후 서버에서 받아온 터미널 키를 private 엔 대체 하도록.
*/

// public terminalKey
//NSString* const CNM_PUBLIC_TERMINAL_KEY = @"8A5D2E45D3874824FF23EC97F78D358";
NSString* const CNM_PUBLIC_TERMINAL_KEY = @"A9D0D3B07231F38878AB0979D7C315A";

// private terminalKey
NSString* const CNM_PRIVATE_TERMINAL_KEY = @"C5E6DBF75F13A2C1D5B2EFDB2BC940";
 
// 기본 정보(지역코드, 상품코드)
NSString* const CNM_DEFAULT_AREA_CODE = @"12";
NSString* const CNM_DEFAULT_PRODUCT_CODE = @"12";

// ----------------------------------------------------------------------------------
// 미러TV 에러 메시지.
// ----------------------------------------------------------------------------------

NSString* const MIRRORTV_ERROR_MSG_INTRO_2 = @"해당 채널은 미러TV가 지원되지 않습니다.\n※ 지상파 등 일부 채널은 지원되지 않습니다.\n※ 채널 전환 시, 화면 전송이 지연될 수 있습니다.";
NSString* const MIRRORTV_ERROR_MSG_INTRO = @"지상파 채널등 일부 채널은\n미러TV가 지원되지 않습니다.";
NSString* const MIRRORTV_ERROR_MSG_VOD = @"TV는 채널 상태일 경우에만 미러TV가 실행됩니다.";
NSString* const MIRRORTV_ERROR_MSG_OTHERS = @"TV가 채널 상태일 경우에만 미러TV가 실행됩니다.";
NSString* const MIRRORTV_ERROR_MSG_BLOCKING_CHANNEL = @"셋탑박스에서 성인인증 또는 구매 완료 후\n 다시 이용해 주세요.";
NSString* const MIRRORTV_ERROR_MSG_STANBY = @"셋탑박스 전원이 꺼져있습니다.\n전원을 켜신 후 이용바랍니다.";
NSString* const MIRRORTV_ERROR = @"미러TV 영상이 지연되고 있습니다.\n잠시 후 다시 이용해 주십시오.";

// ----------------------------------------------------------------------------------
// C&M SMApplicationSever openAPI Parameter Key.
// ----------------------------------------------------------------------------------
// 체널 지역 코드
// CNM 지역 코드
NSString* const CNM_AREA_CODE = @"0";

// add by bjk
// 영화 애니 tv다시보기 성인 오늘의 추천 categoryId 는 고정으로 박음 됨
// 오늘의 추천
NSString* const CNM_OPEN_API_RECOMEND_CATEGORY_ID = @"713228";

// 영화
NSString* const CNM_OPEN_API_MOVIE_CATEGORY_ID = @"27282";

// 애니
NSString* const CNM_OPEN_API_ANNI_CATEGORY_ID = @"27281";

// TV 다시보기
NSString* const CNM_OPEN_API_TV_REPLAY_CATEGORY_ID = @"27279";

// 성인
NSString* const CNM_OPEN_API_ADULT_CATEGORY_ID = @"20912";

// uuid
NSString* const CNM_OPEN_API_UUID_KEY = @"uuid";

// assetProfile
NSString* const CNM_OPEN_API_ASSET_PROFILE_KEY = @"assetProfile";

// 구매 비밀 번호 로컬 저장
NSString* const CNM_OPEN_API_BUY_PW = @"buyPw";

// 페어링후 셋탑이 PVR 인지 HD 인지 체크 값
NSString* const CNM_OPEN_API_SET_TOP_BOK_KIND = @"SetTopBoxKind";

// version
NSString* const CNM_OPEN_API_VERSION_KEY = @"version";

// terminalID
NSString* const CNM_OPEN_API_TERMINAL_ID_KEY = @"terminalId";

// privateKey
NSString* const CNM_OPEN_API_PRIVATE_TERMINAL_KEY_KEY = @"privateTerminalKey";

// terminalKey
NSString* const CNM_OPEN_API_TERMINAL_KEY_KEY = @"terminalKey";

// transactionID
NSString* const CNM_OPEN_API_TRANSACTION_ID_KEY = @"transactionId";

// categoryProfile
NSString* const CNM_OPEN_API_CATEGORY_PROFILE_KEY = @"categoryProfile";

// traverseType
NSString* const CNM_OPEN_API_TRAVERSE_TYPE_KEY = @"traverseType";

// areaCode
NSString* const CNM_OPEN_API_AREA_CODE_KEY = @"aredCode";

// produceCode
NSString* const CNM_OPEN_API_PRODUCE_CODE_KEY = @"produceCode";

// resultCode
NSString* const CNM_OPEN_API_RESULT_CODE_KEY = @"resultCode";

// resultCode 100(성공)
NSString* const CNM_OPEN_API_RESULT_CODE_SUCCESS_KEY = @"100";

// 검색된 페이지
NSString* const CNM_OPEN_API_RESULT_TOTAL_PAGE = @"totalPage";

// 검색된 리스트수
NSString* const CNM_OPEN_API_RESULT_TOTAL_COUNT = @"totalCount";

// 사용자 정보.
NSString* const CNM_OPEN_API_USER_INFO_KEY = @"UserInfo";

// errorString
NSString* const CNM_OPEN_API_RESULT_ERROR_STRING_KEY = @"errorString";
NSString* const CNM_OPEN_API_RESULT_ERR_STRING_KEY = @"errString";

// ----------------------------------------------------------------------------------
// C&M SMApplicationSever openAPI 인터페이스.
// * Record 관련 인터페이스만 제외됨(TODO: 사용 유무 확인할 것!)
// ----------------------------------------------------------------------------------

// 1. Authenticate
// AuthenticateClient.
NSString* const CNM_OPEN_API_INTERFACE_AuthenticateClient = @"AuthenticateClient";

// GetAppVersionInfo
NSString* const CNM_OPEN_API_INTERFACE_GetAppVersionInfo = @"GetAppVersionInfo";

// GetAppContentVersion
NSString* const CNM_OPEN_API_INTERFACE_GetAppContentVersion = @"GetAppContentVersion";

// ClientSetTopBoxRegist
NSString* const CNM_OPEN_API_INTERFACE_ClientSetTopBoxRegist = @"ClientSetTopBoxRegist";

// CheckRegistUser
NSString* const CNM_OPEN_API_INTERFACE_CheckRegistUser = @"CheckRegistUser";

// AuthenticateAdult
NSString* const CNM_OPEN_API_INTERFACE_AuthenticateAdult = @"AuthenticateAdult";

// RequestAuthCode
NSString* const CNM_OPEN_API_INTERFACE_RequestAuthCode = @"RequestAuthCode";

// 2. Channel
// GetChannelGenre
//NSString* const CNM_OPEN_API_INTERFACE_GetChannelGenre = @"GetChannelGenre";

// GetChannelProduct
NSString* const CNM_OPEN_API_INTERFACE_GetChannelProduct = @"GetChannelProduct";

// GetChannelArea
//NSString* const CNM_OPEN_API_INTERFACE_GetChannelArea = @"GetChannelArea";

//// GetChannelList
//NSString* const CNM_OPEN_API_INTERFACE_GetChannelList = @"GetChannelList";

// GetChannelSchedule
//NSString* const CNM_OPEN_API_INTERFACE_GetChannelSchedule = @"GetChannelSchedule";

// GetChannelMyList
NSString* const CNM_OPEN_API_INTERFACE_GetChannelMyList = @"GetChannelMyList";

// SetMyChannel
NSString* const CNM_OPEN_API_INTERFACE_SetMyChannel = @"SetMyChannel";

// SetMyHiddenChannel
NSString* const CNM_OPEN_API_INTERFACE_SetMyHiddenChannel = @"SetMyHiddenChannel";

// SetMySchedule
NSString* const CNM_OPEN_API_INTERFACE_SetMySchedule = @"SetMySchedule";

// 3. RemoteController & Message
// SetRemoteChannelControl
NSString* const CNM_OPEN_API_INTERFACE_SetRemoteChannelControl = @"SetRemoteChannelControl";

// SetRemoteVolumeControl
NSString* const CNM_OPEN_API_INTERFACE_SetRemoteVolumeControl = @"SetRemoteVolumeControl";

// SetRemotePowerControl
NSString* const CNM_OPEN_API_INTERFACE_SetRemotePowerControl = @"SetRemoteVolumeControl";

// SetRemoteMessage
NSString* const CNM_OPEN_API_INTERFACE_SetRemoteMessage = @"SetRemoteMessage";

// 4. VOD
// GetVodGenre
NSString* const CNM_OPEN_API_INTERFACE_GetVodGenre = @"GetVodGenre";

// GetVodGenreInfo
NSString* const CNM_OPEN_API_INTERFACE_GetVodGenreInfo = @"GetVodGenreInfo";

// GetVodMovie
NSString* const CNM_OPEN_API_INTERFACE_GetVodMovie = @"GetVodMovie";

// GetVodTv
NSString* const CNM_OPEN_API_INTERFACE_GetVodTv = @"GetVodTv";

// GetVodTag
NSString* const CNM_OPEN_API_INTERFACE_GetVodTag = @"GetVodTag";

// GetVodTrailer
NSString* const CNM_OPEN_API_INTERFACE_GetVodTrailer = @"GetVodTrailer";

// GetVodMyList
NSString* const CNM_OPEN_API_INTERFACE_GetVodMyList = @"GetVodMyList";

// SetMyVOD
NSString* const CNM_OPEN_API_INTERFACE_SetMyVOD = @"SetMyVOD";

// SetVodSetTopDisplayInfo
NSString* const CNM_OPEN_API_INTERFACE_SetVodSetTopDisplayInfo = @"SetVodSetTopDisplayInfo";

// Notification
NSString* const CNM_OPEN_API_INTERFACE_Notification = @"Notification";

// Add By BJK
// getPopularityChart
NSString* const CNM_OPEN_API_INTERFACE_GetPopularityChart = @"getPopularityChart";

// getContentGroupList
NSString* const CNM_OPEN_API_INTERFACE_GetContentGroupList = @"getContentGroupList";

// getAssetInfo
NSString* const CNM_OPEN_API_INTERFACE_GetAssetInfo = @"getAssetInfo";

// 5. Search
// SearchChannel
NSString* const CNM_OPEN_API_INTERFACE_SearchChannel = @"SearchChannel";

// SearchProgram
NSString* const CNM_OPEN_API_INTERFACE_SearchProgram = @"SearchProgram";

// SearchVod
NSString* const CNM_OPEN_API_INTERFACE_SearchVod = @"SearchVod";

// SearchWord
NSString* const CNM_OPEN_API_INTERFACE_getSearchWord = @"getSearchWord";

// RecommendContentGroupByAssetId
NSString* const CNM_OPEN_API_INTERFACE_RecommendContentGroupByAssetId = @"recommendContentGroupByAssetId";

// GetBundleProductList
NSString* const CNM_OPEN_API_INTERFACE_GetBundleProductList = @"getBundleProductList";

// Getservicebannerlist
NSString* const CNM_OPEN_API_INTERFACE_GetServiceBannerlist = @"getservicebannerlist";

// getCateogryTree
NSString* const CNM_OPEN_API_INTERFACE_GetCategoryTree = @"getCategoryTree";

// recommendAssetBySubscriber
NSString* const CNM_OPEN_API_INTERFACE_RecommendAssetBySubscriber = @"recommendAssetBySubscriber";

// getAppInitialize
NSString* const CNM_OPEN_API_INTERFACE_GetAppInitialize = @"GetAppInitialize";

// searchContentGroup
NSString* const CNM_OPEN_API_INTERFACE_SearchContentGroup = @"searchContentGroup";

// 6.Service
// GetGuideCategory
NSString* const CNM_OPEN_API_INTERFACE_GetGuideCategory = @"GetGuideCategory";

// GetServiceGuideList
NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideList = @"GetServiceGuideList";

// GetServiceGuideInfo
NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideInfo = @"GetServiceGuideInfo";

// GetServiceGuideImage
NSString* const CNM_OPEN_API_INTERFACE_GetServiceGuideImage = @"GetServiceGuideImage";

// GetServiceJoinNList
NSString* const CNM_OPEN_API_INTERFACE_GetServiceJoinNList = @"GetServiceJoinNList";

// GetServiceJoinNInfo
NSString* const CNM_OPEN_API_INTERFACE_GetServiceJoinNInfo = @"GetServiceJoinNInfo";

// GetServiceNoticeInfo
NSString* const CNM_OPEN_API_INTERFACE_GetServiceNoticeInfo = @"GetServiceNoticeInfo";

// Add By BJK
// 6. Epg
// getChannelList
NSString* const CNM_OPEN_API_INTERFACE_GetChannelList = @"getChannelList";

// getChannelGenre
NSString* const CNM_OPEN_API_INTERFACE_GetChannelGenre = @"getChannelGenre";

// getChannelArea
NSString* const CNM_OPEN_API_INTERFACE_GetChannelArea = @"getChannelArea";

// getChannelSchedule
NSString* const CNM_OPEN_API_INTERFACE_GetChannelSchedule = @"getChannelSchedule";

// searchSchedule
NSString* const CNM_OPEN_API_INTERFACE_SearchSchedule = @"searchSchedule";


// 7. Pairing
// addUser
NSString* const CNM_OPEN_API_INTERFACE_AddUser = @"addUser";

// authenticateDevice
NSString* const CNM_OPEN_API_INTERFACE_AuthenticateDevice = @"authenticateDevice";

// removeUser
NSString* const CNM_OPEN_API_INTERFACE_RemoveUser = @"removeUser";

// 8. pvr
// dev.getrecordlist
//NSString* const CNM_OPEN_API_INTERFACE_DEV_Getrecordlist = @"dev.getrecordlist";
NSString* const CNM_OPEN_API_INTERFACE_DEV_Getrecordlist = @"getrecordlist";


// dev.getrecordReservelist
//NSString* const CNM_OPEN_API_INTERFACE_DEV_GetrecordReservelist = @"dev.getrecordReservelist";
NSString* const CNM_OPEN_API_INTERFACE_DEV_GetrecordReservelist = @"getrecordReservelist";


// 9. MyC&M
// getValidPurchaseLogList
NSString* const CNM_OPEN_API_INTERFACE_GetValidPurchaseLogList = @"getValidPurchaseLogList";

// getWishList
NSString* const CNM_OPEN_API_INTERFACE_GetWishList = @"getWishList";

// remocon
//GetSetTopStatus
NSString* const CNM_OPEN_API_INTERFACE_GetSetTopStatus = @"GetSetTopStatus";


//노티피케이션 네임
NSString* const CNMHandleOpenURLNotification = @"CNMHandleOpenURLNotification";




@implementation STVConstants

@end
