import dom from './lib/dom';
import t from './lib/t';
export default {
	dom: dom,
	/**
	 * @param {String} href
 	 */
	loadCss(href) {
	     var cssLink = $("<link rel='stylesheet' type='text/css' href='"+href+"'>");
	     $('head').append(cssLink);
	 }
	,t: t
}