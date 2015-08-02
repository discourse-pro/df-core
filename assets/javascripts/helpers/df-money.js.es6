import {number_format} from '../lib/string/number_format';
import {sprintf} from '../lib/string/sprintf';
import registerUnbound from 'discourse/helpers/register-unbound';
registerUnbound('df-money', function(amount, params) {
	const CONTENTS = '{contents}';
	const ss = Discourse.SiteSettings;
	const symbol = ss['«Money»_Currency_Symbol'];
	const symbolPosition = ss['«Money»_Currency_Symbol_Position'];
	const delimitSymbolFromAmount = ss['«Money»_Delimit_Currency_Symbol_from_Amount'];
	const decimalSeparator = ss['«Money»_Decimal_Separator'];
	const numberOfDecimals = ss['«Money»_Number_of_Decimals'];
	var thousandsSeparator = ss['«Money»_Thousands_Separator'];
	// 2015-08-02
	// К сожалению, дефект Discourse не позволяет использовать &thinsp; и пустую строку
	// в качестве значений опции напрямую.
	thousandsSeparator = thousandsSeparator.replace('thin_space', '&thinsp;');
	thousandsSeparator = thousandsSeparator.replace('none', '');
	var amountS = "<span class='amount'>" + CONTENTS + "</span>";
	var currencyS = "<span class='currency'>" + CONTENTS + "</span>";
	var moneyS = "<span class='df-money'>" + CONTENTS + "</span>";
	amountS = amountS.replace(CONTENTS, number_format(
		amount, numberOfDecimals, decimalSeparator, thousandsSeparator
	));
	currencyS = currencyS.replace(CONTENTS, symbol);
	const delimiterBetweenSymbolAndAmount = !delimitSymbolFromAmount ? '' : '&thinsp;';
	var moneyContentsA = [amountS, delimiterBetweenSymbolAndAmount, currencyS];
	if ('before' === symbolPosition) {
		moneyContentsA = moneyContentsA.reverse();
	}
	moneyS = moneyS.replace(CONTENTS, moneyContentsA.join(''));
	return new Handlebars.SafeString(moneyS);
});