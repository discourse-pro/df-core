import {number_format} from './t/number_format';
import {sprintf} from './t/sprintf';
export default {
	number_format: number_format
	/**
	 * @param {HTMLElement|jQuery} e
	 * @returns {String}
	 */
	,outerHtml(e) {return $(e).wrapAll('<div>').parent().html();}
	,sprintf: sprintf
}