export default {
	/**
	 * @param {HTMLElement|HTMLElement[]|jQuery} e
	 * @returns {String}
	 */
	outerHtml(e) {
		var result = '';
		/** @link http://stackoverflow.com/a/1853246 */
		if (e instanceof $) {
			/** @link http://stackoverflow.com/a/5744246 */
			/** @link https://api.jquery.com/clone/ */
			result = $('<div>').append(e.clone()).html();
		}
		else if ($.isArray(e)) {
			// const в таких ситуцациях не работает из-за дефекта transpiler'а
			var _this = this;
			$.each(e, function() {
				result += _this.outerHtml(this);
			});
		}
		else if (!e.tagName) {
			// текстовый узел или комментарий
			result = e.nodeValue;
		}
		/** @link http://stackoverflow.com/a/2483519 */
		/** @link http://caniuse.com/#search=outerHTML */
		else {
			if (e.outerHTML) {
				result = e.outerHTML;
			}
			else {
				const wrapper = document.createElement('div');
				wrapper.appendChild(e.cloneNode(true));
				result = wrapper.innerHTML;
			}
		}
		return result;
	}
}