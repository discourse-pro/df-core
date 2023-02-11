export default Ember.Component.extend({
	classNames: ['df-money-editable']
	,onInit: function() {
		const ss = Discourse.SiteSettings;
		const symbol = ss['«Money»_Currency_Symbol'];
		const symbolPosition = ss['«Money»_Currency_Symbol_Position'];
		const delimitSymbolFromAmount = ss['«Money»_Delimit_Currency_Symbol_from_Amount'];
		var currencyS = "<span class='currency'>" + symbol + "</span>";
		var currencyA = [currencyS, !delimitSymbolFromAmount ? '' : '&thinsp;'];
		if ('after' === symbolPosition) {
			currencyA = currencyA.reverse;
		}
		this.set(symbolPosition, Ember.String.htmlSafe(currencyA.join('')));
	}.on('init')
});
