function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <Root>/CmdLimit */
	this.urlHashMap["rtwdemo_attitude:5"] = "rtwdemo_attitude.c:105,116";
	/* <Root>/DispGain */
	this.urlHashMap["rtwdemo_attitude:6"] = "rtwdemo_attitude.c:80";
	/* <Root>/DispLimit */
	this.urlHashMap["rtwdemo_attitude:7"] = "rtwdemo_attitude.c:71,81";
	/* <Root>/IntGain */
	this.urlHashMap["rtwdemo_attitude:8"] = "rtwdemo_attitude.c:119";
	/* <Root>/Integrator */
	this.urlHashMap["rtwdemo_attitude:33"] = "rtwdemo_attitude.c:38,54,69,118,136&rtwdemo_attitude.h:29,30,31";
	/* <Root>/NotEngaged */
	this.urlHashMap["rtwdemo_attitude:11"] = "rtwdemo_attitude.c:51";
	/* <Root>/RateGain */
	this.urlHashMap["rtwdemo_attitude:12"] = "rtwdemo_attitude.c:101";
	/* <Root>/RateLimit */
	this.urlHashMap["rtwdemo_attitude:13"] = "rtwdemo_attitude.c:86,96";
	/* <Root>/Sum */
	this.urlHashMap["rtwdemo_attitude:14"] = "rtwdemo_attitude.c:82";
	/* <Root>/Sum1 */
	this.urlHashMap["rtwdemo_attitude:15"] = "rtwdemo_attitude.c:95";
	/* <Root>/Sum2 */
	this.urlHashMap["rtwdemo_attitude:16"] = "rtwdemo_attitude.c:100,107,111";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
	RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
