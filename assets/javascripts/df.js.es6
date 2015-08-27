import dom from './lib/dom';
import t from './lib/t';
export default {
	d(variable) {return 'undefined' !== typeof variable;}
	,dom: dom,
	/**
	 * @param {String} href
 	 */
	loadCss(href) {
	     var cssLink = $("<link rel='stylesheet' type='text/css' href='"+href+"'>");
	     $('head').append(cssLink);
	 }
	,t: t
	,u(variable) {return !this.d(variable);}
}