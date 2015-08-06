export default {
	/**
	 * @param {HTMLElement|jQuery} e
	 * @returns {String}
	 */
	outerHtml(e) {return $(e).wrapAll('<div>').parent().html();}
}